# Nixme - Modern NixOS Configuration

A modern, modular NixOS configuration using [flake-parts](https://github.com/hercules-ci/flake-parts) for composable, maintainable infrastructure as code.

## Overview

This repository contains a complete NixOS system configuration for the `ghost` laptop and associated VMs, featuring:

- **flake-parts architecture** for modular flake composition
- **Multi-host support** (ghost laptop, kali-vm, debian-vm, fedora-vm)
- **Home Manager integration** for user configuration
- **Modern tooling** (GNOME, Kitty, Zellij, modern Unix replacements)
- **Development environment** (Python, Node.js, Rust, Go, etc.)
- **Virtualization** (QEMU/KVM, Podman, Docker)
- **Security tools** (1Password, VPN, penetration testing)

## Structure

```
nixme/
├── flake.nix              # Entry point with flake-parts
├── flake.lock             # Pinned dependencies
├── parts/                 # Modular flake components
│   ├── default.nix        # Aggregates all parts
│   ├── args.nix           # Common arguments
│   ├── lib/               # Custom library functions
│   ├── const.nix          # Constants (keys, ports, IPs)
│   ├── nixos/             # NixOS system configurations
│   ├── home-manager/      # Home Manager configurations
│   ├── devshells.nix      # Development shells
│   └── formatter.nix      # Code formatters
├── modules/
│   ├── nixos/             # NixOS system modules
│   │   ├── core/           # Essential system (boot, networking, users)
│   │   ├── desktop/        # GNOME desktop
│   │   ├── hardware/       # Hardware configuration
│   │   ├── programs/       # User applications
│   │   ├── security/       # Security tools
│   │   ├── virtualization/ # VMs and containers
│   │   └── network-tools/  # Network diagnostics
│   └── home/               # Home Manager modules
│       ├── shell.nix       # Shell configuration
│       ├── git.nix         # Git with delta
│       ├── terminal.nix    # Kitty + Zellij
│       ├── development.nix # Dev tools
│       └── desktop.nix     # Desktop apps
└── hosts/                  # Per-host configurations
    ├── ghost/              # Primary laptop
    ├── kali-vm/            # Penetration testing VM
    ├── debian-vm/          # Development VM
    └── fedora-vm/          # Container-focused VM
```

## Quick Start

### Prerequisites

1. Install NixOS on your machine
2. Generate hardware configuration:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/ghost/hardware.nix
   ```

### Building the System

```bash
# Clone this repository
git clone https://github.com/stefan-hacks/nixme.git
cd nixme

# Build and switch to the configuration
sudo nixos-rebuild switch --flake .#ghost

# Or build without switching (dry run)
sudo nixos-rebuild dry-build --flake .#ghost
```

### Home Manager

```bash
# Apply Home Manager configuration
home-manager switch --flake .#stefan-hacks
```

## Development

```bash
# Enter development shell
nix develop

# Format all Nix files
nix fmt

# Validate flake
nix flake check

# Update all inputs
nix flake update
```

## Key Features

### Flake-Parts Architecture

Unlike traditional flakes, this configuration uses `flake-parts` to split the flake into modular, composable parts:

- **parts/lib/**: Custom library functions (mkOpt, enable, etc.)
- **parts/const.nix**: Centralized constants
- **parts/nixos/**: NixOS system definitions
- **parts/home-manager/**: Home Manager configurations

### Multi-Host Support

Easily add new hosts by creating `hosts/<hostname>/default.nix` and adding an entry to `parts/nixos/default.nix`.

### Modern Tooling

- **Shell**: Zsh with Starship prompt, Atuin history, Zoxide smart cd
- **Terminal**: Kitty with Catppuccin theme, Zellij multiplexer
- **Editor**: Neovim, VSCode with extensions
- **Development**: Python, Node.js, Rust, Go, Docker, Kubernetes

### Security

- 1Password password manager
- VPN support (Mullvad, OpenVPN, WireGuard)
- Security tools (penetration testing on kali-vm)
- Firewall configuration

## Customization

### Adding a New Host

1. Create `hosts/newhost/default.nix` and `hosts/newhost/hardware.nix`
2. Add host entry to `parts/nixos/default.nix`
3. Rebuild: `sudo nixos-rebuild switch --flake .#newhost`

### Adding Packages

**System-wide**: Edit `modules/nixos/programs/<category>.nix`

**User-specific**: Edit `modules/home/<module>.nix` or use host-specific imports

### Updating Hardware Configuration

If hardware changes (e.g., new disk):

```bash
sudo nixos-generate-config --no-filesystems --show-hardware-config > hosts/ghost/hardware.nix
```

## License

MIT License - See [LICENSE](LICENSE)

## Credits

- Inspired by [upidapi/NixOs](https://github.com/upidapi/NixOs)
- Built with [flake-parts](https://flake.parts/)
- Uses [home-manager](https://github.com/nix-community/home-manager)
