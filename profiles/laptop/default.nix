# PROFILES/LAPTOP/DEFAULT.NIX - Laptop-Specific Configuration
#
# Hardware and power management for laptops. Import after desktop.

{ config, pkgs, lib, ... }:

{
  # POWER MANAGEMENT - TLP
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";
      SATA_LINKPWR_ON_AC = "max_performance";
      SATA_LINKPWR_ON_BAT = "min_power";
      INTEL_GPU_MIN_FREQ_ON_AC = 0;
      INTEL_GPU_MAX_FREQ_ON_AC = 1000000;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1000000;
      INTEL_GPU_MIN_FREQ_ON_BAT = 0;
      INTEL_GPU_MAX_FREQ_ON_BAT = 800000;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 800000;
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_WWAN = 1;
    };
  };

  services.power-profiles-daemon.enable = lib.mkForce false;

  # SUSPEND AND HIBERNATE
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
    extraConfig = "HandlePowerKey suspend\nHandleSuspendKey suspend\nHandleHibernateKey hibernate";
  };

  # BACKLIGHT
  hardware.brillo.enable = true;

  # TOUCHPAD
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      accelSpeed = "0.0";
      disableWhileTyping = true;
    };
  };

  # FIRMWARE UPDATES
  services.fwupd.enable = true;

  # LAPTOP PACKAGES
  environment.systemPackages = with pkgs; [
    powertop
    tlp
    acpi
    lm_sensors
    nvtop
  ];

  # KERNEL MODULES
  boot.kernelModules = [ "thinkpad_acpi" ];

  # USER GROUPS
  users.users.stefan-hacks.extraGroups = [ "video" ];
}
