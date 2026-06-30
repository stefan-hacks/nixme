# ═══════════════════════════════════════════════════════════════════════════════
# HOME/DESKTOP/DEFAULT.NIX - Desktop/GUI Home Manager Settings
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # DCONF / GNOME SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════
  dconf.settings = {
    # Appearance
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "blue";
      enable-hot-corners = false;
      show-battery-percentage = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
      gtk-theme = "adw-gtk3";
      icon-theme = "Papirus-Dark";
    };

    # Window management
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
    };

    # Shell
    "org/gnome/shell" = {
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
      
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
    };

    # Power
    "org/gnome/desktop/session" = {
      idle-delay = 900;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-timeout = 1200;
      sleep-inactive-ac-type = "suspend";
    };

    # Files
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-create-link = true;
      show-delete-permanently = true;
    };

    # Terminal
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
    };

    # Keyboard
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "gb" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
      ];
    };

    # Touchpad
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      speed = 1.0;
      two-finger-scrolling-enabled = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GNOME EXTENSIONS + FONTS
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # Extensions
    gnome-shell-extensions
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes

    # Themes
    adw-gtk3
    papirus-icon-theme
    yaru-theme

    # Apps
    gnome-tweaks
    gnome-extension-manager
    dconf-editor

    # Fonts
    inter
    jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # GTK
  # ═══════════════════════════════════════════════════════════════════════════
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # QT
  # ═══════════════════════════════════════════════════════════════════════════
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };
}
