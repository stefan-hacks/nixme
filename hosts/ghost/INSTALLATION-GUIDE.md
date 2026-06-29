# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/INSTALLATION-GUIDE.md - Complete Ghost Laptop Setup with Disko
# ═══════════════════════════════════════════════════════════════════════════════
#
# This guide covers installing NixOS on the Ghost laptop using disko for automated
# disk partitioning with LUKS encryption and BTRFS.
#
# ═══════════════════════════════════════════════════════════════════════════════

## Prerequisites

### Required Hardware
- Lenovo ThinkPad P1 Gen 4 (Ghost laptop)
- USB drive (8GB+) for NixOS ISO
- Internet connection (Wi-Fi or Ethernet)
- A LUKS passphrase you'll remember!

### What You'll Get After Installation
- LUKS-encrypted disk with passphrase
- BTRFS filesystem with subvolumes (@, @home, @nix, @persist, @log)
- NixOS 26.05 stable with GRUB bootloader
- GNOME desktop environment with all your settings
- User `stefan-hacks` with full Home Manager configuration
- All your shell aliases, git config, terminal setup (Kitty + Zellij)
- All GNOME extensions and dconf settings

## Installation Steps

### Step 1: Create Bootable USB

```bash
# Download the latest NixOS minimal ISO
curl -L -o nixos-minimal.iso \
  wget https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso

# Write to USB (replace /dev/sdX with your USB device)
sudo dd if=nixos-minimal.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### Step 2: Boot from USB

1. Insert USB into Ghost laptop
2. Power on and press `F12` to enter boot menu
3. Select the USB drive
4. Choose "NixOS Minimal ISO" from GRUB menu

### Step 3: Connect to Internet

```bash
# For Wi-Fi, use nmtui (Network Manager TUI)
nmtui

# Or use nmcli directly
nmcli device wifi list
nmcli device wifi connect "SSID" password "password"

# Verify connection
ping -c 3 nixos.org
```

### Step 4: Clone the Repository

```bash
# Mount a temporary filesystem for the repo
mount -t tmpfs none /tmp

# Clone your nixme repository
cd /tmp
git clone https://github.com/stefan-hacks/nixme.git
cd nixme

# Optional: Checkout a specific branch
git checkout main
```

### Step 5: Run the Installation Script

```bash
# Navigate to the Ghost host directory
cd /tmp/nixme/hosts/ghost

# Run the automated installer
sudo bash install-ghost.sh
```

The script will:
1. ✅ Check prerequisites (root, NixOS ISO, internet)
2. ✅ Show available disks and ask for confirmation
3. ✅ Run disko to partition, encrypt, and format the disk
4. ✅ Generate hardware configuration
5. ✅ Install NixOS with all your settings
6. ✅ Set a temporary root password

### Step 6: Manual Installation (Alternative)

If you prefer to run commands manually:

```bash
# 1. Identify your disk (usually /dev/nvme0n1 for NVMe SSDs)
lsblk

# 2. Run disko to partition and format
# This DESTROYS ALL DATA on the disk!
nix run --extra-experimental-features 'nix-command flakes' github:nix-community/disko -- --mode disko /tmp/nixme/hosts/ghost/disko.nix

# 3. Mount the filesystems
mkdir -p /mnt
mount /dev/pool/root /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# 4. Install NixOS
nixos-install --flake /tmp/nixme#ghost --no-root-passwd

# 5. Set root password
passwd --root /mnt

# 6. Reboot
reboot
```

## Post-Installation

### First Boot

1. **Login as root** with the password you set (or `CHANGEME` if using the script)
2. **Change root password**: `passwd`
3. **Login as stefan-hacks**: The user is already configured with your Home Manager settings

### Verify Installation

```bash
# Check disk layout
lsblk

# Check filesystems
btrfs subvolume list /
df -h

# Check LUKS
cryptsetup status cryptroot

# Check NixOS version
nixos-version

