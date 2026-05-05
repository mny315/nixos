{ ... }:

{
  xdg.enable = true;

  home.sessionVariables = {
    GTK_CSD = "0";
  };

  xdg.configFile."niri/config.kdl".text = ''

    output "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q3 0x01010101" {
        mode "2560x1440@239.999"
        scale 1
        focus-at-startup
    }

    output "BOE 0x09F9 Unknown" {
        mode "2560x1440@240.003"
        scale 1.25
        focus-at-startup
    }

    hotkey-overlay {
        skip-at-startup
    }

    prefer-no-csd

    input {
        keyboard {
            xkb {
                layout "us,ru"
                options "grp:caps_toggle"
            }
        }

        touchpad {
            tap
            natural-scroll
        }

        mouse {
            scroll-method "on-button-down"
            scroll-button 274
            scroll-button-lock
        }
    }

    layout {
        gaps 3
        background-color "transparent"
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
    }

    overview {
        workspace-shadow {
            off
        }
    }

    animations {
        slowdown 1.0
        window-open {
            duration-ms 400
            curve "ease-out-expo"
        }
        window-close {
            duration-ms 300
            curve "ease-out-quad"
        }
        window-movement {
            spring damping-ratio=0.5 stiffness=400 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=0.5 stiffness=400 epsilon=0.0001
        }
        horizontal-view-movement {
            spring damping-ratio=0.5 stiffness=300 epsilon=0.0001
        }
        workspace-switch {
            spring damping-ratio=0.5 stiffness=400 epsilon=0.0001
        }
        config-notification-open-close {
            duration-ms 300
            curve "ease-out-expo"
        }
    }

    blur {
        passes 3
        offset 3
        noise 0.02
        saturation 1.3
    }

    spawn-sh-at-startup "obsidian-shell"
    spawn-at-startup "wl-clip-persist" "--clipboard" "regular" "--ignore-event-on-error"

    binds {
        Super+T { spawn "wezterm"; }
        Mod+L { spawn "hyprlock"; }
        Mod+Tab { spawn "obsidian-shell" "launcher" "toggle"; } 
        Mod+D { spawn "thunar"; }
        Mod+W { spawn "google-chrome-stable"; }
        Mod+A { spawn "steam"; }
        Mod+S { spawn "kotatogram-desktop"; }
        Mod+R { toggle-window-floating; }
        Mod+C { spawn "hyprshot" "-m" "region"; }
        Mod+Z { spawn "flatpak" "run" "com.github.taiko2k.tauonmb"; }
        Super+E { toggle-overview; }
        Super+Q { close-window; }
        Super+Left  { focus-column-left; }
        Super+Right { focus-column-right; }
        Super+Down  { focus-window-down; }
        Super+Up    { focus-window-up; }
        Super+F { maximize-column; }
        Super+C { center-column; }
        Super+Minus { set-column-width "-10%"; }
        Super+Equal { set-column-width "+10%"; }
        Mod+Return { fullscreen-window; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }

        Super+WheelScrollDown cooldown-ms=150 { focus-column-right; }
        Super+WheelScrollUp   cooldown-ms=150 { focus-column-left; }

        Super+1 { focus-workspace 1; }
        Super+2 { focus-workspace 2; }
        Super+3 { focus-workspace 3; }
        Super+4 { focus-workspace 4; }
        Super+5 { focus-workspace 5; }
        Super+6 { focus-workspace 6; }

        Mod+Shift+E { quit; }

        XF86AudioRaiseVolume allow-when-locked=true {
            spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" "-l" "1.0";
        }

        XF86AudioLowerVolume allow-when-locked=true {
            spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
        }

        XF86AudioMute allow-when-locked=true {
            spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        }
    }

    window-rule {
        opacity 0.8
        draw-border-with-background false
        geometry-corner-radius 13
        clip-to-geometry true

        background-effect {
            blur true
            xray true
        }

        focus-ring {
            on
            width 2
            active-color "#60cdff"
            inactive-color "#3a3f4b"
        }
    }

    layer-rule {
        match namespace="^(awww-daemon|awww-daemon)$"
        place-within-backdrop true
    }

    clipboard {
        disable-primary
    }

    window-rule {
        match app-id="^(mpv|imv)$"
        opacity 1.0
    }

    window-rule {
        match app-id=r#"^steam_app_(\\d+)$"#
        open-fullscreen true
    }

    cursor {
        xcursor-theme "Bibata-Modern-Classic"
        xcursor-size 16
        hide-after-inactive-ms 9999
        hide-when-typing
    }
  '';


}
