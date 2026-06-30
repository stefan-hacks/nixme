# NixOS Configuration - Scalable & Organized

## Quick Start

```bash
# Test changes before applying
./scripts/test-build.sh check   # Quick validation
./scripts/test-build.sh build   # Full build test
./scripts/test-build.sh shell   # Debug in container

# Apply to system
sudo nixos-rebuild switch --flake .#ghost
```

## Directory Structure

```
nixme/
├── flake.nix                    # Entry point
├── flake.lock                   # Locked dependencies
│
├── hosts/                       # Per-host configurations
│   └── ghost/                   # Ghost laptop config
│       ├── default.nix          # System config
│       ├── hardware.nix         # Hardware-specific
│       └── home.nix             # User environment
│
├── modules/
│   ├── nixos/                   # System-level modules
│   │   ├── core/                # Essential (boot, networking, users)
│   │   ├── desktop/             # Desktop environments
│   │   ├── hardware/            # Hardware configs
│   │   ├── programs/            # Application configs
│   │   ├── security/            # Security & VPN
│   │   └── virtualization/      # VMs & containers
│   └── home/                    # User-level modules
│       ├── default.nix          # Aggregator
│       ├── desktop.nix          # Desktop apps
│       ├── development.nix      # Dev tools
│       ├── git.nix              # Git config
│       ├── shell.nix            # Shell packages
│       └── terminal.nix         # Terminal config
│
├── parts/                       # flake-parts modules
│   ├── default.nix              # Aggregator
│   ├── const.nix                # Constants
│   ├── nixos/                   # System generation
│   ├── home-manager/            # Home generation
│   └── lib/                     # Library functions
│
├── lib/                         # Custom Nix functions
│   ├── const.nix                # Constants
│   └── libmodule.nix            # Module helpers
│
└── scripts/                     # Helper scripts
    └── test-build.sh            # Containerized testing
```

## Adding a New Host

1. **Create host directory:**
   ```bash
   mkdir -p hosts/new-host
   ```

2. **Add to `parts/nixos/default.nix`:**
   ```nix
   {
     name = "new-host";
     system = "x86_64-linux";
     home-manager = true;
   }
   ```

3. **Create minimal configs:**
   - `hosts/new-host/default.nix` - System configuration
   - `hosts/new-host/hardware.nix` - Hardware settings
   - `hosts/new-host/home.nix` - User environment

4. **Test before applying:**
   ```bash
   ./scripts/test-build.sh check
   ```

## Automatic Maintenance

### Garbage Collection
- **Daily at 3 AM**: Removes generations older than 7 days
- **Weekly**: Optimizes store (deduplicates files)
- **Manual run**: `sudo nix-collect-garbage -d`

### Store Optimization
- Automatic hard-linking of identical files
- Reduces disk usage significantly

## Containerized Testing Workflow

**ALWAYS test changes in container before applying:**

```bash
# 1. Make your changes to .nix files

# 2. Test in container
./scripts/test-build.sh check

# 3. Fix any errors that appear

# 4. Commit when tests pass
git add -A
git commit -m "fix: description of changes"
git push

# 5. Apply to system
sudo nixos-rebuild switch --flake .#ghost
```

## Key Design Principles

1. **Single Host Focus**: Ghost laptop is the primary target
2. **Single User**: stefan-hacks user hardcoded
3. **Modular Organization**: Each concern in its own module
4. **Container Testing**: All changes validated before deployment
5. **Automatic Cleanup**: GC runs daily to prevent disk bloat

## Troubleshooting

### Container test fails
```bash
./scripts/test-build.sh shell
# Inside container:
nix flake check --show-trace
```

### Out of disk space
```bash
# Manual garbage collection
sudo nix-collect-garbage -d --delete-older-than 3d

# Check store size
du -sh /nix/store
```

### Lock file conflicts
```bash
# Update specific input
nix flake lock --update-input home-manager

# Update all inputs
nix flake update
```

## Secrets Management

For sensitive data, use `sops-nix` (already configured):

1. Create `secrets.yaml` with sops
2. Reference in configs via `config.sops.secrets.<name>.path`
3. See sops-nix documentation for details
