{
  self,
  lib,
  ...
}: {
  flake = {
    nixosModules.desktop = import ../modules/desktop.nix;
    nixosModules.common = import ../modules/common.nix;
    nixosModules.nixos = import ../modules/nixos.nix;
  };
}
