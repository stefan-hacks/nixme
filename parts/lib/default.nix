# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/LIB/DEFAULT.NIX - Module Args Injection for Library Functions
# ═══════════════════════════════════════════════════════════════════════════════
#
# This flake-parts module imports lib/libmodule.nix and injects it into
# the module system's _module.args as 'mlib'. This makes the custom
# library functions available in all modules WITHOUT exporting as flake output.
#
# USAGE IN MODULES:
#   { config, pkgs, lib, mlib, ... }:
#   
#   options.myOption = mlib.mkOpt types.str "default" "Description";
# ═══════════════════════════════════════════════════════════════════════════════

{lib, ...}: {
  # Inject 'mlib' into the module system's _module.args
  perSystem = {system, ...}: {
    _module.args.mlib = import ../../lib/libmodule.nix { inherit lib; };
  };
}
