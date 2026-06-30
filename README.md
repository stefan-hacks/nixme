# Nixme - Simplified NixOS Configuration

**A lean, container-tested NixOS configuration for single-host daily driver use.**

This repository contains a minimal, focused NixOS setup designed for one purpose: managing the Ghost laptop efficiently without unnecessary complexity. No multi-host abstractions, no dynamic user discovery, no disko - just a straightforward configuration that works.

---

## Table of Contents

1. [Philosophy](#philosophy) - Why this approach
2. [Quick Start](#quick-start) - Get up and running
3. [Directory Structure](#directory-structure) - How it's organized
4. [Architecture Deep-Dive](#architecture-deep-dive) - Understanding the design
5. [Workflow](#workflow) - Making changes safely
6. [Adding New Hosts](#adding-new-hosts) - Future scalability
7. [Maintenance](#maintenance) - Automatic and manual tasks
8. [Troubleshooting](#troubleshooting) - When things go wrong

---

## Philosophy

### Why Simplified?

Previous iterations attempted to support multiple hosts, dynamic user discovery, and disko-based disk management. These features added complexity without providing value for a single-user, single-host daily driver setup.

**This configuration embraces:**

- **Single Host**: Ghost laptop is hardcoded as the only target
- **Single User**: stefan-hacks user is explicitly defined
- **Direct Paths**: No abstraction layers - imports use absolute paths
- **Container Testing**: Every change validated before deployment
- **Aggressive GC**: Daily cleanup prevents disk bloat

### Key Decisions

| Decision | Rationale |
|----------|-----------|
| Hardcoded user/host | Simpler than dynamic discovery for single-user setups |
| No disko | Manual partitioning is more reliable for daily driver |
| Container testing | Prevents broken configs from reaching live system |
| Daily GC (7-day retention) | Balance between recovery options and disk usage |
| flake-parts | Modular structure without the complexity of full NixOS modules |

---

## Quick Start

### Prerequisites

- NixOS installed on Ghost laptop
- Git repository cloned to `~/.config/nixme/`
- `podman` or `docker` for containerized testing

### Making Changes

```bash
# 1. Navigate to the repository
cd ~/.config/nixme

# 2. Make your edits to .nix files

# 3. Test changes in container (MANDATORY)
./scripts/test-build.sh check   # Quick validation
./scripts/test-build.sh build   # Full build test (slower)

# 4. Fix any errors, then commit
git add -A
git commit -m "fix: description of problem and solution"
git push

# 5. Apply to live system
sudo nixos-rebuild switch --flake .#ghost
```

### Emergency Recovery

If a bad configuration makes it to the system:

```bash
# Boot previous generation from GRUB
# Or rollback from command line:
sudo nixos-rebuild switch --rollback

# List available generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

---

## Directory Structure

```
nixme/
├── flake.nix                    # Entry point with pinned dependencies
├── flake.lock                   # Locked inputs (nixpkgs, home-manager, etc.)
│
├── hosts/                       # Per-host configurations
│   └── ghost/                   # Ghost laptop (Lenovo ThinkPad P1 Gen 4)
│       ├── default.nix          # System configuration imports
│       ├── hardware.nix         # Hardware-specific settings (boot, filesystems)
│       └── home.nix             # User environment (dotfiles, SSH, etc.)
│
├── modules/
│   ├── nixos/                   # System-level modules
│   │   ├── core/                # Essential system (boot, networking, users, nix)
│   │   ├── desktop/             # GNOME desktop environment
│   │   ├── hardware/            # Hardware support (kanata, etc.)
│   │   ├── programs/            # Application configurations
│   │   ├── security/            # VPN, 1Password, etc.
│   │   └── virtualization/      # Podman, VirtualBox, libvirt
│   └── home/                    # Home Manager modules
│       ├── default.nix          # Aggregator for all home modules
│       ├── desktop.nix          # GNOME apps and settings
│       ├── development.nix      # VSCode, language servers, etc.
│       ├── git.nix              # Git configuration with delta
│       ├── shell.nix            # Shell packages (starship, zoxide, etc.)
│       └── terminal.nix         # Kitty, Zellij, fonts
│
├── parts/                       # flake-parts modules (flake composition)
│   ├── default.nix              # Aggregates all flake parts
│   ├── const.nix                # Constants (unused in simplified setup)
│   ├── nixos/                   # System configuration generation
│   │   ├── default.nix          # Defines nixosConfigurations.ghost
│   │   └── mk_hosts.nix         # Host builder (simplified for single host)
│   ├── home-manager/            # Home Manager generation
│   └── lib/                     # Custom library functions
│
├── lib/                         # Shared Nix functions
│   ├── const.nix                # Constants
│   └── libmodule.nix            # Module helpers
│
└── scripts/                     # Helper scripts
    └── test-build.sh            # Containerized testing tool
```

---

## Architecture Deep-Dive

### The flake-parts Pattern

This configuration uses [flake-parts](https://github.com/hercules-ci/flake-parts) to organize the flake into composable modules. Instead of one large `flake.nix`, functionality is split across the `parts/` directory.

**Benefits:**
- Each part is self-contained and focused
- Easy to add new outputs (packages, devshells, etc.)
- Better IDE support with `debug = true`

**How it works:**
1. `flake.nix` imports `flake-parts.lib.mkFlake` and points to `./parts`
2. `parts/default.nix` aggregates all parts
3. `parts/nixos/` defines system configurations
4. `parts/home-manager/` defines user configurations

### Configuration Flow

```
User runs: nixos-rebuild switch --flake .#ghost

┌─────────────────────────────────────────────────────────────┐
│  1. flake.nix imports parts/                              │
│  2. parts/nixos/default.nix defines nixosConfigurations     │
│  3. parts/nixos/mk_hosts.nix builds the system             │
│     - Hardcodes user: stefan-hacks                        │
│     - Imports modules/nixos/ for system                    │
│     - Imports hosts/ghost/ for host-specific              │
│     - Imports home-manager modules for user                 │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Build Process                                              │
│  - nixpkgs: nixos-26.05 (stable)                          │
│  - home-manager: release-26.05 (matches nixpkgs)           │
│  - stateVersion: "26.05" (NEVER CHANGE)                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  Result: Ghost system with stefan-hacks user configured     │
└─────────────────────────────────────────────────────────────┘
```

### Module Organization

#### System Modules (`modules/nixos/`)

Each module is a self-contained NixOS module that can be imported independently:

| Module | Purpose |
|--------|---------|
| `core/` | Essential system: boot, networking, users, nix settings |
| `desktop/` | GNOME desktop environment with extensions |
| `hardware/` | Hardware-specific configs (kanata keyboard remapper) |
| `programs/` | User applications: Firefox, terminal tools, etc. |
| `security/` | VPN, 1Password, security tools |
| `virtualization/` | Podman, VirtualBox, libvirt for VMs |

#### Home Modules (`modules/home/`)

Home Manager modules configure the user environment:

| Module | Purpose |
|--------|---------|
| `desktop.nix` | GNOME apps (dconf settings, extensions) |
| `development.nix` | VSCode, language servers, dev tools |
| `git.nix` | Git configuration with delta for diffs |
| `shell.nix` | Shell packages: starship, zoxide, eza, etc. |
| `terminal.nix` | Kitty terminal + Zellij multiplexer |

### Pinned Dependencies

All inputs are pinned to ensure reproducibility:

```nix
# In flake.nix
inputs = {
  # Stable channel - well-tested packages
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  
  # Unstable for bleeding-edge packages (when needed)
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  
  # Home Manager - MUST match NixOS version
  home-manager = {
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
  # Other inputs follow nixpkgs for consistency
  flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  ...
};
```

**Important:** Home Manager version must match NixOS version. Using `release-26.05` with `nixos-26.05` ensures compatibility.

---

## Workflow

### The Golden Path

Every change follows this pattern:

```bash
# Step 1: Edit
vim modules/nixos/core/networking.nix

# Step 2: Test (NEVER SKIP)
./scripts/test-build.sh check

# If errors, fix and repeat Step 2

# Step 3: Commit
git add -A
git commit -m "networking: add specific firewall rule for service X

Problem: Service X couldn't connect because port Y was blocked
Solution: Add explicit allow rule for port Y in firewall config
Tested: Built successfully in container"

# Step 4: Push
git push

# Step 5: Apply
sudo nixos-rebuild switch --flake .#ghost
```

### Why Container Testing?

The `./scripts/test-build.sh` script runs `nix flake check` inside a NixOS container using Podman. This provides:

- **Isolation**: Broken configs don't affect the live system
- **Speed**: Container evaluation is faster than full rebuild
- **Safety**: Errors are caught before deployment
- **Reproducibility**: Same container environment every time

### Types of Tests

| Command | Purpose | Speed |
|---------|---------|-------|
| `check` | Validate flake syntax and structure | Fast (~30s) |
| `build` | Full evaluation (catches missing packages) | Slow (~5min) |
| `shell` | Interactive debugging | Interactive |

### Commit Message Format

Follow this format for clear history:

```
<scope>: <imperative description>

Problem: <what was wrong>
Solution: <how you fixed it>
Tested: <how you verified it works>
```

Examples:
- `networking: allow port 8080 for development server`
- `home: update starship config with new format`
- `core: enable weekly automatic store optimisation`

---

## Adding New Hosts

While this configuration is simplified for Ghost, you can add new hosts by following this pattern:

### Step 1: Create Host Directory

```bash
mkdir -p hosts/new-host-name
```

### Step 2: Add Entry in `parts/nixos/default.nix`

```nix
{
  name = "new-host-name";
  system = "x86_64-linux";
  home-manager = true;
}
```

### Step 3: Create Required Files

**`hosts/new-host-name/default.nix`**:
```nix
# Host-specific system configuration
{ config, pkgs, ... }: {
  # Hardware-specific imports or overrides
  imports = [
    ./hardware.nix
  ];
  
  # Host-specific configuration
  networking.hostName = "new-host-name";
  
  # Any modules not common to all hosts
}
```

**`hosts/new-host-name/hardware.nix`**:
```nix
# Generated with: sudo nixos-generate-config --show-hardware-config
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ ];
  
  boot.initrd.availableKernelModules = [ ... ];
  boot.kernelModules = [ ... ];
  boot.extraModulePackages = [ ];
  
  fileSystems."/" = { ... };
  fileSystems."/boot" = { ... };
  
  swapDevices = [ ... ];
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
```

**`hosts/new-host-name/home.nix`**:
```nix
# Host-specific user configuration
{ config, pkgs, ... }: {
  # User packages specific to this host
  home.packages = with pkgs; [
    # host-specific tools
  ];
  
  # Host-specific settings
  programs.git.userEmail = "stefan@new-host";
}
```

### Step 4: Test and Apply

```bash
# Test the new configuration
./scripts/test-build.sh check

# If on the new host, apply:
sudo nixos-rebuild switch --flake ~/.config/nixme#new-host-name
```

---

## Maintenance

### Automatic Maintenance

The configuration includes automatic maintenance via `modules/nixos/core/nix-settings.nix`:

#### Garbage Collection
- **When**: Daily at 3:00 AM
- **What**: Removes generations older than 7 days
- **Why**: Prevents disk bloat while keeping recent generations for rollback

```nix
nix.gc = {
  automatic = true;
  dates = "03:00";
  options = "--delete-older-than 7d";
};
```

#### Store Optimisation
- **When**: Weekly
- **What**: Deduplicates identical files via hardlinks
- **Why**: Reduces disk usage significantly

```nix
nix.optimise = {
  automatic = true;
  dates = [ "weekly" ];
};
```

#### Auto-Optimise Store
- **When**: Continuous (during builds)
- **What**: Hard-links identical files as they're added
- **Why**: Prevents duplication at build time

```nix
nix.extraOptions = ''
  auto-optimise-store = true
'';
```

### Manual Maintenance

```bash
# Check disk usage
du -sh /nix/store

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Delete old generations (keep current + 3 previous)
sudo nix-collect-garbage --delete-older-than 3d

# Full cleanup (removes all old generations)
sudo nix-collect-garbage -d

# Optimise store manually
sudo nix-store --optimise

# Update flake.lock
nix flake update

# Update specific input
nix flake lock --update-input home-manager
```

### When to Run Manual GC

- Before system upgrades (frees space)
- When disk space is low
- After large package changes (removes unused deps)

---

## Troubleshooting

### Container Testing

#### Test fails with "No such file or directory"

```bash
# Ensure you're in the repo root
cd ~/.config/nixme

# Check file permissions
ls -la scripts/test-build.sh

# Should be executable (chmod +x if not)
```

#### Container won't start (Podman/Docker issues)

```bash
# Check Podman is installed
podman --version

# If using Docker, check it's running
sudo systemctl status docker

# SELinux issues: ensure :Z flag is present in mount
# (already configured in test-build.sh)
```

#### Network issues in container

The container needs internet to download Nix store paths. If behind a proxy:

```bash
# Set proxy for Podman
export HTTP_PROXY=http://proxy:port
export HTTPS_PROXY=http://proxy:port
./scripts/test-build.sh check
```

### Build Failures

#### Attribute not found

```
error: attribute 'packagename' missing
```

**Fix:** Search for correct package name:
```bash
# Search Nix packages
nix search nixpkgs packagename

# Or use search.nixos.org
```

#### Deprecated option

```
error: option 'old.option' is deprecated
```

**Fix:** Check release notes for new option path. Common deprecations:
- `programs.git.extraConfig` → `programs.git.settings`
- `services.xserver.displayManager.gdm` → `services.displayManager.gdm`

#### Type mismatch

```
error: A definition for option 'X' is not of type 'Y'
```

**Fix:** Check option type in NixOS manual:
- `attrsOf` expects attribute set
- `listOf` expects list
- `str` expects string (not path)

### System Issues

#### Boot failure after rebuild

1. Reboot
2. Select previous generation in GRUB
3. Once booted, fix the configuration
4. Test in container before rebuilding

#### Home Manager fails to switch

```bash
# Check for conflicts
home-manager switch --flake .#stefan-hacks 2>&1 | less

# Common fix: remove conflicting files
rm ~/.bashrc  # Let Home Manager manage it

# Or allow Home Manager to backup
home-manager switch --flake .#stefan-hacks -b backup
```

#### Disk full

```bash
# Emergency cleanup
sudo nix-collect-garbage -d --delete-older-than 1d

# Check what's using space
nix path-info -Sh /run/current-system | sort -k2 -h

# Remove old home generations
home-manager generations
home-manager remove-generations +5  # Keep last 5
```

### SSH Issues

#### Can't SSH to VMs

```bash
# Check SSH config is loaded
ssh -G kali-vm | grep port

# Should show: port 2221

# Test connection with verbose output
ssh -vvv kali-vm

# Check if VM is running
sudo virsh list --all
# or for VirtualBox
vboxmanage list runningvms
```

### Getting Help

```bash
# Check NixOS manual
man configuration.nix

# Search options
nixos-option <option-name>

# Get flake info
nix flake metadata

# Show what would be built
nixos-rebuild dry-build --flake .#ghost

# Trace evaluation for debugging
nixos-rebuild switch --flake .#ghost --show-trace
```

---

## Summary

This simplified NixOS configuration prioritizes:

1. **Reliability**: Container testing prevents broken deployments
2. **Clarity**: Direct paths, explicit definitions, no magic
3. **Maintainability**: Daily GC, weekly optimisation, clear structure
4. **Recoverability**: Multiple generations, rollback support

**Key files to remember:**
- Edit: `modules/nixos/` or `modules/home/` or `hosts/ghost/`
- Test: `./scripts/test-build.sh check`
- Apply: `sudo nixos-rebuild switch --flake .#ghost`

**Never change:**
- `system.stateVersion` (keep at "26.05")
- `home.stateVersion` (keep at "26.05")
- Input branches (nixos-26.05, release-26.05)

**Always do:**
- Test in container before applying
- Commit with descriptive messages
- Push before applying to system

---

*Configuration for Ghost laptop, maintained by stefan-hacks*
