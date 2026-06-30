# ═══════════════════════════════════════════════════════════════════════════════
# QUICK REFERENCE - Ghost Laptop Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Simplified NixOS configuration for Ghost laptop (stefan-hacks user only)
#
# ═══════════════════════════════════════════════════════════════════════════════

## 📁 Repository Structure

```
nixme/
├── flake.nix                    # Entry point
├── parts/
│   └── nixos/
│       ├── default.nix          # Ghost host definition
│       └── mk_hosts.nix         # Host generation (simplified)
├── modules/
│   ├── nixos/                   # System configuration
│   │   ├── core/                # Boot, networking, users
│   │   ├── desktop/gnome.nix    # GNOME + GDM
│   │   ├── hardware/kanata.nix # Keyboard remapping
│   │   ├── programs/            # Apps and CLI tools
│   │   ├── security/            # VPN, firewall
│   │   └── virtualization/      # Podman + VirtualBox
│   └── home/                    # Home Manager
│       ├── desktop.nix          # GNOME extensions (commented)
│       ├── shell.nix            # Bash, starship, zoxide
│       ├── terminal.nix         # Kitty + Zellij
│       └── development.nix      # Dev tools
└── hosts/
    └── ghost/
        ├── default.nix          # Ghost system config
        ├── hardware.nix         # Hardware + filesystems
        └── home.nix             # stefan-hacks user config
```

## ✅ What's Configured

### System Level (modules/nixos/)
- ✅ GRUB bootloader with EFI support
- ✅ GDM display manager + GNOME desktop
- ✅ NetworkManager + systemd-resolved DNS
- ✅ Firewall (SSH, HTTP, HTTPS + VM ports)
- ✅ stefan-hacks user with sudo access
- ✅ Podman (rootless containers)
- ✅ VirtualBox (for 4 Linux VMs)
- ✅ Kanata keyboard remapping
- ✅ Kitty terminal (in home config)

### User Level (hosts/ghost/home.nix)
- ✅ Kitty terminal (Catppuccin theme)
- ✅ Git with delta for diffs
- ✅ Bash shell with useful aliases
- ✅ Daily driver apps (Firefox, Discord, etc.)

## 🚀 Build Commands

```bash
# Clone and enter directory
cd ~/.config/nixme

# Build and switch to new configuration
sudo nixos-rebuild switch --flake .#ghost

# Just build (don't switch)
sudo nixos-rebuild build --flake .#ghost

# Check flake for errors
nix flake check

# Update flake inputs
nix flake update

# Clean up old generations
sudo nix-collect-garbage -d
```

## 🔧 Before First Build

### 1. Update Hardware Configuration
Edit `hosts/ghost/hardware.nix` and replace placeholder UUIDs:

```bash
# On Ghost laptop, run:
lsblk -f

# Then update hardware.nix:
fileSystems."/" = {
  device = "/dev/disk/by-uuid/YOUR-ACTUAL-UUID";
  # ...
};
```

### 2. Update Git Email
Edit `hosts/ghost/home.nix`:
```nix
programs.git = {
  userEmail = "your@actual.email.com";
};
```

## 🎨 Enabling GNOME Extensions

Extensions are commented out in `modules/home/desktop.nix`. To enable:

1. Uncomment desired extensions in `dconf.settings."org/gnome/shell".enabled-extensions`
2. Add the corresponding package to `home.packages`
3. Rebuild

### Available Extensions (pre-configured):
- `gnomeExtensions.dash-to-dock` - macOS-style dock
- `gnomeExtensions.arcmenu` - Windows-style start menu
- `gnomeExtensions.blur-my-shell` - Blur effects
- `gnomeExtensions.open-bar` - Customizable top bar
- `gnomeExtensions.clipboard-indicator` - Clipboard history
- `gnomeExtensions.just-perfection` - GNOME tweaks
- See full list in `modules/home/desktop.nix`

## 📦 Adding Packages

### System-wide packages:
Edit `hosts/ghost/default.nix`:
```nix
environment.systemPackages = with pkgs; [
  your-package-here
];
```

### User packages:
Edit `hosts/ghost/home.nix`:
```nix
home.packages = with pkgs; [
  your-package-here
];
```

Find packages at: https://search.nixos.org/packages

## 🔥 Firewall Ports

Currently open (from `modules/nixos/core/networking.nix`):
- TCP: 22 (SSH), 80 (HTTP), 443 (HTTPS)
- UDP: 5353 (mDNS), 53 (DNS), 67-68 (DHCP)

To add more ports, edit the firewall config and uncomment desired ports.

## 🐳 Virtualization

### Podman (Containers)
- Rootless by default
- Docker-compatible: `podman run ...` or `docker run ...`
- Compose: `podman-compose up`

### VirtualBox (VMs)
- Create VMs via VirtualBox GUI or `VBoxManage`
- 4 VMs planned: Kali, Debian, Rocky, NixOS
- SSH access via port forwarding (ports 2221-2224)

## ⌨️ Kanata Keyboard

Configuration file: `assets/kanata/kanata.kbd`

To modify:
1. Edit the kanata.kbd file
2. Rebuild: `sudo nixos-rebuild switch --flake .#ghost`

## 📝 Aliases (from hosts/ghost/home.nix)

```bash
# Navigation
..        # cd ..
...       # cd ../..

# Modern replacements  
ls        # eza --icons
cat       # bat
find      # fd
grep      # rg

# Nix
ns        # sudo nixos-rebuild switch --flake ...
nb        # sudo nixos-rebuild build --flake ...
ncg       # sudo nix-collect-garbage -d
nf        # nix flake check

# Git
g         # git
ga        # git add
gc        # git commit
gp        # git push
gs        # git status
```

## 🆘 Troubleshooting

### Build fails
```bash
# Check for syntax errors
nix flake check

# Show detailed error
sudo nixos-rebuild switch --flake .#ghost --show-trace
```

### WiFi issues
```bash
# Check NetworkManager status
systemctl status NetworkManager

# Restart networking
sudo systemctl restart NetworkManager
```

### Can't log in
```bash
# Check display manager
systemctl status display-manager

# Test GNOME session
nix-shell -p gnome.gnome-session --run "gnome-session"
```

## 📚 Resources

- NixOS Manual: https://nixos.org/manual/nixos/stable/
- NixOS Packages: https://search.nixos.org/packages
- NixOS Options: https://search.nixos.org/options
- Home Manager: https://nix-community.github.io/home-manager/
- NixOS Wiki: https://nixos.wiki/

## 🎯 Next Steps

1. Update hardware UUIDs in `hardware.nix`
2. Update git email in `home.nix`
3. Build: `sudo nixos-rebuild switch --flake .#ghost`
4. Customize GNOME extensions as desired
5. Add your preferred applications

Happy NixOS-ing! 🎉