# Verify flake
sudo nixos-rebuild switch --flake .#ghost --dry-run
```

### Updating the System

```bash
# Update flake inputs
nix flake update

# Rebuild and switch
sudo nixos-rebuild switch --flake .#ghost
```

### Adding Secrets (Optional)

If you have secrets to manage:

```bash
# Setup sops-nix for secrets management
# See: https://github.com/Mic92/sops-nix
```

## Troubleshooting

### Disk Not Found

If your NVMe disk doesn't show up:

```bash
# Load NVMe modules
modprobe nvme
ls /dev/nvme*
```

### Wi-Fi Not Working

```bash
# Check wireless interface
ip link show

# Use wpa_supplicant directly if needed
wpa_supplicant -i wlan0 -c <(wpa_passphrase "SSID" "password")
```

### LUKS Password Not Working

If the disko prompt doesn't accept your password:
- Try typing more slowly
- Ensure your keyboard layout is correct (US by default in NixOS ISO)
- The password is set interactively during disko, not predefined

### Boot Issues

If the system won't boot:

```bash
# From a NixOS live USB, mount and chroot
cryptsetup open /dev/nvme0n1p2 cryptroot
mount /dev/pool/root /mnt
mount /dev/nvme0n1p1 /mnt/boot
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
chroot /mnt

# Now you can rebuild
nixos-rebuild switch --flake .#ghost
```

### Out of Space

BTRFS subvolumes share space, so this is rare. But if needed:

```bash
# Check disk usage
btrfs filesystem df /
btrfs filesystem usage /

# Clean old generations
sudo nix-collect-garbage -d

# Resize (if you used LVM and have free space)
# lvresize -L +50G /dev/pool/root
# btrfs filesystem resize max /
```

## Files Explained

| File | Purpose |
|------|---------|
| `disko.nix` | Declarative disk partitioning with LUKS + BTRFS |
| `install-ghost.sh` | Automated installation script |
| `default.nix` | Host-specific NixOS configuration |
| `hardware.nix` | Hardware settings (kernel modules, no filesystems) |

## BTRFS Layout

```
/
├── @ (root)
├── @home (home directories)
├── @nix (nix store - can be rolled back separately)
├── @persist (data to keep across reinstalls)
└── @log (log files)
```

## Security Considerations

1. **LUKS Password**: Choose a strong passphrase and store it securely
2. **SSH Keys**: Already configured in `lib/const.nix`
3. **Root Access**: Passwordless sudo for wheel group
4. **Firewall**: Enabled by default in NixOS modules

## Customization

### Change Disk Device

Edit `disko.nix`:
```nix
main = {
  device = "/dev/nvme0n1";  # Change to your device
  ...
};
```

### Add Swap

Edit `disko.nix` and add a swap LV:
```nix
lvs = {
  swap = {
    size = "16G";
    content = {
      type = "swap";
    };
  };
  ...
};
```

### Change Partition Sizes

Edit the size in `disko.nix`:
```nix
ESP = {
  size = "1G";  # Increase EFI partition
  ...
};
```

## Backup Strategy

Since `/persist` is a separate subvolume, you can:

```bash
# Backup important data
sudo btrfs subvolume snapshot /persist /persist/.snapshots/backup-$(date +%Y%m%d)

# Or use btrbk for automated backups
```

## References

- [Disko Documentation](https://github.com/nix-community/disko)
- [NixOS Installation Guide](https://nixos.org/manual/nixos/stable/#sec-installation)
- [LUKS on NixOS](https://nixos.wiki/wiki/Full_Disk_Encryption)
- [BTRFS Subvolumes](https://btrfs.readthedocs.io/en/latest/Subvolumes.html)

## Need Help?

If you encounter issues:
1. Check the logs: `journalctl -xb`
2. Boot from USB and mount the system to inspect
3. Review the generated hardware config: `/etc/nixos/hardware-configuration.nix`
4. Check the NixOS manual: https://nixos.org/manual/nixos/stable/