# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/BASH.NIX - Bash Shell Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  programs.bash = {
    enable = true;
    completion.enable = true;
  };
  
  environment.shellAliases = lib.mkDefault {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "c" = "clear";
    "q" = "exit";
    "nrs" = "sudo nixos-rebuild switch --flake";
    "nrt" = "sudo nixos-rebuild test --flake";
    "nrb" = "sudo nixos-rebuild build --flake";
    "nfu" = "nix flake update";
    "nfl" = "nix flake lock";
    "nfc" = "nix flake check";
    "nb" = "nix build";
    "ns" = "nix shell";
    "ngc" = "nix-collect-garbage -d";
    "nsr" = "nix search nixpkgs";
  };
  
  environment.systemPackages = with pkgs; [ bash-completion blesh ];
}
