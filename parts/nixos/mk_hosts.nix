# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/NIXOS/MK_HOSTS.NIX - Host Configuration Generator
# ═══════════════════════════════════════════════════════════════════════════════
#
# This library provides functions for generating NixOS system configurations.
# It's inspired by the upidapi/NixOs repository's mk_hosts.nix pattern.
#
# FUNCTIONS:
# ────────────
# • mkSystem         - Creates a single NixOS system configuration
# • foldMapHosts    - Combines multiple host configurations into one attrset
#
# USAGE:
# ──────
# In parts/nixos/default.nix:
#   mkHosts = import ./mk_hosts.nix args;
#   flake.nixosConfigurations = mkHosts.foldMapHosts mkHosts.mkSystem [
#     { name = "ghost"; system = "x86_64-linux"; }
#   ];
#
# ═══════════════════════════════════════════════════════════════════════════════

args: let
  inherit (args) inputs self lib;
in rec {
  # ═══════════════════════════════════════════════════════════════════════════
  # MKUSER - Creates a Home Manager user configuration
  # ═══════════════════════════════════════════════════════════════════════════
  mkUser = hostname: username: {...}: {
    imports = [
      # Home configuration with automatic username/directory
      {
        home.username = username;
        home.homeDirectory = "/home/${username}";
      }
      
      # Common home modules
      ../../modules/home
      
      # Host-specific home configuration if it exists
      "../../hosts/${hostname}/home.nix"
    ];

    # Let Home Manager manage itself
    programs.home-manager.enable = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GETUSERNAMES - Discovers users from the host's users/ directory
  # ═══════════════════════════════════════════════════════════════════════════
  getUserNames = hostname: let
    hostDir = "../../hosts/${hostname}";
    hasUsers = builtins.pathExists "${hostDir}/users";
  in
    if !hasUsers
    then []
    else
      builtins.map
        (file: lib.removeSuffix ".nix" file)
        (builtins.filter
          (file: lib.hasSuffix ".nix" file)
          (builtins.attrNames (builtins.readDir "${hostDir}/users")));

  # ═══════════════════════════════════════════════════════════════════════════
  # MKUSERS - Creates Home Manager configurations for all users
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
        
        # Generate users from the users/ directory
        users = lib.genAttrs
          (getUserNames hostname)
          (mkUser hostname);
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
  # MKSYSTEM - Creates a complete NixOS system configuration
  # ═══════════════════════════════════════════════════════════════════════════
  mkSystem = {
    name,           # Hostname (e.g., "ghost")
    system,         # System architecture (e.g., "x86_64-linux")
    vm ? false,     # Is this a VM?
    disko ? false,  # Use disko for disk configuration?
    home-manager ? true,  # Enable Home Manager?
  }: {
    "${name}" = withSystem system (
      {pkgs, ...}: let
        # Extra arguments passed to all modules
        extraArgs = {
          inherit inputs self pkgs;
          mlib = inputs.self.libModule args;
          const = inputs.self.const;
          vars = {
            hostname = name;
            username = "stefan-hacks";
            homeDirectory = "/home/stefan-hacks";
            isVM = vm;
          };
        };
      in
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = extraArgs;
          
          modules = [
            # System metadata
            {
              networking.hostName = name;
              system.stateVersion = inputs.self.const.host-metadata.${name}.stateVersion or "26.05";
            }
            
            # NixOS modules
            ../../modules/nixos
            
            # Host-specific configuration
            "../../hosts/${name}"
            
            # Disko (optional)
          ] ++ (mkListIf disko [
            inputs.disko.nixosModules.default
            "../../hosts/${name}/disko.nix"
          ]) ++ (mkListIf home-manager (mkUsers {
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
