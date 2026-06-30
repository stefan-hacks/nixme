# Nixme

**Declarative NixOS configuration for multiple hosts using profiles and Home Manager.**

This repository manages NixOS systems through a layered profile architecture. Each host imports the profiles it needs, from base system settings up through desktop environments and hardware-specific tuning.

---

## Repository Structure

```
nixme/
├── profiles/          # Reusable configuration layers
│   ├── common/        # Base system (locale, nix, security)
│   ├── terminal/      # CLI tools and shells
│   ├── desktop/       # GNOME, audio, fonts
│   ├── laptop/        # Power management, touchpad
│   └── server/        # SSH hardening, monitoring
│
├── hosts/             # Per-host configurations
│   └── ghost/         # Ghost laptop
│       ├── default.nix
│       └── hardware-configuration.nix
│
├── users/             # User account definitions
│   └── stefan.nix
│
├── home/              # Home Manager configurations
│   ├── common/
│   ├── terminal/
│   ├── desktop/
│   └── users/
│       └── stefan-hacks.nix
│
└── flake.nix          # Entry point and dependencies
```

## How It Works

**Profiles** are composable NixOS modules. A laptop might import:

```nix
imports = [
  ../../profiles/common      # All machines
  ../../profiles/terminal    # All machines
  ../../profiles/desktop     # GUI machines
  ../../profiles/laptop      # Laptop-specific
  ../../users/stefan.nix
];
```

A server would skip `desktop` and `laptop`, importing `server` instead.

**Home Manager** follows the same pattern. Users import terminal, desktop, or server modules as needed.

---

## Setup

```bash
git clone git@github.com:stefan-hacks/nixme.git ~/.config/nixme
cd ~/.config/nixme

# Copy hardware config (required)
cp /etc/nixos/hardware-configuration.nix hosts/ghost/

# Test
./scripts/test-build.sh check

# Apply
sudo nixos-rebuild switch --flake .#ghost
```

---

## Usage

### Test changes
```bash
./scripts/test-build.sh check
```

### Apply to system
```bash
sudo nixos-rebuild switch --flake .#ghost
```

### Adding a host
1. Create `hosts/newhost/default.nix` importing appropriate profiles
2. Copy hardware config to `hosts/newhost/hardware-configuration.nix`
3. Add entry in `flake.nix`
4. Test and apply

---

## Profiles Reference

| Profile | Purpose | Used By |
|---------|---------|---------|
| `common` | Locale, nix settings, security base | All hosts |
| `terminal` | Shells, CLI tools, dev environment | All hosts |
| `desktop` | GNOME, audio, fonts, flatpak | Workstations |
| `laptop` | TLP, touchpad, firmware updates | Laptops |
| `server` | SSH hardening, fail2ban, cockpit | Servers |

---

## Key Files

- `profiles/*/default.nix` — Reusable system configurations
- `home/*/default.nix` — Reusable Home Manager configurations  
- `hosts/*/default.nix` — Host-specific imports and settings
- `users/*.nix` — User account definitions
- `flake.nix` — System definitions and dependencies

---

*NixOS configuration managed with flakes.*
