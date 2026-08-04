{ pkgs, niriOutputConfig, ... }:

{
  # XDG
  xdg.enable = true;

  # Playerctl
  home.packages = [ pkgs.playerctl ];

  # Wayland session
  home.sessionVariables = {
    GTK_CSD = "0";
    NIXOS_OZONE_WL = "1";
  };

  # Niri
  xdg.configFile."niri/config.kdl".text = ''

    ${niriOutputConfig}

    hotkey-overlay {
        skip-at-startup
    }

    gestures {
        hot-corners {
            off
        }
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
            on
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
        offset 2
        noise 0.02
        saturation 1.0
    }
    spawn-at-startup "obsidian-bar"
    spawn-at-startup "wl-clip-persist" "--clipboard" "regular" "--ignore-event-on-error"

    binds {
        Super+T { spawn "alacritty"; }
        Mod+L { spawn "hyprlock"; }
        Mod+Tab { spawn "obsidian-bar" "launcher"; }
        Mod+D { spawn "thunar"; }
        Mod+W { spawn "google-chrome"; }
        Mod+A { spawn "steam"; }
        Mod+S { spawn "materialgram"; }
        Mod+R { toggle-window-floating; }
        Mod+C { screenshot; }
        Mod+Z { spawn "tauon"; }
        Super+E { toggle-overview; }
        Super+Q { close-window; }
        Super+Left  { focus-column-left; }
        Super+Right { focus-column-right; }
        Super+Down  { focus-window-down; }
        Super+Up    { focus-window-up; }
        Super+F { maximize-column; }
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

        XF86AudioPlay allow-when-locked=true {
            spawn "playerctl" "play-pause";
        }

        XF86AudioPause allow-when-locked=true {
            spawn "playerctl" "play-pause";
        }

        XF86AudioNext allow-when-locked=true {
            spawn "playerctl" "next";
        }

        XF86AudioPrev allow-when-locked=true {
            spawn "playerctl" "previous";
        }

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

        popups {
            geometry-corner-radius 13
            opacity 0.8

            background-effect {
                blur true
                xray false
            }
        }

        focus-ring {
            on
            active-color "#808080"
            inactive-color "#666666"
        }

        border {
            on
            width 1
            active-color "#808080"
            inactive-color "#666666"
        }
    }

    layer-rule {
        match namespace="^awww-daemon$"
        place-within-backdrop true
    }

    layer-rule {
        match namespace="^obsidian-bar-.*$"
        geometry-corner-radius 18

        shadow {
            on
        }

        background-effect {
            blur true
            xray false
        }

        popups {
            geometry-corner-radius 18

            background-effect {
                blur true
                xray false
            }
        }
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
        opacity 1.0
        open-fullscreen true
        variable-refresh-rate true
    }

    window-rule {
        match app-id="steam" title=r#"^notificationtoasts_\d+_desktop$"#
        default-floating-position x=10 y=10 relative-to="bottom-right"
        open-focused false
    }

    cursor {
        xcursor-theme "Bibata-Modern-Classic"
        xcursor-size 16
        hide-after-inactive-ms 9999
        hide-when-typing
    }
  '';


}
