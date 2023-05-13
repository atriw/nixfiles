{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.doomemacs;
  configDir = ../config;
in {
  options = {
    modules.doomemacs = {
      enable = mkEnableOption "Doomemacs";
    };
  };

  config = mkIf cfg.enable {
    programs.doom-emacs = rec {
      enable = true;
      emacsPackage = pkgs.emacs;
      emacsPackagesOverlay = final: prev: {
        vterm = prev.vterm.overrideAttrs (oldAttrs: {
          cmakeFlags = [
            "-DEMACS_SOURCE=${emacsPackage.src}"
            "-DUSE_SYSTEM_LIBVTERM=ON"
          ];
        });
      };
      doomPrivateDir = pkgs.callPackage "${configDir}/doom" {};
      doomPackageDir = let
        filteredPath = builtins.path {
          path = doomPrivateDir;
          name = "doom-private-dir-filtered";
          filter = path: type:
            builtins.elem (baseNameOf path) ["init.el" "packages.el"];
        };
      in
        pkgs.linkFarm "doom-packages-dir" [
          {
            name = "init.el";
            path = "${filteredPath}/init.el";
          }
          {
            name = "packages.el";
            path = "${filteredPath}/packages.el";
          }
          {
            name = "config.el";
            path = pkgs.emptyFile;
          }
        ];
    };

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      emacs-all-the-icons-fonts
      sqlite # for org-roam
    ];
    services.emacs.enable = true;
    services.emacs.client.enable = true;

    xdg.desktopEntries = {
      "org-capture" = {
        name = "Org Capture";
        genericName = "Text Editor";
        mimeType = ["text/english" "text/plain"];
        exec = ''emacsclient --eval "(+org-capture/open-frame)"'';
        icon = "emacs";
        type = "Application";
        terminal = false;
        categories = ["Development" "TextEditor"];
      };
    };
  };
}
