{...}: {
  imports = [
    ../desktop/apps.nix
    ../desktop/theme.nix
  ];

  modules = {
    desktop.apps.enable = true;
    desktop.theme.enable = true;
  };
}
