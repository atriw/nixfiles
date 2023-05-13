{
  self,
  lib,
  ...
}: {
  flake = {
    nixosModules = {
      nixos = import ../modules/nixos.nix;
      nix-config = import ../modules/nix-config.nix;
      desktop = import ../modules/desktop.nix;
      wsl = import ../modules/wsl.nix;
      cn = import ../modules/cn.nix;
    };
  };
}
