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
      yazi
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
      "tmux"
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
      tmux.terminal = "screen-256color";
      tmux.escapeTime = 10;
      tmux.plugins = with pkgs; [
        tmuxPlugins.cpu
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60'
          '';
        }
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'frappe'
          '';
        }
      ];
      tmux.extraConfig = ''
        set-option -sa terminal-features ',xterm-256color:RGB'
      '';
    };
  in
    mkIf cfg.enable {
      home.packages = packages;
      programs = lib.recursiveUpdate (lib.genAttrs program_list (_: {enable = true;})) configs;
    };
}
