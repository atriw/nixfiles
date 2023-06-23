{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.imperative-doomemacs;
  configDir = ../config;
in {
  options.modules.imperative-doomemacs = {
    enable = mkEnableOption "Doomemacs in imperative setup";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      (ripgrep.override {withPCRE2 = true;})
      gnutls
      fd
      imagemagick
      zstd
      sqlite
      emacs-all-the-icons-fonts
    ];
    programs.emacs = {
      enable = true;
      package = with pkgs; ((emacsPackagesFor emacs).emacsWithPackages
        (epkgs: [epkgs.vterm]));
    };
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

    home.sessionPath = ["$XDG_CONFIG_HOME/emacs/bin"];
    fonts.fontconfig.enable = true;

    home.activation = {
      downloadDoomemacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -d "${config.xdg.configHome}/emacs" ]; then
          ${pkgs.git}/bin/git clone --depth=1 --single-branch https://github.com/doomemacs/doomemacs "${config.xdg.configHome}/emacs"
        fi
      '';
    };
    xdg.configFile = {
      "doom" = {
        source = pkgs.callPackage "${configDir}/doom" {};
        recursive = true;
      };
    };
  };
}
