# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/DESKTOP.NIX - Desktop Applications and Settings
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  # ═══════════════════════════════════════════════════════════════════════════
  # GNOME SETTINGS (dconf)
  # ═══════════════════════════════════════════════════════════════════════════
  dconf.settings = {
    # Keyboard
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
      ];
    };
    
    # Interface
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      accent-color = "purple";
      enable-hot-corners = false;
      show-battery-percentage = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
    };
    
    # Wallpaper (if you have custom wallpapers)
    # "org/gnome/desktop/background" = {
    #   picture-uri = "file:///path/to/wallpaper.jpg";
    #   picture-uri-dark = "file:///path/to/wallpaper-dark.jpg";
    # };
    
    # Desktop
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
      workspace-names = [ "1" "2" "3" "4" ];
    };
    
    # Files (Nautilus)
    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
      show-delete-permanently = true;
      default-folder-viewer = "icon-view";
    };
    
    # Screensaver/lock
    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
      lock-activation-enabled = true;
    };
    
    # Session
    "org/gnome/desktop/session" = {
      idle-delay = 300;  # 5 minutes
    };
    
    # Keyboard shortcuts
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    
    # Custom shortcut - Open terminal
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Terminal";
      binding = "<Super>Return";
      command = "kitty";
    };
    
    # Terminal
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # DESKTOP APPLICATIONS
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # File manager
    gnome.nautilus
    gnome.nautilus-python
    
    # Image viewer
    gthumb
    
    # Document viewer
    zathura
    
    # System utilities
    gnome.gnome-system-monitor
    gnome.gnome-calculator
    gnome.gnome-calendar
    gnome.gnome-todo
    gnome.gnome-screenshot
    gnome.gnome-connections
    
    # Settings
    gnome.gnome-settings-daemon
    gnome.gnome-tweaks
    gnome.dconf-editor
    
    # Extensions
    gnome.gnome-shell-extensions
    gnome-extension-manager
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # GNOME EXTENSIONS
  # ═══════════════════════════════════════════════════════════════════════════
  home.file = {
    # Ensure extensions are enabled
    ".config/gnome-extensions".text = ''
      dash-to-dock
      appindicator
      caffeine
      clipboard-indicator
      user-themes
    '';
  };
}
