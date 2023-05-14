{
  config,
  pkgs,
  ...
}: let
  configDir = ../config;
in {
  networking.networkmanager.enable = true;

  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    useXkbConfig = true;
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  services.xserver = {
    enable = true;
    windowManager = {
      bspwm = {
        enable = true;
        configFile = "${configDir}/bspwm/bspwmrc";
        sxhkd = {
          configFile = "${configDir}/sxhkd/sxhkdrc";
        };
      };
    };
    displayManager = {
      lightdm.enable = true;
      lightdm.greeters.mini = {
        enable = true;
      };
      defaultSession = "none+bspwm";
      sessionCommands = ''
        ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
          xterm*faceName: FiraCode Nerd Font
          xterm*faceSize: 20
          Xcursor.theme: Adwaita
          Xcursor.size: 32
        EOF
      '';
    };
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.disableWhileTyping = true;
    };
    xkbOptions = "ctrl:nocaps";
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    # Shadows
    shadow = false;
    # shadowRadius = 18;
    shadowOpacity = 0.90;
    shadowOffsets = [(-23) (-22)];
    shadowExclude = [
      "class_g = 'Rofi'"
    ];

    # Fading
    fade = false;
    fadeSteps = [0.1 0.1];
    fadeDelta = 20;
    fadeExclude = [
      "class_g = 'Rofi'"
    ];
    # Opacity
    inactiveOpacity = 1;
    activeOpacity = 1;
    opacityRules = [
      "100:class_g = 'Alacritty'"
      "100:class_g = 'Rofi'"
    ];
    wintypes = {
      normal = {
        fade = true;
        shadow = true;
      };
      tooltip = {
        fade = false;
        shadow = false;
        focus = true;
        full-shadow = false;
      };
      dock = {
        shadow = false;
        clip-shadow-above = true;
      };
      dnd = {shadow = false;};
    };
    settings = {
      shadow-radius = 18;
      # Corner
      corner-radius = 6;
      rounded-corners-exclude = [
        "window_type = 'dropdown_menu'"
        "window_type = 'popup_menu'"
        "window_type = 'popup'"
        "window_type = 'dock'"
        "class_g = 'Rofi'"
        "class_g = 'Polybar'"
      ];
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "class_g = 'Rofi'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      unredir-if-possible = true;
      glx-no-stencil = true;
      xrender-sync-fence = true;
    };
  };

  hardware.pulseaudio = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    dunst
    libnotify
    (polybar.override {
      pulseSupport = true;
    })
    firefox
    pavucontrol
    alacritty
    rofi
  ];

  programs.light.enable = true;

  programs.dconf.enable = true;
}
