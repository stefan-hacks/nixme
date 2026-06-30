# ═══════════════════════════════════════════════════════════════════════════════
# PROFILES/DESKTOP/DEFAULT.NIX - Desktop/GUI Environment
# ═══════════════════════════════════════════════════════════════════════════════
#
# Full desktop environment with GNOME. Import for laptops/workstations.
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # DISPLAY MANAGER - GDM
  # ═══════════════════════════════════════════════════════════════════════════
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GNOME DESKTOP
  # ═══════════════════════════════════════════════════════════════════════════
  services.xserver.desktopManager.gnome = {
    enable = true;
    # Disable extra apps we don't need
    extraGSettingsOverrides = '''';
  };

  # Exclude some default GNOME apps
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    yelp
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # AUDIO - PIPEWIRE
  # ═══════════════════════════════════════════════════════════════════════════
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Disable pulseaudio (using pipewire)
  hardware.pulseaudio.enable = false;

  # ═══════════════════════════════════════════════════════════════════════════
  # BLUETOOTH
  # ═══════════════════════════════════════════════════════════════════════════
  hardware.bluetooth = {
    enable = lib.mkDefault true;
    powerOnBoot = true;
  };
  services.blueman.enable = lib.mkDefault true;

  # ═══════════════════════════════════════════════════════════════════════════
  # PRINTING
  # ═══════════════════════════════════════════════════════════════════════════
  services.printing = {
    enable = lib.mkDefault false;
    drivers = with pkgs; [
      hplip
      gutenprint
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SCANNING
  # ═══════════════════════════════════════════════════════════════════════════
  hardware.sane = {
    enable = lib.mkDefault false;
    extraBackends = with pkgs; [
      sane-airscan
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FONTS
  # ═══════════════════════════════════════════════════════════════════════════
  fonts = {
    packages = with pkgs; [
      # Sans
      inter
      roboto
      open-sans
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      # Serif
      merriweather
      libre-baskerville

      # Mono
      jetbrains-mono
      cascadia-code
      ubuntu-mono

      # Icons
      papirus-icon-theme
      font-awesome
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Inter" "Noto Sans" ];
        serif = [ "Merriweather" "Noto Serif" ];
        monospace = [ "JetBrains Mono" "Cascadia Code" ];
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FLATPAK
  # ═══════════════════════════════════════════════════════════════════════════
  services.flatpak.enable = lib.mkDefault true;

  # ═══════════════════════════════════════════════════════════════════════════
  # DESKTOP PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Core
    nautilus
    gnome-system-monitor
    gnome-calculator
    gnome-calendar
    gnome-screenshot
    gnome-tweaks
    gnome-extension-manager

    # Media
    vlc
    mpv
    obs-studio

    # Graphics
    gimp
    inkscape
    krita

    # Office
    libreoffice
    zotero

    # Communication
    firefox
    thunderbird

    # Utils
    dconf-editor
    pavucontrol
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # GNOME EXTENSIONS
  # ═══════════════════════════════════════════════════════════════════════════
  programs.dconf.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # USER GROUPS
  # ═══════════════════════════════════════════════════════════════════════════
  users.users.stefan-hacks.extraGroups = [ "video" "audio" ];
}
