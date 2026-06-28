# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/CONST.NIX - Module Args Injection for Constants
# ═══════════════════════════════════════════════════════════════════════════════
#
# This flake-parts module imports lib/const.nix and injects it into
# the module system's _module.args. This makes 'const' available in all
# modules WITHOUT exporting it as a flake output.
#
# USAGE IN MODULES:
#   { config, pkgs, lib, const, ... }:
#   
#   users.users.stefan-hacks.openssh.authorizedKeys.keys = [
#     const.keys.users.stefan-hacks
#   ];
# ═══════════════════════════════════════════════════════════════════════════════

{lib, ...}: {
  # Inject 'const' into the flake-parts module system's _module.args
  # Path from parts/const.nix to lib/const.nix is ../lib/const.nix
  perSystem = {system, ...}: {
    _module.args.const = import ../lib/const.nix { inherit lib; };
  };
}
