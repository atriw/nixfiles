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
  # Inline modules, move to modules later
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
      xdg.enable = true;
      programs.git.userName = "atriw";
      programs.git.userEmail = "875241499@qq.com";
    };
  };
  wslUsers = {...}: {
    wsl.defaultUser = "atriw";
  };
  wslFcitx5Overlay = {
    nixpkgs.overlays = [
      (self: super: {
        fcitx5-with-addons = super.fcitx5-with-addons.override {
          fcitx5 = super.symlinkJoin {
            name = "fcitx5-disable-wayland";
            paths = [super.fcitx5];
            buildInputs = [super.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/fcitx5 \
                --add-flags "--disable=wayland"
            '';
            inherit (super.fcitx5) version meta;
          };
        };
      })
    ];
  };
  xdgAutoStart = {...}: {
    # This option will generate systemd targets and services,
    # but not start them automaticly.
    #
    # Still need to start them somewhere:
    # /run/current-system/systemd/bin/systemctl start --user xdg-autostart-if-no-desktop-manager.target
    services.xserver.desktopManager.runXdgAutostartIfNone = true;
  };
  sharedModules = [
    home-manager.nixosModules.default
    users
    self.nixosModules.nixos
    self.nixosModules.nix-config
    self.nixosModules.cn
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

            self.nixosModules.wsl
            wslFcitx5Overlay
            xdgAutoStart
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
