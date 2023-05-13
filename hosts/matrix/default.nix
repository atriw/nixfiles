{...}: {
  system.stateVersion = "22.11";

  networking.hostName = "matrix";

  wsl = {
    enable = true;
    nativeSystemd = true;
    startMenuLaunchers = false;
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };
}
