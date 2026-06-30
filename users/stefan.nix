# ═══════════════════════════════════════════════════════════════════════════════
# USERS/STEFAN.NIX - User Definition for stefan-hacks
# ═══════════════════════════════════════════════════════════════════════════════
#
# This defines the stefan-hacks user that can be imported by any host.
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  users.users.stefan-hacks = {
    # User identification
    isNormalUser = true;
    description = "Stefan Hacks";
    
    # UID (consistent across all hosts)
    uid = 1000;
    
    # Home directory
    home = "/home/stefan-hacks";
    
    # Shell
    shell = pkgs.bash;
    
    # Groups (base groups - hosts can add more)
    extraGroups = [ 
      "wheel"           # sudo access
      "networkmanager"  # network management
    ];
    
    # SSH authorized keys
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
      # "ssh-ed25519 AAAAC3NzaC... stefan@ghost"
    ];
    
    # Password (use hashed password in production)
    # Use: mkpasswd --method=sha-512
    # initialHashedPassword = "$6$rounds=5000$...";
    
    # Or disable password login (SSH keys only)
    # password = lib.mkForce "!";
  };
  
  # Add stefan-hacks to trusted users for nix
  nix.settings.trusted-users = [ "stefan-hacks" ];
}
