# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/NIXOS/MK_HOSTS.NIX - Host Configuration Generator (Simplified)
# ═══════════════════════════════════════════════════════════════════════════════
#
# Simplified for Ghost laptop with stefan-hacks user only.
#
# ═══════════════════════════════════════════════════════════════════════════════

args: let
  inherit (args) inputs self lib withSystem;
  const = import ../../lib/const.nix { inherit lib; };
in rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # MKUSER - Creates Home Manager user configuration for stefan-hacks
  # ═══════════════════════════════════════════════════════════════════════════
  mkUser = hostname: username: {...}: {
    imports = [
      {
        home.username = username;
        home.homeDirectory = "/home/${username}";
      }
      "${self.outPath}/modules/home"
      "${self.outPath}/hosts/${hostname}/home.nix"
    ];
    programs.home-manager.enable = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # MKUSERS - Home Manager for stefan-hacks
  # ═══════════════════════════════════════════════════════════════════════════
  mkUsers = {
    extraArgs,
    hostname,
  }: [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = extraArgs;
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        # Single user: stefan-hacks
        users."stefan-hacks" = mkUser hostname "stefan-hacks";
      };
    }
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # MKLISTIF - Conditionally include a list
  # ═══════════════════════════════════════════════════════════════════════════
  mkListIf = cond: list:
    if cond
    then list
    else [];

  # ═══════════════════════════════════════════════════════════════════════════
  # MKSYSTEM - Creates NixOS system configuration
  # ═══════════════════════════════════════════════════════════════════════════
  mkSystem = {
    name,
    system,
    home-manager ? true,
  }: {
    "${name}" = withSystem system (
      {pkgs, ...}: let
        extraArgs = {
          inherit inputs self const;
          vars = {
            hostname = name;
            username = "stefan-hacks";
            homeDirectory = "/home/stefan-hacks";
          };
        };
      in
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = extraArgs;
          modules = [
            {
              networking.hostName = name;
              system.stateVersion = "26.05";
            }
            "${self.outPath}/hosts/${name}"
            "${self.outPath}/modules/nixos"
          ] ++ (mkListIf home-manager (mkUsers {
            inherit extraArgs;
            hostname = name;
          }));
        }
    );
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FOLDMAPHOSTS - Combines multiple host configurations
  # ═══════════════════════════════════════════════════════════════════════════
  foldMapHosts = f: list:
    builtins.foldl'
      (a: b: a // b)
      {}
      (builtins.map f list);
}
