# ═══════════════════════════════════════════════════════════════════════════════
# NIXOS BARE-METAL INSTALLATION GUIDE - ROOT VERSION
# Ghost Laptop - Complete Step-by-Step Instructions
# ═══════════════════════════════════════════════════════════════════════════════
#
# This guide walks you through installing NixOS on your Ghost laptop
# using the nixme flake configuration with disko for automated partitioning.
#
# ESTIMATED TIME: 45-90 minutes
# DIFFICULTY: Intermediate
# LOCATION: /home/lin/nixme/INSTALL-GUIDE-BARE-METAL.md
#
# ═══════════════════════════════════════════════════════════════════════════════

## 📋 Overview

This guide walks you through installing NixOS on your Ghost laptop (Lenovo ThinkPad P1 Gen 4) using the nixme flake configuration. The installation uses **disko** for automated disk partitioning with LUKS encryption and BTRFS.

**What You'll Get:**
- LUKS-encrypted disk with passphrase protection
- BTRFS filesystem with subvolumes (@, @home, @nix, @persist, @log)
- NixOS unstable with GRUB bootloader
- Full GNOME desktop with all your settings
- User `stefan-hacks` with complete Home Manager configuration
- All your shell aliases, terminal setup (Kitty + Zellij), and development tools

**Estimated Time:** 45-90 minutes  
**Difficulty:** Intermediate  
**Data Destruction:** ⚠️ **YES** - This will erase all data on the target disk

---

## 🛠️ Prerequisites

### Required Hardware
- Lenovo ThinkPad P1 Gen 4 (Ghost laptop)
- USB drive (8GB or larger)
- Internet connection (Wi-Fi or Ethernet)
- A strong LUKS passphrase you'll remember!

### Required Software
- NixOS Minimal ISO (latest unstable)

---

## 📥 Step 1: Create Bootable USB

### Download NixOS Minimal ISO

```bash
# Option 1: Using curl
curl -L -o nixos-minimal.iso \
  https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# Option 2: Using wget
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# Verify download (optional but recommended)
ls -lh nixos-minimal.iso
# Should be approximately 800MB
```

### Write ISO to USB

#### Linux/macOS
```bash
# Identify USB device (BE CAREFUL - don't overwrite your main disk!)
lsblk  # or diskutil list on macOS

# Example: USB is /dev/sdX (replace X with actual letter)
sudo dd if=nixos-minimal.iso of=/dev/sdX bs=4M status=progress oflag=sync

# Verify write completed
sync
```

