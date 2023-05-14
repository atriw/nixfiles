{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.doomemacs;
  configDir = ../config;

  pinEmacsPackage = {
    prev,
    name,
    owner,
    repo,
    rev,
    sha256,
  }:
    prev.${name}.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
    });
  pinPackages = {
    vertico = {
      skip = true;
      owner = "minad";
      rev = "2ad46196653b8a873adf11aee949d621af8ff6bc";
      sha256 = "sha256-R7MYPn9Co+MT5CQ8+D5F5JBe92GjxEY0v14aPgBLFlg=";
    };
    orderless = {
      owner = "oantolin";
      rev = "8b9af2796fa0eb87eea4140bc08d16880a493803";
      sha256 = "sha256-yHJYdyEUM6rQPVjCXnVFIHwHoMgRjEHBOcwbTmZ6fW0=";
    };
    consult = {
      owner = "minad";
      rev = "6319aec3513cd587a8817269bc32c8283d419710";
      sha256 = "sha256-0ppRvCvk93wzKMU6814LSGV5PlR84zeIvSUcvg5+TLY=";
    };
    compat = {
      skip = true;
      owner = "emacs-compat";
      rev = "cc1924fd8b3f9b75b26bf93f084ea938c06f9615";
      sha256 = "";
    };
    consult-dir = {
      owner = "karthink";
      rev = "d397ca6ea67af4d3c59a330a778affd825f0efd9";
      sha256 = "sha256-ZYxC+0YBwiY0MghbPuCvFR2vxzMxBuoxyOp/jJQs+B0=";
    };
    consult-flycheck = {
      owner = "minad";
      rev = "9b40f136c017fadf6239d7602d16bf73b4ad5198";
      sha256 = "sha256-yh/p6B5HLDCcoCcQQ07lEx7oNIh+tjbHIDD2HsWfYFQ=";
    };
    embark = {
      owner = "oantolin";
      rev = "5d0459d27aa7cf738b5af36cf862723a62bef955";
      sha256 = "sha256-7U94GRmUA+UdqvwSBSEGSwHSpfqaaiKghqg4P4gn85c=";
    };
    embark-consult = {
      repo = "embark-consult";
      owner = "oantolin";
      rev = "5d0459d27aa7cf738b5af36cf862723a62bef955";
      sha256 = "sha256-7U94GRmUA+UdqvwSBSEGSwHSpfqaaiKghqg4P4gn85c=";
    };
    marginalia = {
      owner = "minad";
      rev = "69442c2d9472b665f698f67426cd255f6c0620a3";
      sha256 = "sha256-X5nLRyKqBbkr8WdJa4Cv3foF2VVbLJaIINoiyHWiECE=";
    };
    wgrep = {
      owner = "mhayashi1120";
      repo = "Emacs-wgrep";
      rev = "f9687c28bbc2e84f87a479b6ce04407bb97cfb23";
      sha256 = "sha256-0WwzNuT7S/zfJMgEPYVvik+UVyUD6QxJ+782aP8UEyQ=";
    };
    all-the-icons-completion = {
      owner = "iyefrat";
      rev = "286e2c064a1298be0d8d4100dc91d7a7a554d04a";
      sha256 = "sha256-g3AOUOXUvoGShwt5dIR+BNeTudBUdXaLK/NpSREtA6c=";
    };
    vertico-posframe = {
      skip = true;
      owner = "tumashu";
      rev = "7ca364d319e7ba8ccba26a0d57513f3e66f1b05b";
      sha256 = "sha256-Xp6xNUHY4xraXFmfjokigQ9neWSK3nxN+WRHCHoy3Rk=";
    };
  };
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
      emacsPackagesOverlay = final: prev:
        {
          vterm = prev.vterm.overrideAttrs (oldAttrs: {
            cmakeFlags = [
              "-DEMACS_SOURCE=${emacsPackage.src}"
              "-DUSE_SYSTEM_LIBVTERM=ON"
            ];
          });
        }
        // (lib.mapAttrs (name: value:
          pinEmacsPackage {
            inherit prev name;
            inherit (value) owner rev sha256;
            repo =
              if (value ? repo)
              then value.repo
              else name;
          })
          (lib.filterAttrs (n: v: !((v ? skip) && v.skip)) pinPackages));
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
