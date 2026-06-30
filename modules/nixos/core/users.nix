# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/USERS.NIX - User Accounts (Simplified)
# ═══════════════════════════════════════════════════════════════════════════════
#
# Single user configuration: stefan-hacks
# Commented sections show how to add more users in the future.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, const, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM-WIDE SHELL CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  programs.bash.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # USER GROUPS
  # ═══════════════════════════════════════════════════════════════════════════
  users.groups = {
    # Standard groups created by NixOS modules
    # Add custom groups here if needed
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # USER ACCOUNTS
  # ═══════════════════════════════════════════════════════════════════════════
  users.users = {
    # Primary user: stefan-hacks
    "stefan-hacks" = {
      isNormalUser = true;
      description = "stefan-hacks";
      
      # User groups for permissions
      extraGroups = [
        "wheel"           # Admin privileges (sudo)
        "networkmanager"  # Network management
        "video"           # Video/graphics access
        "audio"           # Audio access
        "input"           # Input devices
        "libvirtd"        # Virtualization
        "docker"          # Containers
        "adbusers"        # Android debugging
        "plugdev"         # USB devices
        "disk"            # Disk access
        "power"           # Power management
        "kvm"             # Kernel-based VMs
      ];
      
      # Default shell
      shell = pkgs.bash;
      
      # SSH authorized keys (from const)
      openssh.authorizedKeys.keys = [
        const.keys.users.stefan-hacks or ""
      ];
    };
    
    # ═══════════════════════════════════════════════════════════════════════════
    # FUTURE USERS (Commented - add when needed)
    # ═══════════════════════════════════════════════════════════════════════════
    # Admin user: lin
    # lin = {
    #   isNormalUser = true;
    #   description = "lin";
    #   extraGroups = [ "wheel" "networkmanager" ];
    #   shell = pkgs.bash;
    #   openssh.authorizedKeys.keys = [
    #     const.keys.users.lin or ""
    #   ];
    # };
    #
    # Guest user example:
    # guest = {
    #   isNormalUser = true;
    #   description = "Guest User";
    #   extraGroups = [ "networkmanager" ];
    #   shell = pkgs.bash;
    # };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SUDO CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  security.sudo = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];  # Passwordless sudo for wheel group
      }];
    }];
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # ADDITIONAL USER CONFIGURATION OPTIONS (Commented)
  # ═══════════════════════════════════════════════════════════════════════════
  # users.users.stefan-hacks = {
  #   # Set initial password (for first login, change immediately)
  #   initialPassword = "changeme";
  #   
  #   # Or set a hashed password (generated with: mkpasswd -m sha-512)
  #   hashedPassword = "$6$rounds=500000$...";
  #   
  #   # Create home directory on first login
  #   createHome = true;
  #   
  #   # Home directory permissions
  #   homeMode = "700";
  #   
  #   # UID (auto-assigned if not specified)
  #   uid = 1000;
  #   
  #   # Additional packages available only to this user
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  # };
}