#### Windows
Use [Rufus](https://rufus.ie/) or [Etcher](https://www.balena.io/etcher/):
1. Download and install Rufus
2. Insert USB drive
3. Select NixOS ISO file
4. Click "Start"

---

## 🔌 Step 2: Boot from USB

### Prepare Ghost Laptop
1. **Save all work** - You're about to erase the disk
2. **Back up important data** - External drive or cloud storage
3. **Have your LUKS passphrase ready** - You'll need it during install

### Boot Process
1. Insert USB drive into Ghost laptop
2. Power on
3. Press **`F12`** repeatedly to enter boot menu
4. Select USB drive from boot options
5. At GRUB menu, select "NixOS default" and press Enter
6. Wait for boot (30-60 seconds)

### Verify Boot
You should see a black screen with:
```
nixos login:
```

---

## 🌐 Step 3: Connect to Internet

### Check Network Interface
```bash
# List network interfaces
ip link show

# Look for: enp0s31f6 (Ethernet) or wlp0s20f3 (Wi-Fi)
```

### Connect via Ethernet (Easiest)
If using Ethernet cable, connection should be automatic:
```bash
# Test connectivity
ping -c 3 google.com
```

### Connect via Wi-Fi
```bash
# Launch NetworkManager TUI
nmtui

# In the menu:
# 1. Select "Activate a connection"
# 2. Choose your Wi-Fi network
# 3. Enter password
# 4. Select "Back" then "Quit"

# Verify connection
ping -c 3 google.com
```

### Troubleshooting Network
```bash
# If Wi-Fi doesn't work, try:
systemctl restart NetworkManager
nmcli device wifi list
nmcli device wifi connect "Your-SSID" password "your-password"

# Check IP address
ip addr show
```

---

## 📁 Step 4: Clone Repository

### Prepare Environment
```bash
# Mount tmpfs for working space (RAM is faster)
mount -t tmpfs none /tmp
cd /tmp

# Install git (not included in minimal ISO)
nix-shell -p git

# Clone your nixme repository
git clone https://github.com/stefan-hacks/nixme.git

# Enter repository
cd nixme

# Verify files
ls -la
# Should see: flake.nix, hosts/, modules/, etc.
```

### Checkout Correct Branch (if needed)
```bash
# List branches
git branch -a

# Switch to main if needed
git checkout main

# Verify latest changes
git log --oneline -5
```

---

## 💾 Step 5: Identify Target Disk

### Find Your Disk
```bash
# List all disks
lsblk -dpno NAME,SIZE,MODEL

# Example output:
# /dev/nvme0n1  953.9G  Samsung SSD 980 PRO 1TB
# /dev/sda        14.5G  JetFlash Transc...

# The USB will be the smaller one (14.5G)
# Your main SSD is /dev/nvme0n1 (953.9G)
```

### Verify Disk
```bash
# Detailed info on target disk
fdisk -l /dev/nvme0n1

# Should show existing partitions if any
```

**⚠️ CRITICAL: Double-check you have the right disk!**
- **Ghost laptop**: `/dev/nvme0n1` (NVMe SSD)
- **USB**: Usually `/dev/sda` or `/dev/sdb` (much smaller)

---

## 🔐 Step 6: Run Disko (Partition & Encrypt)

### Understand What Disko Will Do
Disko will:
1. **Erase all data** on /dev/nvme0n1
2. Create GPT partition table
3. Create EFI System Partition (512MiB, FAT32)
4. Create LUKS-encrypted container (remaining space)
5. Set up LVM volume group "pool"
6. Create BTRFS filesystem with subvolumes

### Execute Disko
```bash
# Navigate to ghost host directory
cd /tmp/nixme/hosts/ghost

# Review disko configuration first
cat disko.nix | head -50

# Run disko (⚠️ DESTRUCTIVE - ERASES ALL DATA!)
nix run --extra-experimental-features 'nix-command flakes' github:nix-community/disko -- --mode disko ./disko.nix
```

### During Disko Execution

1. **You'll be prompted for LUKS passphrase:**
   ```
   Enter passphrase for /dev/nvme0n1p2:
   Verify passphrase:
   ```
   
   💡 **Choose a strong passphrase!** This protects your data.
   - Minimum 8 characters
   - Mix of letters, numbers, symbols
   - Something you'll remember!

2. **Wait for completion** (2-5 minutes)

3. **Verify the layout:**
   ```bash
   lsblk
   
   # Expected output:
   # NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
   # nvme0n1       259:0    0 953.9G  0 disk
   # ├─nvme0n1p1   259:1    0   512M  0 part  /boot
   # └─nvme0n1p2   259:2    0 953.4G  0 part
   #   └─cryptroot 254:0    0 953.4G  0 crypt
   #     └─pool-root 254:1  0 953.4G  0 lvm   /nix/store (overlay)
   ```

---

## 🔧 Step 7: Install NixOS

### Mount Verification
Disko should have already mounted everything, but verify:
```bash
# Check mounts
mount | grep /mnt

# Should show:
# /dev/mapper/pool-root on /mnt type btrfs (...)
# /dev/nvme0n1p1 on /mnt/boot type vfat (...)

# If not mounted, do it manually:
mkdir -p /mnt
mount /dev/mapper/pool-root /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

### Run Installation
```bash
# Navigate to repo root
cd /tmp/nixme

# Install NixOS (takes 15-60 minutes depending on internet)
nixos-install --flake .#ghost --no-root-passwd

# Flags:
# --flake .#ghost    : Use the ghost configuration from flake.nix
# --no-root-passwd   : Don't set root password now (we'll do it after)
```

### During Installation

The installer will:
1. **Download packages** (15-30 minutes)
   - Linux kernel
   - GNOME desktop
   - All your configured applications
   - Development tools

2. **Build system** (10-20 minutes)
   - Compile configurations
   - Set up users and groups
   - Install bootloader

3. **You may see warnings** (normal)
   - Package collisions (harmless)
   - GTK icon cache updates (normal)

**Do not interrupt the process!** It will take time.

---

## 🔑 Step 8: Set Root Password

After installation completes:

```bash
# Set root password
passwd --root /mnt

# You'll be prompted:
# New password: [type your password]
# Retype new password: [type again]
```

💡 **Choose a secure root password** - different from LUKS passphrase

---

## 🔄 Step 9: Reboot

### Unmount and Reboot
```bash
# Unmount everything
umount -R /mnt

# Optional: Remove USB (or it will boot from USB again)
# In NixOS, you can eject it now

# Reboot
reboot
```

### Remove USB
As the system reboots, remove the USB drive so it boots from the internal disk.

---

## 🎉 Step 10: First Boot

### Boot Process
1. **GRUB menu** - Select "NixOS" or wait for timeout
2. **LUKS unlock** - Enter your passphrase:
   ```
   Please unlock disk cryptroot:
   ```
3. **System boots** - You'll see NixOS boot messages
4. **Login prompt** - Press Enter to see login

### Login
```bash
# Login as root
ghost login: root
Password: [your root password]

# Or login as stefan-hacks (if already configured)
ghost login: stefan-hacks
Password: [your user password - set during first login]
```

---

## ✅ Step 11: Post-Installation Verification

### Verify System
```bash
# Check NixOS version
nixos-version

# Check disk layout
lsblk

# Check BTRFS subvolumes
btrfs subvolume list /

# Check user exists
id stefan-hacks

# Check LUKS
cryptsetup status cryptroot

# Test flake rebuild
sudo nixos-rebuild switch --flake /etc/nixos#ghost --dry-run
```

### Switch to stefan-hacks User
```bash
# Create password for stefan-hacks
sudo passwd stefan-hacks

# Login as user
su - stefan-hacks

# Verify home directory
ls -la ~
echo $SHELL
```

### Enable Display Manager (if not automatic)
```bash
# Check GNOME display manager status
systemctl status display-manager

# If needed, enable it
sudo systemctl enable gdm
sudo systemctl start gdm
```

---

## 🔄 Updating Your System

### Update Flake
```bash
# Navigate to nixme directory
cd /etc/nixos

# Update flake inputs
sudo nix flake update

# Rebuild system
sudo nixos-rebuild switch --flake .#ghost
```

### Update Only Specific Inputs
```bash
# Update only nixpkgs
sudo nix flake lock --update-input nixpkgs

# Rebuild
sudo nixos-rebuild switch --flake .#ghost
```

---

## 🆘 Troubleshooting

### Issue: "Device /dev/nvme0n1 doesn't exist"
**Fix:**
```bash
# Load NVMe drivers
modprobe nvme
ls /dev/nvme*
```

### Issue: "No space left on device"
**Fix:** Your disk is too small. Ghost laptop needs at least 50GB.

### Issue: LUKS passphrase not accepted
**Fix:**
- Check keyboard layout (US by default in ISO)
- Caps Lock off?
- Try typing it in plaintext first: `echo "test"`

### Issue: "nixos-install: command not found"
**Fix:** You're not on NixOS ISO. Make sure you booted from USB.

### Issue: Network doesn't work after install
**Fix:**
```bash
# Check interface name changed
ip link show

# Edit configuration if needed
sudo nano /etc/nixos/hosts/ghost/default.nix

# Rebuild
sudo nixos-rebuild switch --flake /etc/nixos#ghost
```

### Issue: Can't boot (GRUB error)
**Fix from live USB:**
```bash
# Boot from USB, mount system
cryptsetup open /dev/nvme0n1p2 cryptroot
mount /dev/mapper/pool-root /mnt
mount /dev/nvme0n1p1 /mnt/boot

# Reinstall bootloader
sudo nixos-install --flake /mnt/etc/nixos#ghost --no-root-passwd
```

---

## 📚 References

- [NixOS Installation Manual](https://nixos.org/manual/nixos/stable/#sec-installation)
- [Disko Documentation](https://github.com/nix-community/disko)
- [NixOS & LUKS](https://nixos.wiki/wiki/Full_Disk_Encryption)
- [BTRFS Subvolumes](https://btrfs.readthedocs.io/)

---

## 💡 Tips

1. **Take notes** during install - document any custom steps
2. **Test in VM first** using the VirtualBox guide
3. **Keep passphrase secure** but accessible
4. **Regular backups** of /persist subvolume
5. **Learn Nix** - The more you understand, the more powerful it becomes

---

**Good luck with your NixOS installation! 🎉**

For issues or questions, refer to the VIRTUALBOX-TESTING.md guide to practice first.