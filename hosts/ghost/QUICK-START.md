# ═══════════════════════════════════════════════════════════════════════════════
# Ghost Laptop Disko Installation - Quick Reference
# ═══════════════════════════════════════════════════════════════════════════════

## 🚀 Quick Start (4 Steps)

### 1. Create Bootable USB
```bash
# Download NixOS minimal ISO
curl -L -o nixos.iso \
  https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso

# Write to USB (replace sdX)
sudo dd if=nixos.iso of=/dev/sdX bs=4M status=progress
```

### 2. Boot & Connect
```bash
# Boot from USB → Connect Wi-Fi
nmtui
# Select "Activate a connection" → Choose network → Enter password
```

### 3. Clone & Install
```bash
# From NixOS live environment:
git clone https://github.com/stefan-hacks/nixme
cd nixme/hosts/ghost
sudo bash install-ghost.sh
```

### 4. Reboot
```bash
# When installation completes:
sudo reboot
```

## 🖥️ What You Get

| Component | Setup |
|-----------|-------|
| **Disk** | LUKS-encrypted + BTRFS with subvolumes |
| **Boot** | systemd-boot (UEFI) |
| **Desktop** | GNOME with all your extensions |
| **User** | stefan-hacks with Home Manager |
| **Terminal** | Kitty + Zellij |
| **Shell** | Bash with your aliases |
| **Git** | Configured with delta |

## 📁 BTRFS Subvolumes

```
@         → /          (root)
@home     → /home      (user directories)
@nix      → /nix       (nix store)
@persist  → /persist   (data to keep)
@log      → /var/log   (log files)
```

## 🔧 Manual Installation (if needed)

```bash
# 1. Partition with disko (DESTROYS DATA!)
nix run --extra-experimental-features 'nix-command flakes' github:nix-community/disko -- --mode disko /tmp/nixme/hosts/ghost/disko.nix

# 2. Mount filesystems
mkdir -p /mnt
mount /dev/pool/root /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# 3. Install
nixos-install --flake /tmp/nixme#ghost --no-root-passwd
passwd --root /mnt
```
```

## 🆘 Troubleshooting

| Issue | Fix |
|-------|-----|
| Disk not found | `modprobe nvme` |
| Wi-Fi not working | `nmtui` or `nmcli` |
| Boot fails | Boot USB → mount → `nixos-rebuild switch --flake .#ghost` |

## 📚 Files Created

```
hosts/ghost/
├── disko.nix               # Disk partitioning config
├── install-ghost.sh        # Automated installer
├── INSTALLATION-GUIDE.md   # Full documentation
├── default.nix             # Host config (updated)
└── hardware.nix            # Hardware (disko-compatible)
```

## 📝 Commit Details

**Commit:** `2e6f6c4` - feat: implement disko-based installation for Ghost laptop

**Pushed to:** https://github.com/stefan-hacks/nixme