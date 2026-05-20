{ pkgs, ... }:

let
  hyperxUdevRules = pkgs.writeTextFile {
    name = "hyperx-udev-rules";
    destination = "/lib/udev/rules.d/99-HyperHeadset.rules";
    text = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="06be", TAG+="uaccess"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="06be", TAG+="uaccess"
    '';
  };

  hyperxAudioWatch = pkgs.writeShellApplication {
    name = "hyperx-audio-watch";

    runtimeInputs = with pkgs; [
      pulseaudio
      jq
      gnugrep
      coreutils
    ];

    text = ''
      set +e
      set +o pipefail
      set -u

      CLI="$HOME/.local/bin/hyper_headset_cli"
      POLL="''${POLL:-1}"

      get_sinks() {
        pactl -f json list sinks 2>/dev/null || echo "[]"
      }

      hyperx_sink() {
        get_sinks | jq -r '
          .[]? | objects | select(
            (.name? // "" | test("usb-HP__Inc_HyperX_Cloud_III_S_Wireless.*analog-stereo"; "i")) or
            (.description? // "" | test("HyperX Cloud III S Wireless"; "i")) or
            (.properties?."device.description"? // "" | test("HyperX Cloud III S Wireless"; "i"))
          ) | .name? // ""
        ' 2>/dev/null | head -n 1
      }

      fallback_sink() {
        local sinks
        sinks=$(get_sinks)

        local patterns=(
          'usb-Generic_USB_Audio-00\.HiFi__SPDIF__sink|USB Audio S/PDIF Output'
          'usb-Generic_USB_Audio-00\.HiFi__Speaker__sink|USB Audio Speakers'
          'usb-Generic_USB_Audio-00\.HiFi__Headphones__sink|USB Audio Front Headphones'
          'pci-.*\.hdmi-stereo|Digital Stereo \(HDMI\)'
        )

        for p in "''${patterns[@]}"; do
          local match
          match=$(printf '%s' "$sinks" | jq -r --arg p "$p" '
            .[]? | objects | select(
              (.name? // "" | test($p; "i")) or
              (.description? // "" | test($p; "i")) or
              (.properties?."device.description"? // "" | test($p; "i"))
            ) | .name? // ""
          ' 2>/dev/null | head -n 1)

          if [ -n "$match" ] && [ "$match" != "null" ]; then
            echo "$match"
            return 0
          fi
        done
        return 1
      }

      headset_connected() {
        if [ ! -x "$CLI" ]; then
          echo ""
          return 0
        fi

        local out
        if ! out=$(timeout --kill-after=1s 5s "$CLI" 2>/dev/null); then
          echo ""
          return 0
        fi

        local state
        state=$(printf '%s\n' "$out" | grep -i '^Connected:' | grep -ioE 'true|false' | tr '[:upper:]' '[:lower:]' | head -n 1)

        if [ -n "$state" ]; then
          echo "$state"
        else
          echo ""
        fi
      }

      move_streams() {
        local target="$1"
        [ -n "$target" ] || return 0

        pactl -f json list sink-inputs 2>/dev/null | jq -r '.[]? | objects | .index? // empty' 2>/dev/null | while IFS= read -r input; do
          [ -n "$input" ] && [ "$input" != "null" ] || continue
          pactl move-sink-input "$input" "$target" 2>/dev/null || true
        done
      }

      switch_to() {
        local target="$1"
        [ -n "$target" ] || return 0

        local current
        current=$(pactl -f json info 2>/dev/null | jq -r '.default_sink_name // ""' 2>/dev/null)

        if [ "$current" != "$target" ]; then
          echo "$(date '+%F %T') set-default sink $target"
          pactl set-default-sink "$target" || true
        fi

        move_streams "$target"
      }

      ensure_state() {
        local state="$1"
        local target=""

        if [ "$state" = "true" ]; then
          target=$(hyperx_sink)
        elif [ "$state" = "false" ]; then
          target=$(fallback_sink)
        fi

        if [ -n "$target" ] && [ "$target" != "null" ]; then
          switch_to "$target"
          return 0
        else
          return 1
        fi
      }

      SLEEP_PID=""
      SUBSCRIBE_PID=""

      wake_sleep() {
        if [ -n "''${SLEEP_PID:-}" ]; then
          kill "''${SLEEP_PID}" 2>/dev/null || true
        fi
      }

      cleanup() {
        if [ -n "''${SLEEP_PID:-}" ]; then
          kill "''${SLEEP_PID}" 2>/dev/null || true
        fi
        if [ -n "''${SUBSCRIBE_PID:-}" ]; then
          kill "''${SUBSCRIBE_PID}" 2>/dev/null || true
        fi
      }

      trap wake_sleep USR1
      trap cleanup EXIT INT TERM

      (
        pactl subscribe 2>/dev/null | while read -r line; do
          case "$line" in
            *"sink"*) kill -USR1 $$ 2>/dev/null || true ;;
          esac
        done
      ) &
      SUBSCRIBE_PID=$!

      last_state=""

      while true; do
        state=$(headset_connected)

        if [ "$state" = "true" ] || [ "$state" = "false" ]; then
          if [ "$state" != "$last_state" ]; then
            if ensure_state "$state"; then
              last_state="$state"
            else
              if [ "$state" = "false" ]; then
                 last_state="$state"
              fi
            fi
          elif [ "$state" = "true" ]; then
            current=$(pactl -f json info 2>/dev/null | jq -r '.default_sink_name // ""' 2>/dev/null)
            target=$(hyperx_sink)
            if [ -n "$target" ] && [ "$target" != "null" ] && [ "$current" != "$target" ]; then
               ensure_state "$state"
            fi
          fi
        fi

        sleep "$POLL" &
        SLEEP_PID=$!
        wait "''${SLEEP_PID}" 2>/dev/null || true
        SLEEP_PID=""
      done
    '';
  };
in
{
  services.udev.packages = [ hyperxUdevRules ];

  systemd.user.services.hyperx-audio-watch = {
    description = "HyperX headset audio autoswitch";
    wantedBy = [ "default.target" ];
    wants = [ "pipewire.service" "pipewire-pulse.service" "wireplumber.service" ];
    after = [ "pipewire.service" "pipewire-pulse.service" "wireplumber.service" ];
    unitConfig = {
      ConditionPathExists = "%h/.local/bin/hyper_headset_cli";
    };
    serviceConfig = {
      ExecStart = "${hyperxAudioWatch}/bin/hyperx-audio-watch";
      Restart = "always";
      RestartSec = 2;
      TimeoutStopSec = "3s";
    };
  };
}