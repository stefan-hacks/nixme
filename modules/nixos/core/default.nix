# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/CORE/DEFAULT.NIX - Core System Modules
# ═══════════════════════════════════════════════════════════════════════════════
#
# Essential system functionality required for any NixOS installation.
# These modules configure the foundation of the system.
#
# MODULES:
# ────────
# • boot.nix          - Boot loader (GRUB), kernel options
# • networking.nix    - NetworkManager, firewall, SSH
# • nix-settings.nix  - Nix daemon configuration
# • locale.nix        - Timezone, locale, internationalization
# • users.nix         - User accounts and groups
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix-settings.nix
    ./locale.nix
    ./users.nix
  ];
}
