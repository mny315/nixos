{ config, lib, pkgs, ... }:

let
  tunName = "vless0";
  secretFile = "${config.local.vpn.secretsDirectory}/${config.local.vpn.profile}.json";
in
{
  options.local.vpn = {
    profile = lib.mkOption {
      type = lib.types.enum [ "default" "usa" ];
      default = "default";
      description = "VPN outbound profile loaded at service start.";
    };
    secretsDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/home/mny315/.local/share/nixos-secrets";
      description = "Private directory containing default.json and usa.json; keep it outside the repository.";
    };
  };

  config = {
    # The bar controls the system service over D-Bus. Grant only start/stop
    # access to network administrators in an active local desktop session.
    security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id === "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") === "sing-box.service" &&
              (action.lookup("verb") === "start" || action.lookup("verb") === "stop") &&
              subject.local && subject.active && subject.isInGroup("networkmanager")) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    networking.firewall.checkReversePath = false;
    networking.firewall.trustedInterfaces = [ tunName ];
    networking.nftables.enable = true;

    services.sing-box = {
      enable = true;

      settings = {
        log = {
          level = "info";
          timestamp = true;
        };

        dns = {
          servers = [
            {
              type = "https";
              tag = "cloudflare";
              server = "1.1.1.1";
              server_port = 443;
              path = "/dns-query";
              detour = "proxy";
            }
          ];

          final = "cloudflare";
          strategy = "ipv4_only";

          # Нужно, чтобы доменные исключения работали для соединений через TUN.
          reverse_mapping = true;
        };

        inbounds = [
          {
            type = "tun";
            tag = "tun-in";

            interface_name = tunName;
            address = [ "172.19.0.1/30" ];
            mtu = 1500;

            auto_route = true;
            # With an IPv4-only TUN, make IPv6 unreachable instead of bypassing it.
            strict_route = true;
            auto_redirect = true;
            stack = "system";
          }
        ];

        # Read the complete outbound at service start, never during Nix evaluation.
        outbounds = [
          {
            _secret = secretFile;
            quote = false;
          }
          {
            type = "direct";
            tag = "direct";
          }
        ];

        route = {
          auto_detect_interface = true;
          final = "proxy";

          rules = [
            {
              port = 53;
              action = "hijack-dns";
            }

            {
              # Minecraft-сервер и его CNAME идут напрямую.
              domain = [ "siemens.cringe.team" "anycast.joinserver.xyz" ];
              domain_suffix = [ ".siemens.cringe.team" ".joinserver.xyz" ];
              ip_cidr = [ "31.57.117.1/32" ];
              port = [ 25565 25953 ];
              action = "route";
              outbound = "direct";
            }

            {
              # Панель/лаунчер хостинга тоже идут напрямую.
              domain = [ "mgr.hosting-minecraft.pro" ];
              ip_cidr = [ "5.252.32.9/32" ];
              port = [ 443 25565 25953 ];
              action = "route";
              outbound = "direct";
            }

            {
              ip_is_private = true;
              outbound = "direct";
            }
          ];
        };
      };
    };

    # Fail before generating the runtime configuration if the profile is missing
    # or malformed. The leading + reads the private file as root.
    systemd.services.sing-box = {
      unitConfig.RequiresMountsFor = config.local.vpn.secretsDirectory;
      serviceConfig.ExecStartPre = lib.mkBefore [
        "+${pkgs.writeShellScript "check-vpn-profile" ''
          set -eu
          ${pkgs.jq}/bin/jq -e '
            type == "object" and .type == "vless" and .tag == "proxy"
            and (.uuid | type == "string" and length > 0)
          ' ${lib.escapeShellArg secretFile} >/dev/null
        ''}"
      ];
    };
  };
}
