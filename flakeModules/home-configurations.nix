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
    emacs-overlay
    nix-doom-emacs
    rust-overlay
    ;
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      emacs-overlay.overlays.default
      rust-overlay.overlays.default
      self.overlays.default
    ];
  };
in {
  flake = {
    homeConfigurations = {
      atriw = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nix-doom-emacs.hmModule
          ../hmModules/profiles/default.nix
          {
            home.username = "atriw";
            home.homeDirectory = "/home/atriw";
            home.stateVersion = "22.11";
            home.sessionVariables = {
              EDITOR = "hx";
              SHELL = "zsh";
            };
            programs.git.userName = "atriw";
            programs.git.userEmail = "875241499@qq.com";
          }
        ];
      };
    };
  };
}
