# ═══════════════════════════════════════════════════════════════════════════════
# LIB/LIBMODULE.NIX - Custom Library Functions
# ═══════════════════════════════════════════════════════════════════════════════
#
# These functions are imported by parts/lib/default.nix and injected
# into the module system via _module.args as 'mlib'.
# ═══════════════════════════════════════════════════════════════════════════════

{lib}: let
  inherit (lib) mkOption types;
in {
  # ═══════════════════════════════════════════════════════════════════════════
  # OPTION HELPERS
  # ═══════════════════════════════════════════════════════════════════════════
  
  mkOpt = type: default: description:
    mkOption {
      inherit type default description;
    };

  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkEnableOpt = desc: {
    enable = mkOpt types.bool false desc;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ENABLE/DISABLE HELPERS
  # ═══════════════════════════════════════════════════════════════════════════
  
  enable = {enable = true;};
  disable = {enable = false;};

  enableAnd = cfg: cfg // {enable = true;};
  disableAnd = cfg: cfg // {enable = false;};
}
