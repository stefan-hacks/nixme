# ═══════════════════════════════════════════════════════════════════════════════
# LIB/CONST.NIX - Constants and Configuration Values
# ═══════════════════════════════════════════════════════════════════════════════
#
# Centralized constants for the entire configuration.
# This file is NOT auto-loaded by flake-parts (it's in lib/, not parts/).
# It is imported by parts/const.nix and injected into the module system.
#
# ═══════════════════════════════════════════════════════════════════════════════

{lib}: let
  inherit (builtins) elem;
  inherit (lib.attrsets) filterAttrs;

  # SSH HOST KEYS
  hostKeys = {
    ghost = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@ghost";
    kali-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@kali-vm";
    debian-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@debian-vm";
    fedora-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@fedora-vm";
    lin-ai = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J root@lin-ai";
  };

  primaryUser = "stefan-hacks";
in {
  # SSH KEYS
  keys = {
    users = {
      stefan-hacks = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J stefan-hacks@ghost";
      lin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIhz2GK/XCUj4i6Q5yQ8QO6Zq6i0X5Jq6Jq6Jq6Jq6J lin@ghost";
    };
    inherit hostKeys;
    all-hosts = hostKeys;
    vms = filterAttrs (name: _: elem name ["kali-vm" "debian-vm" "fedora-vm"]) hostKeys;
    physical = filterAttrs (name: _: elem name ["ghost"]) hostKeys;
  };

  # VM SSH PORTS
  vm-ssh-ports = {
    kali-vm = 2221;
    debian-vm = 2222;
    fedora-vm = 2223;
  };

  # SERVICE PORTS
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

  # STATIC IPs
  ips = {
    localhost = "127.0.0.1";
    ghost = "192.168.1.100";
  };

  # USERS
  users = {
    primary = primaryUser;
    admin = "lin";
  };

  # HOST METADATA
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
}
