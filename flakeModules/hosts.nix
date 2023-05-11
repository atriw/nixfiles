{
  self,
  lib,
  nixpkgs,
  home-manager,
  ...
}: let
  users = {pkgs, ...}: {
    users.users.root.hashedPassword = "*";
    users.users.atriw = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
      ];
      shell = pkgs.zsh;
      password = "nixos";
    };
  };
  hmUsers = {...}: {
    home-manager.users.atriw = {
      imports = [../hmModules/profiles/default.nix];
      home.stateVersion = "22.11";
      home.sessionVariables = {
        EDITOR = "nvim";
        SHELL = "zsh";
      };
      programs.git.userName = "atriw";
      programs.git.userEmail = "875241499@qq.com";
    };
  };
  sharedModules = [users hmUsers home-manager.nixosModules.default];
  # TODO: Maybe flake-parts can optimize this.
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  flake = {
    nixosConfigurations = {
      matrix = pkgs.lib.nixosSystem {
        inherit system;
        modules = sharedModules ++ [../hosts/matrix];
      };
      enigma = pkgs.lib.nixosSystem {
        inherit system;
        modules = sharedModules ++ [../hosts/enigma];
      };
    };
  };
}
