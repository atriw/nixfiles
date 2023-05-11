{
  self,
  lib,
  ...
}: {
  flake = {
    nixosModules = {
      desktop = import ../modules/desktop.nix;
      common = import ../modules/common.nix;
      nixos = import ../modules/nixos.nix;
      nix-config = import ../modules/nix-config.nix;
    };
  };
}
