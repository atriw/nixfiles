{...}: {
  system.stateVersion = "22.11";

  networking.hostName = "matrix";

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };
}
