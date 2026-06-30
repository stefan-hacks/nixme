# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/NIXOS/DEFAULT.NIX - NixOS System Configurations (Simplified)
# ═══════════════════════════════════════════════════════════════════════════════
#
# Simplified configuration for Ghost laptop only.
# Commented sections show how to add more hosts in the future.
#
# ═══════════════════════════════════════════════════════════════════════════════

{
  self,
  inputs,
  lib,
  withSystem,
  ...
} @ args: let
  mkHosts = import ./mk_hosts.nix args;
  inherit (mkHosts) foldMapHosts mkSystem;
in {
  flake.nixosConfigurations = foldMapHosts mkSystem [
    # Primary laptop - Ghost (Lenovo ThinkPad P1 Gen 4)
    {
      name = "ghost";
      system = "x86_64-linux";
      home-manager = true;
    }
    
    # ═══════════════════════════════════════════════════════════════════════════
    # FUTURE HOSTS (Add here when needed)
    # ═══════════════════════════════════════════════════════════════════════════
    # {
    #   name = "kali-vm";
    #   system = "x86_64-linux";
    #   vm = true;
    # }
    # {
    #   name = "debian-vm";
    #   system = "x86_64-linux";
    #   vm = true;
    # }
    # {
    #   name = "fedora-vm";
    #   system = "x86_64-linux";
    #   vm = true;
    # }
    # {
    #   name = "nixos-vm";
    #   system = "x86_64-linux";
    #   vm = true;
    # }
    # {
    #   name = "lin-ai";
    #   system = "x86_64-linux";
    # }
  ];
}
