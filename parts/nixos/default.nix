# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/NIXOS/DEFAULT.NIX - NixOS System Configurations
# ═══════════════════════════════════════════════════════════════════════════════
#
# This module defines all NixOS system configurations using a modular approach.
# It uses a custom mk_hosts.nix library for generating host configurations.
#
# HOSTS DEFINED:
# ──────────────
# • ghost        - Primary laptop (Lenovo ThinkPad P1 Gen 4)
# • kali-vm      - Kali Linux VM (port 2221)
# • debian-vm    - Debian VM (port 2222)
# • fedora-vm    - Fedora VM (port 2223)
# • lin-ai       - AI/ML workstation
#
# STRUCTURE:
# ───────────
# Each host in hosts/<hostname>/ contains:
#   • default.nix    - Main host configuration
#   • hardware.nix   - Hardware-specific settings (generated or manual)
#
# ═══════════════════════════════════════════════════════════════════════════════

{
  self,
  inputs,
  lib,
  withSystem,
  ...
} @ args: let
  # Import the host generation library
  mkHosts = import ./mk_hosts.nix args;
  inherit (mkHosts) foldMapHosts mkSystem;
in {
  flake.nixosConfigurations = foldMapHosts mkSystem [
    # Primary laptop
    {
      name = "ghost";
      system = "x86_64-linux";
    }
    # VMs for testing and development
    {
      name = "kali-vm";
      system = "x86_64-linux";
      vm = true;
    }
    {
      name = "debian-vm";
      system = "x86_64-linux";
      vm = true;
    }
    {
      name = "fedora-vm";
      system = "x86_64-linux";
      vm = true;
    }
    # AI/ML workstation
    {
      name = "lin-ai";
      system = "x86_64-linux";
    }
  ];
}
