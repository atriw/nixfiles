{
  self,
  lib,
  inputs,
  ...
}: let
  inherit
    (inputs)
    nixpkgs
    home-manager
    nix-doom-emacs
    nixos-hardware
    nixos-wsl
    emacs-overlay
    rust-overlay
    ;
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
  hmUsers = withDesktop: {...}: {
    home-manager.users.atriw = {
      imports =
        [
          nix-doom-emacs.hmModule
          ../hmModules/profiles/default.nix
        ]
        ++ lib.optional withDesktop ../hmModules/profiles/desktop.nix;
      nixpkgs.overlays = [
        emacs-overlay.overlays.default
        rust-overlay.overlays.default
        self.overlays.default
      ];
      home.stateVersion = "22.11";
      home.sessionVariables = {
        EDITOR = "nvim";
        SHELL = "zsh";
      };
      programs.git.userName = "atriw";
      programs.git.userEmail = "875241499@qq.com";
    };
  };
  wslUsers = {...}: {
    wsl.defaultUser = "atriw";
  };
  sharedModules = [
    home-manager.nixosModules.default
    users
    self.nixosModules.nixos
  ];
  system = "x86_64-linux";
in {
  flake = {
    nixosConfigurations = {
      matrix = nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          sharedModules
          ++ [
            nixos-wsl.nixosModules.wsl
            wslUsers
            (hmUsers false)
            ../hosts/matrix
          ];
      };
      enigma = nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          sharedModules
          ++ [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc
            nixos-hardware.nixosModules.common-pc-laptop
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            (hmUsers true)
            ../hosts/enigma

            self.nixosModules.desktop
          ];
      };
    };
  };
}
