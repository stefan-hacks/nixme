# ═══════════════════════════════════════════════════════════════════════════════
# PARTS/DEVSHELLS.NIX - Development Shells
# ═══════════════════════════════════════════════════════════════════════════════
#
# Defines development environments that can be entered with 'nix develop'.
# Useful for working on this repository and for development workflows.
#
# USAGE:
# ──────
#   nix develop              # Enter the default dev shell
#   nix develop .#lint       # Enter the linting shell
#
# ═══════════════════════════════════════════════════════════════════════════════

{self, ...}: {
  perSystem = {pkgs, ...}: {
    devShells = {
      # Default development shell for working on nixme
      default = pkgs.mkShell {
        name = "nixme-dev";
        
        buildInputs = with pkgs; [
          # Nix tooling
          nix-output-monitor      # Better nix build output
          nixfmt                  # Nix code formatter
          statix                  # Nix linter
          deadnix                 # Find dead Nix code
          
          # Git tools
          git
          git-lfs
          
          # Editors
          vim
          nano
          
          # Utilities
          jq                      # JSON processor
          yq                      # YAML processor
        ];
        
        NIXME_DIR = toString ../.;
        
        shellHook = ''
          echo "╔══════════════════════════════════════════════════════════╗"
          echo "║  Nixme Development Shell                                ║"
          echo "║  Working directory: ''${NIXME_DIR}                        ║"
          echo "╚══════════════════════════════════════════════════════════╝"
          echo ""
          echo "Available commands:"
          echo "  nix flake check          - Validate flake"
          echo "  nix flake update         - Update all inputs"
          echo "  nix flake lock --update-input <name>  - Update specific input"
          echo "  nixos-rebuild dry-build  - Test build (dry run)"
          echo "  nix fmt                  - Format all .nix files"
          echo ""
        '';
      };
      
      # Shell for linting and formatting
      lint = pkgs.mkShell {
        name = "nixme-lint";
        buildInputs = with pkgs; [
          nixfmt
          statix
          deadnix
        ];
      };
    };
  };
}
