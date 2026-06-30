# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/DESKTOP.NIX - Desktop Applications and GNOME Extensions
# ═══════════════════════════════════════════════════════════════════════════════
#
# GNOME desktop configuration with detailed extension settings.
# All settings are commented out - copy/paste into hosts/ghost/home.nix to enable.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {

  # ═══════════════════════════════════════════════════════════════════════════
  # DCONF SETTINGS - GNOME Configuration
  # ═══════════════════════════════════════════════════════════════════════════
  # These configure GNOME Shell, desktop, and applications.
  # Copy/paste into hosts/ghost/home.nix to enable specific settings.
  
  dconf.settings = {
    # ═══════════════════════════════════════════════════════════════════════════
    # KEYBOARD AND INPUT
    # ═══════════════════════════════════════════════════════════════════════════
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "gb" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
      ];
    };
    
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      speed = 1.0;
      two-finger-scrolling-enabled = true;
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # APPEARANCE AND THEMES
    # ═══════════════════════════════════════════════════════════════════════════
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "blue";
      enable-hot-corners = false;
      show-battery-percentage = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
      # enable-animations = false;  # Disable for performance
      gtk-theme = "adw-gtk3";
      icon-theme = "Papirus-Dark";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
    };
    
    # ═══════════════════════════════════════════════════════════════════════════
    # GNOME SHELL EXTENSIONS - Complete List
    # ═══════════════════════════════════════════════════════════════════════════
    "org/gnome/shell" = {
      # List of enabled extensions (UUIDs)
      enabled-extensions = [
        # Essential extensions
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        
        # Optional extensions (uncomment to enable)
        # "dash-to-dock@micxgx.gmail.com"
        # "arcmenu@arcmenu.com"
        # "blur-my-shell@aunetx"
        # "openbar@neuromorph"
        # "clipboard-indicator@tudmotu.com"
        # "just-perfection-desktop@just-perfection"
      ];
      
      # Favorite apps in dock
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Settings.desktop"
      ];
    };
    
    # ═══════════════════════════════════════════════════════════════════════════
    # EXTENSION-SPECIFIC SETTINGS (Commented Examples)
    # ═══════════════════════════════════════════════════════════════════════════
    
    # # Dash to Dock
    # "org/gnome/shell/extensions/dash-to-dock" = {
    #   dock-position = "BOTTOM";
    #   dash-max-icon-size = 48;
    #   show-apps-at-top = true;
    #   animate-show-apps = true;
    # };
    #
    # # ArcMenu
    # "org/gnome/shell/extensions/arcmenu" = {
    #   menu-layout = "whisker";
    #   menu-button-icon = "start-here-symbolic";
    # };
    #
    # # Blur My Shell
    # "org/gnome/shell/extensions/blur-my-shell" = {
    #   brightness = 0.6;
    #   sigma = 30;
    # };
    #
    # # OpenBar
    # "org/gnome/shell/extensions/openbar" = {
    #   position = "Top";
    #   height = 35.0;
    #   bartype = "Trilands";
    #   autotheme-dark = "Color";
    # };
    #
    # # Clipboard Indicator
    # "org/gnome/shell/extensions/clipboard-indicator" = {
    #   history-size = 20;
    #   cache-size = 20;
    #   notify-on-copy = true;
    # };

    # ═══════════════════════════════════════════════════════════════════════════
    # POWER AND SESSION
    # ═══════════════════════════════════════════════════════════════════════════
    "org/gnome/desktop/session" = {
      idle-delay = 900;  # 15 minutes
    };
    
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-timeout = 1200;
      sleep-inactive-ac-type = "suspend";
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # NAUTILUS (Files)
    # ═══════════════════════════════════════════════════════════════════════════
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-create-link = true;
      show-delete-permanently = true;
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # TERMINAL
    # ═══════════════════════════════════════════════════════════════════════════
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GNOME DESKTOP PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # Core GNOME applications
    gnome.nautilus
    gnome.nautilus-python
    gnome-system-monitor
    gnome-calculator
    gnome-calendar
    gnome-screenshot
    
    # Settings and customization
    gnome-tweaks
    gnome-extension-manager
    dconf-editor
    
    # Themes
    adw-gtk3
    papirus-icon-theme
    yaru-theme
    
    # ═══════════════════════════════════════════════════════════════════════════
    # GNOME EXTENSIONS - Available in nixpkgs
    # ═══════════════════════════════════════════════════════════════════════════
    # Essential
    gnome-shell-extensions  # Base extensions
    gnomeExtensions.appindicator
    gnomeExtensions.user-themes
    
    # Optional (uncomment as needed)
    # gnomeExtensions.dash-to-dock
    # gnomeExtensions.arcmenu
    # gnomeExtensions.blur-my-shell
    # gnomeExtensions.open-bar
    # gnomeExtensions.clipboard-indicator
    # gnomeExtensions.vitals
    # gnomeExtensions.just-perfection
    # gnomeExtensions.quake-terminal
    # gnomeExtensions.quick-settings-audio-panel
    # gnomeExtensions.notification-configurator
    # gnomeExtensions.steal-my-focus-window
    # gnomeExtensions.wallpicker
    # gnomeExtensions.dynamic-music-pill
    # gnomeExtensions.modern-clock
    # gnomeExtensions.desktop-widgets
    # gnomeExtensions.coverflow-alt-tab
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # EXTENSION MANAGER CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  # Enable extensions for extension-manager to activate
  home.file.".config/gnome-extensions/enabled".text = ''
    user-theme@gnome-shell-extensions.gcampax.github.com
    appindicator@rgcjonas.gmail.com
  '';
  
  # ═══════════════════════════════════════════════════════════════════════════
  # COMPLETE EXTENSION LIST (Commented)
  # ═══════════════════════════════════════════════════════════════════════════
  # To enable more extensions, add them to enabled-extensions above
  # and install the corresponding package:
  #
  # Extension Package Name                  UUID
  # ──────────────────────────────────────────────────────────────────────────
  # gnomeExtensions.user-themes            user-theme@gnome-shell-extensions.gcampax.github.com
  # gnomeExtensions.appindicator           appindicator@rgcjonas.gmail.com
  # gnomeExtensions.dash-to-dock             dash-to-dock@micxgx.gmail.com
  # gnomeExtensions.arcmenu                  arcmenu@arcmenu.com
  # gnomeExtensions.blur-my-shell            blur-my-shell@aunetx
  # gnomeExtensions.open-bar                 openbar@neuromorph
  # gnomeExtensions.clipboard-indicator      clipboard-indicator@tudmotu.com
  # gnomeExtensions.vitals                   vitals@corecoding.com
  # gnomeExtensions.just-perfection          just-perfection-desktop@just-perfection
  # gnomeExtensions.quake-terminal           quake-terminal@diegodario88.github.io
  # gnomeExtensions.quick-settings-audio-panel  quick-settings-audio-panel@rayzeq.github.io
  # gnomeExtensions.notification-configurator  notification-configurator@exposedcat
  # gnomeExtensions.steal-my-focus-window     steal-my-focus-window@steal-my-focus-window
  # gnomeExtensions.wallpicker               wallpicker@omarxkhalid.github.io
  # gnomeExtensions.dynamic-music-pill      dynamic-music-pill@andbal
  # gnomeExtensions.modern-clock             modernclock@gnome-port
  # gnomeExtensions.desktop-widgets          desktop-widgets@NiffirgkcaJ.github.com
  # gnomeExtensions.coverflow-alt-tab        CoverflowAltTab@palatis.blogspot.com
  # gnomeExtensions.gpaste                   GPaste@gnome-shell-extensions.gnome.org
  # gnomeExtensions.wifi-signal-plus         wifi-signal-plus@jalil.arfaoui.net
  # gnomeExtensions.dash2dock-lite           dash2dock-lite@icedman.github.com
  #
  # ═══════════════════════════════════════════════════════════════════════════
  # WALLPAPER CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  # Set wallpaper via dconf:
  # "org/gnome/desktop/background" = {
  #   picture-uri = "file:///home/stefan-hacks/Pictures/wallpapers/my-wallpaper.jpg";
  #   picture-uri-dark = "file:///home/stefan-hacks/Pictures/wallpapers/my-wallpaper.jpg";
  # };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # KEYBOARD SHORTCUTS
  # ═══════════════════════════════════════════════════════════════════════════
  # "org/gnome/settings-daemon/plugins/media-keys" = {
  #   custom-keybindings = [
  #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #   ];
  # };
  # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #   name = "Launch Terminal";
  #   binding = "<Control><Alt>t";
  #   command = "kitty";
  # };
}
