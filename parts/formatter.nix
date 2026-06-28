# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/FORMATTER.NIX - Code Formatters
# ═══════════════════════════════════════════════════════════════════════════════
#
# Defines the default formatter for the flake. Run with 'nix fmt'.
#
# USAGE:
# ──────
#   nix fmt          # Format all .nix files in the repository
#
# ═══════════════════════════════════════════════════════════════════════════════

{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    # Use nixfmt for formatting (RFC style)
    formatter = pkgs.nixfmt;
  };
}
