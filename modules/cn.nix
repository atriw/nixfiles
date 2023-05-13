{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      sarasa-gothic
    ];
    fontconfig.defaultFonts = {
      monospace = [
        "Noto Sans Mono CJK SC"
        "Sarasa Mono SC"
      ];
      sansSerif = [
        "Noto Sans CJK SC"
        "Source Han Sans SC"
      ];
      serif = [
        "Noto Serif CJK SC"
        "Source Han Serif SC"
      ];
    };
  };
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-chinese-addons
      ];
    };
  };
}
