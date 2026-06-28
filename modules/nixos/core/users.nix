# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/USERS.NIX - User Accounts
# ═══════════════════════════════════════════════════════════════════════════════
#
# Defines system user accounts and groups.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, const, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # USER GROUPS
  # ═══════════════════════════════════════════════════════════════════════════
  users.groups = {
    # Standard groups created by NixOS modules
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # USER ACCOUNTS
  # ═══════════════════════════════════════════════════════════════════════════
  users.users = {
    # Primary user: stefan-hacks
    "stefan-hacks" = {
      isNormalUser = true;
      description = "stefan-hacks";
      
      # Add to important groups
      extraGroups = [
        "wheel"           # Admin privileges (sudo)
        "networkmanager"  # Network management
        "video"           # Video/graphics access
        "audio"           # Audio access
        "input"           # Input devices
        "libvirtd"        # Virtualization
        "docker"          # Containers (if enabled)
        "adbusers"        # Android debugging
        "plugdev"         # USB devices
        "disk"            # Disk access
        "power"           # Power management
      ];
      
      # Use Zsh as default shell
      shell = pkgs.zsh;
      
      # SSH authorized keys (from const)
      openssh.authorizedKeys.keys = [
        const.keys.users.stefan-hacks or ""
      ];
    };
    
    # Admin user: lin
    lin = {
      isNormalUser = true;
      description = "lin";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        const.keys.users.lin or ""
      ];
    };
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
}
