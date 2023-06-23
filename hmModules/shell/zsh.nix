{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.zsh;
in {
  options = {
    modules.shell.zsh = {
      enable = mkEnableOption "Zsh";
      vanilla = mkOption {
        default = false;
        example = true;
        description = "Whether to use vanilla zsh";
        type = types.bool;
      };
    };
  };
  config = mkIf cfg.enable {
    programs.zsh = mkMerge [
      {
        enable = true;
        initExtra = ''
          if test -f ~/.zshrc.local; then
            . ~/.zshrc.local
          fi
        '';
        envExtra = ''
          if test -f ~/.zshenv.local; then
            . ~/.zshenv.local
          fi
        '';
      }
      (mkIf (!cfg.vanilla) (let
        omz = pkgs.fetchFromGitHub {
          owner = "ohmyzsh";
          repo = "ohmyzsh";
          rev = "fcceeb666452c5a41b786f3cde9c8635ddde5448";
          sha256 = "sha256-c929KV77wACO0AlEABwOPPz03Za8V4G7RRXalY+zfGg=";
        };
        plugins = [
          "git"
          "git-extras"
        ];
      in {
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        plugins =
          builtins.map (p: {
            name = "ohmyzsh/${p}";
            src = "${omz}/plugins/${p}";
            file = "${p}.plugin.zsh";
          })
          plugins;
      }))
    ];
  };
}
