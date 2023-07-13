{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.lang.zig;
in {
  options = {modules.lang.zig = {enable = mkEnableOption "Zig";};};

  config = mkIf cfg.enable {home.packages = with pkgs; [zig zls];};
}
