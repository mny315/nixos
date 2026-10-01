{ inputs, ... }:

{
  # Keep the package and service settings on the same flake revision.
  imports = [ inputs.hyperx-cloud-3-switchd.nixosModules.default ];
}
