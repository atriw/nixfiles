{
  self,
  lib,
  ...
}: {
  flake = {
    nixosModules.desktop = import ../modules/desktop.nix;
  };
}
