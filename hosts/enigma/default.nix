{...}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "22.11";

  time.timeZone = "Asia/Shanghai";

  networking.proxy.default = "http://192.168.50.108:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
