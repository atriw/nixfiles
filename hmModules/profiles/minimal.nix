{...}: {
  imports = [../shell/zsh.nix ../shell/tools.nix];

  modules = {
    shell = {
      zsh.enable = true;
      tools.enable = true;
    };
  };
}
