{ pkgs, ... }:

{
  # Hyprlock
  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        hide_cursor = true
        ignore_empty_input = true
        immediate_render = true
        text_trim = true
        fail_timeout = 1000
    }

    animations {
        enabled = true
    }

    background {
        monitor =
        path = screenshot
        color = rgba(12, 12, 12, 1.0)

        blur_passes = 3
        blur_size = 8
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.05
    }

    label {
        monitor =
        text = cmd[update:1000] ${pkgs.bash}/bin/bash -lc 'date "+%H:%M"'
        color = rgba(255, 255, 255, 0.96)
        font_size = 78
        font_family = IBM Plex Sans

        position = 0, 270
        halign = center
        valign = center
        zindex = 3

        shadow_passes = 3
        shadow_size = 8
        shadow_color = rgba(0, 0, 0, 0.45)
    }

    label {
        monitor =
        text = cmd[update:60000] ${pkgs.bash}/bin/bash -lc 'date "+%A, %d %B"'
        color = rgba(255, 255, 255, 0.76)
        font_size = 22
        font_family = IBM Plex Sans

        position = 0, 210
        halign = center
        valign = center
        zindex = 3

        shadow_passes = 2
        shadow_size = 6
        shadow_color = rgba(0, 0, 0, 0.35)
    }

    image {
        monitor =
        path = /etc/nixos/hm/dotfiles/images/avatar/avatar.jpg
        size = 162
        rounding = -1
        border_size = 2
        border_color = rgba(255, 255, 255, 0.18)

        position = 0, 40
        halign = center
        valign = center
        zindex = 3

        shadow_passes = 3
        shadow_size = 10
        shadow_color = rgba(0, 0, 0, 0.35)
    }

    input-field {
        monitor =
        size = 330, 60
        outline_thickness = 1
        dots_size = 0.18
        dots_spacing = 0.30
        dots_center = true
        dots_rounding = -1
        dots_text_format = *

        outer_color = rgba(255, 255, 255, 0.18)
        inner_color = rgba(10, 10, 10, 0.42)
        font_color = rgba(255, 255, 255, 0.96)
        check_color = rgba(255, 255, 255, 0.28)
        fail_color = rgba(255, 90, 90, 0.90)
        capslock_color = rgba(255, 255, 255, 0.70)

        fade_on_empty = true
        fade_timeout = 1200
        placeholder_text = Password
        hide_input = false
        rounding = -1
        fail_text = Wrong

        font_family = IBM Plex Sans

        position = 0, -220
        halign = center
        valign = center
        zindex = 2

        shadow_passes = 2
        shadow_size = 8
        shadow_color = rgba(0, 0, 0, 0.25)
    }
  '';
}
