{
  self,
  lib,
  ...
}: {
  perSystem = {
    config,
    self',
    inputs',
    pkgs,
    ...
  }: {
    packages.chat = pkgs.callPackage ../packages/chat {};
  };
}
