{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.lang.haskell;
in {
  options = {modules.lang.haskell = {enable = mkEnableOption "Haskell";};};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (ghc.withPackages (pkgs:
        with pkgs; [
          vector
          unordered-containers
          microlens-platform
          conduit
          foldl
          random
        ]))
      cabal-install
      stack
      haskell-language-server
    ];
  };
}
