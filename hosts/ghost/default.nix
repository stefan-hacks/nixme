# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/DEFAULT.NIX - Ghost Laptop Configuration (Simplified)
# ═══════════════════════════════════════════════════════════════════════════════
#
# Main entry point for the Ghost laptop (Lenovo ThinkPad P1 Gen 4).
# Simplified for stefan-hacks daily driver use.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, inputs, vars, const, mlib, ... }:

{
  imports = [
    ./hardware.nix
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # HOST METADATA
  # ═══════════════════════════════════════════════════════════════════════════
  networking.hostName = "ghost";
  system.stateVersion = "26.05";
  
  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT CONFIGURATION - GRUB
  # ═══════════════════════════════════════════════════════════════════════════
  boot.loader.grub = {
    enable = true;
    # EFI support (Ghost uses UEFI)
    device = "nodev";
    efiSupport = true;
    # Enable os-prober to detect other OS installations
    useOSProber = true;
    # Keep last 20 generations
    configurationLimit = 20;
    # Theme settings (can add custom theme later)
    # theme = pkgs.sleek-grub-theme;  # Optional: custom theme
    # font size for high-DPI
    fontSize = 24;
  };
  
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  
  boot.loader.timeout = 5;
  
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # SSD optimizations
  boot.kernelParams = [
    "nohibernate"      # Disable hibernate for LUKS
    "elevator=none"    # Use MQ-BFQ scheduler
    "quiet"            # Quiet boot
    "splash"           # Show boot splash
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # LAPTOP-SPECIFIC PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Power management
    powertop
    tlp
    acpi
    
    # ThinkPad firmware
    linux-firmware
    
    # Hardware monitoring
    lm_sensors
    pciutils
    usbutils
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # LAPTOP OPTIMIZATIONS
  # ═══════════════════════════════════════════════════════════════════════════
  # Power management
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      # Battery charge thresholds (ThinkPad feature)
      # START_CHARGE_THRESH_BAT0 = 40;
      # STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  
  # Disable power-profiles-daemon (conflicts with TLP)
  services.power-profiles-daemon.enable = lib.mkForce false;
  
  # Enable brightness control
  hardware.brillo.enable = true;
  
  # Enable touchpad support
  services.libinput.enable = true;
  
  # ═══════════════════════════════════════════════════════════════════════════
  # FUTURE ADDITIONS (Commented - uncomment as needed)
  # ═══════════════════════════════════════════════════════════════════════════
  
  # # BLUETOOTH
  # hardware.bluetooth = {
  #   enable = true;
  #   powerOnBoot = true;
  # };
  # services.blueman.enable = true;
  
  # # PRINTING
  # services.printing = {
  #   enable = true;
  #   drivers = [ pkgs.hplip ];
  # };
  
  # # SCANNING
  # hardware.sane = {
  #   enable = true;
  #   extraBackends = [ pkgs.sane-airscan ];
  # };
  
  # # WEBCAM
  # boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
}
