{...}: {
  system.stateVersion = "22.11";

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };
}
