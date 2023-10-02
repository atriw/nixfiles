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
        joshuto
        yazi
        catppuccin-gtk
        zig
        zls
        ;
    };
    packages.chat = pkgs.callPackage ../packages/chat {};
  };
}
