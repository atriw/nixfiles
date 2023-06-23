{
  self,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];
  perSystem = {
    config,
    self',
    inputs',
    pkgs,
    ...
  }: {
    overlayAttrs = {
      inherit (config.packages) chat;
      inherit
        (inputs'.latest.legacyPackages)
        neovim-unwrapped
        helix
        catppuccin-gtk
        ;
    };
    packages.chat = pkgs.callPackage ../packages/chat {};
  };
}
