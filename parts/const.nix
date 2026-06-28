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

  # ═══════════════════════════════════════════════════════════════════════════
  # SSH HOST KEYS - Defined in let-scope for proper referencing
  # ═══════════════════════════════════════════════════════════════════════════
  hostKeys = {
    ghost = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@ghost";
    kali-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@kali-vm";
    debian-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@debian-vm";
    fedora-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@fedora-vm";
    lin-ai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@lin-ai";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # USER CONFIGURATION - Primary user for all hosts
  # ═══════════════════════════════════════════════════════════════════════════
  primaryUser = "stefan-hacks";
in {
  # ═══════════════════════════════════════════════════════════════════════════
  # CONSTANTS - Export const for use in modules (NOT as a flake output)
  # ═══════════════════════════════════════════════════════════════════════════
  const = {
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
      inherit hostKeys;

      # Host groupings for easy reference
      all-hosts = hostKeys;
      vms = filterAttrs (name: _: elem name ["kali-vm" "debian-vm" "fedora-vm"]) hostKeys;
      physical = filterAttrs (name: _: elem name ["ghost"]) hostKeys;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # VM SSH PORTS
    # ─────────────────────────────────────────────────────────────────────────
    vm-ssh-ports = {
      kali-vm = 2221;
      debian-vm = 2222;
      fedora-vm = 2223;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # SERVICE PORTS
    # ─────────────────────────────────────────────────────────────────────────
    ports = {
      http = 80;
      https = 443;
      postgres = 5432;
      redis = 6379;
      prometheus = 9090;
      grafana = 3000;
      syncthing = 8384;
      vm-ssh-start = 2220;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # STATIC IPs
    # ─────────────────────────────────────────────────────────────────────────
    ips = {
      localhost = "127.0.0.1";
      ghost = "192.168.1.100";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # USER CONFIGURATION
    # ─────────────────────────────────────────────────────────────────────────
    users = {
      primary = primaryUser;
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
        primary-user = primaryUser;
      };
      kali-vm = {
        description = "Kali Linux VM for penetration testing";
        system = "x86_64-linux";
        stateVersion = "26.05";
        primary-user = primaryUser;
      };
      debian-vm = {
        description = "Debian VM for development";
        system = "x86_64-linux";
        stateVersion = "26.05";
        primary-user = primaryUser;
      };
      fedora-vm = {
        description = "Fedora VM for testing";
        system = "x86_64-linux";
        stateVersion = "26.05";
        primary-user = primaryUser;
      };
      lin-ai = {
        description = "AI/ML workstation";
        system = "x86_64-linux";
        stateVersion = "26.05";
        primary-user = primaryUser;
      };
    };
  };
}
