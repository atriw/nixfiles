{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.lang.sh;
in {
  options = {
    modules.lang.sh = {
      enable = mkEnableOption "Shell";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      shfmt
    ];
  };
}
