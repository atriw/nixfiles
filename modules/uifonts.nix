{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      inter
      source-sans-pro
      source-serif-pro
      (nerdfonts.override {fonts = ["Iosevka" "FiraCode"];})
    ];
    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [
          "Inter"
          "Iosevka"
          "FiraCode Nerd Font"
        ];
        sansSerif = [
          "Source Sans Pro"
        ];
        serif = [
          "Source Serif Pro"
        ];
      };
    };
  };
}
