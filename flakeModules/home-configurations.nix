{
  self,
  lib,
  nixpkgs,
  home-manager,
  ...
}: let
  # TODO: Maybe flake-parts can optimize this.
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  flake = {
    homeConfigurations = {
      atriw = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ../hmModules/profiles/default.nix
        ];
      };
    };
  };
}
