# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/VIRTUALIZATION/DEFAULT.NIX - Virtualization and Containers
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  imports = [
    ./qemu.nix
    ./containers.nix
  ];
}
