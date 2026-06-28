# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/HOME-MANAGER/DEFAULT.NIX - Home Manager Configurations
# ═══════════════════════════════════════════════════════════════════════════════
#
# Defines standalone Home Manager configurations for non-NixOS systems.
# These are separate from the NixOS-integrated Home Manager configurations.
#
# USAGE:
# ──────
# On non-NixOS systems: home-manager switch --flake .#stefan-hacks
#
# ═══════════════════════════════════════════════════════════════════════════════

{
  inputs,
  self,
  withSystem,
  ...
} @ args: {
  flake.homeConfigurations = {
    # Standalone Home Manager configuration for stefan-hacks
    "stefan-hacks" = withSystem "x86_64-linux" (
      {pkgs, ...}: let
        extraArgs = {
          inherit inputs self pkgs;
          mlib = self.libModule args;
          const = self.const;
          vars = {
            hostname = "generic";
            username = "stefan-hacks";
            homeDirectory = "/home/stefan-hacks";
            isVM = false;
          };
        };
      in
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = extraArgs;
          modules = [
            ../../modules/home
            {
              home.username = "stefan-hacks";
              home.homeDirectory = "/home/stefan-hacks";
              home.stateVersion = "26.05";
            }
          ];
        }
    );
  };
}
