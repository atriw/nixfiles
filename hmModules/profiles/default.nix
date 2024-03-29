{...}: {
  imports = [
    ../lazyvim.nix
    # ../doomemacs.nix
    # ../imperative-doomemacs.nix
    ../chat.nix
    ../lang/c.nix
    ../lang/js.nix
    ../lang/lua.nix
    ../lang/nix.nix
    ../lang/python.nix
    ../lang/rust.nix
    ../lang/lisp.nix
    ../lang/sh.nix
    ../lang/haskell.nix
    ../lang/zig.nix
    ../shell/tools.nix
    ../shell/zsh.nix
  ];

  modules = {
    lazyvim.enable = true;
    # doomemacs.enable = false;
    # imperative-doomemacs.enable = false;
    shell = {
      tools.enable = true;
      zsh.enable = true;
    };
    lang = {
      c.enable = true;
      js.enable = true;
      lua.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.enable = true;
      lisp.enable = true;
      sh.enable = true;
      haskell.enable = true;
      zig.enable = true;
    };
  };
}
