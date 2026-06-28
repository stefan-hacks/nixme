# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/DESKTOP/GNOME.NIX - GNOME Desktop Environment
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures GNOME desktop with GDM display manager and essential tools.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # X11/WAYLAND
  # ═══════════════════════════════════════════════════════════════════════════
  services.xserver.enable = true;
  
  # Display Manager - GDM (GNOME Display Manager)
  # Note: wayland is enabled by default in GNOME 50+
  services.displayManager.gdm.enable = true;
  
  # Desktop Manager - GNOME
  services.desktopManager.gnome = {
    enable = true;
    # Exclude some default GNOME applications
    extraGSettingsOverridePackages = [ pkgs.gnome-settings-daemon ];
  };

  # Enable PipeWire for audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Use WirePlumber session manager
    wireplumber.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Enable printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # GNOME packages to exclude (to reduce closure size)
  environment.gnome.excludePackages = with pkgs; [
    gnome-connections
    gnome-tour
    epiphany          # Web browser (use Firefox instead)
    geary             # Email client
    evince            # Document viewer (use zathura from home)
  ];

  # System packages for desktop
  environment.systemPackages = with pkgs; [
    # GNOME packages
    adwaita-icon-theme
    gnome-settings-daemon
    gnome-screenshot
    gnome-tweaks
    gnome-shell-extensions
    
    # Desktop utilities
    glib              # gsettings
    desktop-file-utils
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    
    # Fonts
    # Fonts (also in fonts.packages below - kept here for backwards compatibility)
    dejavu_fonts
    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    font-awesome
    
    # Themes
    adw-gtk3
    papirus-icon-theme
  ];

  # Font configuration
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      # Note: noto-fonts-cjk split into sans/serif variants in NixOS 26.05+
      # These provide CJK (Chinese, Japanese, Korean) font support
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # Note: noto-fonts-emoji renamed to noto-fonts-color-emoji in NixOS 26.05
      noto-fonts-color-emoji
      font-awesome
      # Nerd Fonts - Modern icon/glyph fonts for terminals and editors
      # Note: nerdfonts package was removed in NixOS 26.05, now using individual packages
      # These include the base fonts + extra icons/glyphs for Powerline, Devicons, etc.
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.symbols-only
    ];
    
    fontconfig = {
      defaultFonts = {
        # Note: Nerd Font names include "Nerd Font" suffix (e.g., "JetBrainsMono Nerd Font")
        serif = [ "Noto Serif" "DejaVu Serif" ];
        sansSerif = [ "Noto Sans" "DejaVu Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "FiraCode Nerd Font" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Enable dconf
  programs.dconf.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };
}
