# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/LIB/DEFAULT.NIX - Custom Library Functions
# ═══════════════════════════════════════════════════════════════════════════════
#
# This module provides custom utility functions used throughout the configuration.
# These functions simplify common patterns like creating options, enabling modules,
# and working with configurations.
#
# AVAILABLE FUNCTIONS:
# ──────────────────────
# • mkOpt type default description   - Create an option with type, default, and description
# • mkOpt' type default                - Create an option without description
# • mkBoolOpt default                  - Create a boolean option
# • mkEnableOpt description            - Create an enable option with description
# • enable                             - { enable = true; }
# • disable                            - { enable = false; }
# • enableAnd cfg                      - cfg // { enable = true; }
# • disableAnd cfg                     - cfg // { enable = false; }
#
# USAGE:
# ──────
# In any module that receives specialArgs:
#   { config, pkgs, lib, mlib, ... }:
#   
#   {
#     modules.nixos.suites.base = mlib.enable;
#   }
#
# ═══════════════════════════════════════════════════════════════════════════════

{lib, ...}: let
  inherit (lib) mkOption types;
in {
  # ═══════════════════════════════════════════════════════════════════════════
  # LIBMODULE - Custom library functions (NOT as flake output)
  # ═══════════════════════════════════════════════════════════════════════════
  # Usage in mk_hosts.nix: mlib = (import ../lib/default.nix { inherit lib; }).libModule;
  # Then pass mlib through specialArgs so modules can use it.
  # ═══════════════════════════════════════════════════════════════════════════
  libModule = { config, pkgs, lib, ... }: rec {
    # ═══════════════════════════════════════════════════════════════════════
    # OPTION HELPERS
    # ═══════════════════════════════════════════════════════════════════════
    
    # Create an option with type, default value, and description
    mkOpt = type: default: description:
      mkOption {
        inherit type default description;
      };

    # Create an option without description (for internal use)
    mkOpt' = type: default: mkOpt type default null;

    # Create a boolean option
    mkBoolOpt = mkOpt types.bool;

    # Create an enable option with description
    mkEnableOpt = desc: {
      enable = mkOpt types.bool false desc;
    };

    # ═══════════════════════════════════════════════════════════════════════
    # ENABLE/DISABLE HELPERS
    # ═══════════════════════════════════════════════════════════════════════
    
    # Simple enable/disable values
    enable = {enable = true;};
    disable = {enable = false;};

    # Enable/Disable with additional configuration
    enableAnd = cfg: cfg // {enable = true;};
    disableAnd = cfg: cfg // {enable = false;};
  };
}
