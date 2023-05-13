{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.lang.lisp;
in {
  options = {
    modules.lang.lisp = {
      enable = mkEnableOption "Lisp";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sbcl
    ];
  };
}
