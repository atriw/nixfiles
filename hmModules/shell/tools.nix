{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.tools;
in {
  options = {
    modules.shell.tools = {
      enable = mkEnableOption "Tools";
    };
  };
  config = let
    packages = with pkgs; [
      httpie # curl
      duf # df
      du-dust # du
      tldr # man
      sd # sed
      difftastic # diff
      lnav # browse log files

      fortune
      gum # interactive shell script
      glow # markdown
      sqlite
      unzip
      cloc
      shellcheck
      just # make
      xonsh
      joshuto
    ];
    program_list = [
      "git"
      # "starship"
      "exa" # ls
      "bat" # cat
      "fzf"
      "mcfly"
      "direnv"
      "zellij" # tmux
      "btop" # htop
      "broot" # tree
      "jq"
      "lazygit"
      "pandoc"
      "zoxide" # z
      "chat" # ChatGPT cli
      "helix"
    ];
    configs = {
      git.delta.enable = true;
      git.extraConfig = {
        credential.helper = "store";
      };
      exa.enableAliases = true;
      bat.config = {theme = "TwoDark";};
      fzf.defaultCommand = "rg --files --hidden --glob '!.git'";
      fzf.defaultOptions = ["--height=40%" "--layout=reverse" "--border" "--margin=1" "--padding=1"];
      mcfly.keyScheme = "vim";
      direnv.nix-direnv.enable = true;
      zellij.settings = {
        pane_frames = false;
        default_mode = "locked";
        # default_layout = "compact";
        theme = "catppuccin-frappe";
        themes.catppuccin-frappe = {
          bg = "#626880";
          fg = "#c6d0f5";
          red = "#e78284";
          green = "#a6d189";
          blue = "#8caaee";
          yellow = "#e5c890";
          magenta = "#f4b8e4";
          orange = "#ef9f76";
          cyan = "#99d1db";
          black = "#292c3c";
          white = "#c6d0f5";
        };
      };
      helix.settings = {
        theme = "catppuccin_frappe";
        editor = {
          lsp.display-messages = true;
        };
      };
      broot.settings = {
        verbs = [
          {
            invocation = "edit";
            shortcut = "e";
            execution = "$EDITOR {file}";
          }
        ];
      };
    };
  in
    mkIf cfg.enable {
      home.packages = packages;
      programs = lib.recursiveUpdate (lib.genAttrs program_list (_: {enable = true;})) configs;
    };
}
