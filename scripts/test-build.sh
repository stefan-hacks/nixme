#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# TEST-BUILD.SH - Containerized NixOS Build Testing
# ═══════════════════════════════════════════════════════════════════════════════
#
# This script tests NixOS configurations in a Podman container before
# applying them to the actual system. This prevents broken configurations
# from affecting your running system.
#
# USAGE:
#   ./scripts/test-build.sh          # Run full test
#   ./scripts/test-build.sh check    # Quick flake check (default)
#   ./scripts/test-build.sh build     # Full build test
#   ./scripts/test-build.sh shell     # Enter container for debugging
#
# REQUIREMENTS:
#   - Podman (or Docker)
#   - Internet access (for downloading Nix container)
#
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# Configuration
CONTAINER_NAME="nixme-flake-tester"
NIX_IMAGE="nixos/nix:latest"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if podman is available
check_podman() {
    if command -v podman &> /dev/null; then
        CONTAINER_CMD="podman"
    elif command -v docker &> /dev/null; then
        CONTAINER_CMD="docker"
    else
        log_error "Neither podman nor docker found. Please install one of them."
        exit 1
    fi
    log_info "Using container runtime: $CONTAINER_CMD"
}

# Pull the Nix container image
pull_image() {
    log_info "Pulling Nix container image..."
    $CONTAINER_CMD pull "$NIX_IMAGE"
}

# Run flake check in container
# Note: Mounts /etc/nixos if it exists (for NixOS hosts with hardware symlink)
check_flake() {
    log_info "Running nix flake check..."
    
    # Build mount flags - add /etc/nixos if it exists (for hardware symlink)
    local MOUNT_FLAGS=("-v" "$PROJECT_ROOT:/nixme:Z")
    if [ -d "/etc/nixos" ]; then
        MOUNT_FLAGS+=("-v" "/etc/nixos:/etc/nixos:ro")
    fi
    
    $CONTAINER_CMD run --rm \
        "${MOUNT_FLAGS[@]}" \
        -w /nixme \
        "$NIX_IMAGE" \
        sh -c "nix --extra-experimental-features 'nix-command flakes' flake check 2>&1"
    
    if [ $? -eq 0 ]; then
        log_info "✅ Flake check PASSED"
        return 0
    else
        log_error "❌ Flake check FAILED"
        return 1
    fi
}

# Build test (evaluates derivations without installing)
build_test() {
    log_info "Running build test for ghost configuration..."
    $CONTAINER_CMD run --rm \
        -v "$PROJECT_ROOT:/nixme:Z" \
        -w /nixme \
        "$NIX_IMAGE" \
        sh -c "nix --extra-experimental-features 'nix-command flakes' build .#nixosConfigurations.ghost.config.system.build.toplevel --dry-run 2>&1"
    
    if [ $? -eq 0 ]; then
        log_info "✅ Build test PASSED"
        return 0
    else
        log_error "❌ Build test FAILED"
        return 1
    fi
}

# Enter container shell for debugging
enter_shell() {
    log_info "Entering container shell (for debugging)..."
    $CONTAINER_CMD run --rm -it \
        -v "$PROJECT_ROOT:/nixme:Z" \
        -w /nixme \
        "$NIX_IMAGE" \
        sh -c "
            echo 'Container ready for debugging.'
            echo 'Available commands:'
            echo '  nix flake check     - Validate flake'
            echo '  nix flake show      - Show flake outputs'
            echo '  nix build           - Build configuration'
            echo ''
            exec bash
        "
}

# Cleanup function
cleanup() {
    log_info "Cleaning up..."
    $CONTAINER_CMD rm -f "$CONTAINER_NAME" 2>/dev/null || true
}

# Show usage
usage() {
    cat << EOF
Usage: $0 [COMMAND]

Commands:
  check   Run nix flake check (default)
  build   Run build test for ghost configuration
  shell   Enter container shell for debugging
  clean   Remove test containers
  help    Show this help message

Examples:
  $0              # Quick check (default)
  $0 check        # Same as above
  $0 build        # Full build test
  $0 shell        # Debug inside container

EOF
}

# Main function
main() {
    local command="${1:-check}"
    
    case "$command" in
        check)
            check_podman
            check_flake
            ;;
        build)
            check_podman
            check_flake && build_test
            ;;
        shell)
            check_podman
            enter_shell
            ;;
        clean)
            cleanup
            log_info "Cleanup complete"
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

# Run cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
