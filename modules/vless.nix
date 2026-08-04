{ pkgs, lib, ... }:

{
  # VLESS tools
  environment.systemPackages = with pkgs; [
    sing-box
    iproute2
    nftables
    curl
  ];

  # Firewall
  networking.firewall.checkReversePath = false;
  networking.firewall.trustedInterfaces = [ "vless0" ];
  networking.nftables.enable = true;

  # Polkit
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id != "org.freedesktop.systemd1.manage-units" || !subject.isInGroup("wheel")) {
        return;
      }

      var unit = action.lookup("unit");
      var verb = action.lookup("verb");

      if (unit == "sing-box.service" && (verb == "start" || verb == "stop")) {
        return polkit.Result.YES;
      }

      if (unit == "NetworkManager.service" && verb == "restart") {
        return polkit.Result.YES;
      }
    });
  '';

  # Sing-box
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

        # Нужно для TUN: sing-box запоминает, какой IP был выдан для домена,
        # и потом route.rules с domain/domain_suffix реально начинают матчиться.
        reverse_mapping = true;
      };

      inbounds = [
        {
          type = "tun";
          tag = "tun-in";

          interface_name = "vless0";
          address = [ "172.19.0.1/30" ];
          mtu = 1500;

          auto_route = true;
          strict_route = false;
          auto_redirect = true;
          stack = "system";
        }
      ];

      outbounds = [
        {
          type = "vless";
          tag = "proxy";

          server = "185.172.129.52";
          server_port = 19145;
          uuid = "ea0ea66a-5aa6-4eb6-af8b-cfa0fdeb3d46";

          transport = {
            type = "httpupgrade";
            host = "www.amd.com";
            path = "/";
          };
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
            # Исключение для игрового сервера по имени.
            # siemens.cringe.team в DNS уходит CNAME-ом в anycast.joinserver.xyz,
            # поэтому матчить нужно и исходное имя, и конечную CNAME-цель.
            # Фактический A из лога: anycast.joinserver.xyz -> 31.57.117.1.
            domain = [ "siemens.cringe.team" "anycast.joinserver.xyz" ];
            domain_suffix = [ ".siemens.cringe.team" ".joinserver.xyz" ];
            ip_cidr = [ "31.57.117.1/32" ];
            port = [ 25565 25953 ];
            action = "route";
            outbound = "direct";
          }

          {
            # Фактическая цель из журнала: mgr.hosting-minecraft.pro -> 5.252.32.9.
            # 443 нужен для HTTPS-запросов лаунчера/хостинга, 25565/25953 — игровые порты.
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

  # NetworkManager
  # Не блокируем загрузку ожиданием «готового интернета»: без sing-box он всё равно
  # не появится. NetworkManager и sing-box стартуют параллельно.
  systemd.services.NetworkManager-wait-online = {
    enable = false;
    wantedBy = lib.mkForce [ ];
  };

  # Sing-box service
  systemd.services.sing-box = {
    wantedBy = lib.mkForce [ "multi-user.target" ];

    requires = lib.mkForce [ ];
    wants = lib.mkForce [ ];
    after = lib.mkForce [ ];

    unitConfig.StartLimitIntervalSec = 0;

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "1s";

      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_RAW"
      ];

      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
        "CAP_NET_RAW"
      ];
    };
  };
}
