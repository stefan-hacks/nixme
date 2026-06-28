# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/CONST.NIX - Constants and Configuration Values
# ═══════════════════════════════════════════════════════════════════════════════
#
# Centralized constants for the entire configuration.
# Includes SSH keys, WireGuard keys, ports, IPs, and other static values.
#
# WHY CENTRALIZE?
# ────────────────
# • Single source of truth for values used across multiple modules
# • Easy to update values in one place
# • Prevents duplication and inconsistencies
# • Makes it easy to reference from both NixOS and Home Manager modules
#
# SECURITY NOTE:
# ───────────────
# This file contains PUBLIC keys only. Private keys and secrets should be
# managed via sops-nix and stored in the secrets/ directory.
#
# ═══════════════════════════════════════════════════════════════════════════════

{lib, ...}: let
  inherit (builtins) elem;
  inherit (lib.attrsets) filterAttrs;
  
  # Helper to filter attribute lists
  filterAttrsList = inp: white_list: (filterAttrs (x: elem white_list x) inp);
in {
  flake = {
    # ═══════════════════════════════════════════════════════════════════════════
    # CONSTANTS - Available as 'const' in modules
    # ═══════════════════════════════════════════════════════════════════════════
    const = rec {
      # ─────────────────────────────────────────────────────────────────────────
      # SSH KEYS
      # ─────────────────────────────────────────────────────────────────────────
      keys = {
        # User SSH public keys
        users = {
          stefan-hacks = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J stefan-hacks@ghost";
          lin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J lin@ghost";
        };

        # Host SSH public keys (for host-based authentication and known_hosts)
        hosts = {
          ghost = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@ghost";
          kali-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@kali-vm";
          debian-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@debian-vm";
          fedora-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@fedora-vm";
          lin-ai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@lin-ai";
        };

        # Host groupings for easy reference
        all-hosts = filterAttrsList hosts [];
        vms = filterAttrsList hosts ["kali-vm" "debian-vm" "fedora-vm"];
        physical = filterAttrsList hosts ["ghost"];
      };

      # ─────────────────────────────────────────────────────────────────────────
      # VM SSH PORTS
      # ─────────────────────────────────────────────────────────────────────────
      # SSH ports for VMs running on Ghost laptop
      vm-ssh-ports = {
        kali-vm = 2221;
        debian-vm = 2222;
        fedora-vm = 2223;
      };

      # ─────────────────────────────────────────────────────────────────────────
      # SERVICE PORTS
      # ─────────────────────────────────────────────────────────────────────────
      ports = {
        # Development
        http = 80;
        https = 443;
        
        # Databases
        postgres = 5432;
        redis = 6379;
        
        # Monitoring
        prometheus = 9090;
        grafana = 3000;
        
        # Sync
        syncthing = 8384;
        
        # VM services
        vm-ssh-start = 2220;  # Base port for VM SSH (2221, 2222, etc.)
      };

      # ─────────────────────────────────────────────────────────────────────────
      # STATIC IPs
      # ─────────────────────────────────────────────────────────────────────────
      ips = {
        localhost = "127.0.0.1";
        ghost = "192.168.1.100";  # Update with actual IP
      };

      # ─────────────────────────────────────────────────────────────────────────
      # USER CONFIGURATION
      # ─────────────────────────────────────────────────────────────────────────
      users = {
        primary = "stefan-hacks";
        admin = "lin";
      };

      # ─────────────────────────────────────────────────────────────────────────
      # HOST CONFIGURATION
      # ─────────────────────────────────────────────────────────────────────────
      host-metadata = {
        ghost = {
          description = "Primary laptop - Lenovo ThinkPad P1 Gen 4";
          system = "x86_64-linux";
          stateVersion = "26.05";
          primary-user = users.primary;
        };
        kali-vm = {
          description = "Kali Linux VM for penetration testing";
          system = "x86_64-linux";
          stateVersion = "26.05";
          primary-user = users.primary;
        };
        debian-vm = {
          description = "Debian VM for development";
          system = "x86_64-linux";
          stateVersion = "26.05";
          primary-user = users.primary;
        };
        fedora-vm = {
          description = "Fedora VM for testing";
          system = "x86_64-linux";
          stateVersion = "26.05";
          primary-user = users.primary;
        };
        lin-ai = {
          description = "AI/ML workstation";
          system = "x86_64-linux";
          stateVersion = "26.05";
          primary-user = users.primary;
        };
      };
    };
  };
}
