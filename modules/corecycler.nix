{ inputs, ... }:

{
  imports = [ inputs.corecycler.nixosModules.default ];

  services.corecycler = {
    enable = true;
    deviceAccessUser = "mny315";
    unfreeBackends = true;
    nct6683 = true;
  };
  # CoreCycler enforces per-core affinity through AllowedCPUs scopes.
  # systemd's default user@ delegation omits cpuset.
  systemd.services."user@".serviceConfig.Delegate = [ "cpu" "cpuset" "memory" "pids" ];
}
