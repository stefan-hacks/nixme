# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/BOOT.NIX - Boot Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures the boot loader (GRUB) and kernel parameters.
# Uses GRUB for LUKS encryption support (systemd-boot has limitations).
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT LOADER - GRUB
  # ═══════════════════════════════════════════════════════════════════════════
  boot.loader = {
    # Use GRUB 2 for LUKS support
    grub = {
      enable = true;
      
      # Target device(s) for GRUB installation
      # For UEFI systems, use efiSupport instead
      device = lib.mkDefault "nodev";  # Set per-host in hardware.nix
      
      # UEFI support
      efiSupport = true;
      # Note: Removed efiInstallAsRemovable - conflicts with canTouchEfiVariables
      
      # Enable os-prober to detect other OS installations
      useOSProber = true;
      
      # Theme and appearance
      # Keep last 20 generations
      configurationLimit = 20;
      
      # Extra GRUB entries
      extraEntries = ''
        # Recovery entry
        menuentry "NixOS Recovery" {
          linux /nix/var/nix/profiles/system-recovery/kernel console=tty0
          initrd /nix/var/nix/profiles/system-recovery/initrd
        }
      '';
    };
    
    # EFI configuration
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    
    # Timeout for boot menu
    timeout = 5;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # KERNEL CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  boot = {
    # Use latest kernel for newer hardware support
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    
    # Kernel parameters
    kernelParams = [
      # Quiet boot (reduce verbose output)
      "quiet"
      "splash"
      
      # Security
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
      
      # Performance
      "nowatchdog"
    ];
    
    # Kernel modules to load at boot
    kernelModules = [
      # TPM support
      "tpm"
      "tpm_crb"
      
      # Better power management
      "acpi_call"
    ];
    
    # Extra module packages
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];
    
    # Initrd (initial ramdisk) configuration
    initrd = {
      # Available kernel modules in initrd
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      
      # LUKS configuration is typically in hardware-configuration.nix
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # CLEANUP
  # ═══════════════════════════════════════════════════════════════════════════
  # Note: boot.loader.grub.configurationLimit is set above in the grub section
}
