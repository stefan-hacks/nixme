# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/LOCALE.NIX - Locale and Internationalization
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures timezone, keyboard layout, locale, and language settings.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # TIMEZONE
  # ═══════════════════════════════════════════════════════════════════════════
  time.timeZone = "Australia/Perth";

  # ═══════════════════════════════════════════════════════════════════════════
  # LOCALE
  # ═══════════════════════════════════════════════════════════════════════════
  i18n = {
    defaultLocale = "en_AU.UTF-8";
    
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # KEYBOARD
  # ═══════════════════════════════════════════════════════════════════════════
  # Console keyboard layout
  console = {
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  # X11 keyboard layout (for desktop environments)
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
      options = "";
    };
  };
}
