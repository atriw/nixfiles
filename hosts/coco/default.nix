{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/virtualbox-demo.nix")
  ];

  networking.hostName = "coco";
}
