# ═══════════════════════════════════════════════════════════════════════════════
# NIXOS VIRTUALBOX VM TESTING GUIDE - ROOT VERSION
# Complete Guide for Testing NixOS Installation in VirtualBox
# ═══════════════════════════════════════════════════════════════════════════════
#
# This guide walks you through testing the NixOS disko installation
# in a VirtualBox VM before running it on your actual Ghost laptop.
#
# ESTIMATED TIME: 45-60 minutes
# DIFFICULTY: Beginner to Intermediate
# LOCATION: /home/lin/nixme/INSTALL-GUIDE-VIRTUALBOX.md
#
# ═══════════════════════════════════════════════════════════════════════════════

## 📋 Prerequisites

### Host Machine Requirements
- **OS:** Any OS that runs VirtualBox (Windows, macOS, Linux)
- **RAM:** At least 8GB (VM needs 4GB minimum)
- **Storage:** 25GB free space for VM disk
- **CPU:** Supports virtualization (Intel VT-x/AMD-V)
- **Network:** Internet connection for downloading

### Software to Download
1. **VirtualBox:** https://www.virtualbox.org/wiki/Downloads
2. **NixOS Minimal ISO:** https://nixos.org/download.html
   - Choose "NixOS: the Linux distribution"
   - Click "Download" under "64-bit Intel/AMD"
   - Or direct: https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso

## 🖥️ Step-by-Step VirtualBox VM Setup

### Step 1: Install VirtualBox

#### Windows
1. Download installer from https://www.virtualbox.org/wiki/Downloads
2. Run the installer
3. Install VirtualBox Extension Pack (for better USB/network support)

#### macOS
```bash
# Using Homebrew (recommended):
brew install --cask virtualbox
brew install --cask virtualbox-extension-pack

# Or download from website and install manually
```

#### Linux
```bash
# Debian/Ubuntu
sudo apt update
sudo apt install virtualbox virtualbox-ext-pack

# Fedora
sudo dnf install VirtualBox

# Arch
sudo pacman -S virtualbox virtualbox-guest-iso
```

### Step 2: Download NixOS Minimal ISO

```bash
# Open browser and download:
https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-x86_64-linux.iso

# Save to a location you'll remember (e.g., Downloads folder)
# File size: ~800MB
```

### Step 3: Create the Virtual Machine

1. **Open VirtualBox**

2. **Click "New" (blue icon)**

3. **Configure Basic Settings:**
   ```
   Name: NixOS-Disko-Test
   Machine Folder: [Choose where VM files will be stored]
   Type: Linux
   Version: Linux 2.6 / 3.x / 4.x / 5.x (64-bit)
   ```

4. **Memory Size:**
   ```
   Select: 4096 MB (4 GB)
   Note: Can be adjusted later in Settings
   ```

5. **Hard Disk:**
   ```
   Select: Create a virtual hard disk now
   ```

6. **Hard Disk File Type:**
   ```
   Select: VDI (VirtualBox Disk Image)
   ```

7. **Storage on Physical Hard Disk:**
   ```
   Select: Dynamically allocated
   (Faster to create, grows as needed)
   ```

8. **File Location and Size:**
   ```
   Size: 25.00 GB (minimum, can be larger)
   Location: [Keep default or choose custom]
   ```

9. **Click "Create"**

### Step 4: Configure VM Settings (IMPORTANT!)

**The VM is created but needs configuration for EFI boot:**

1. **Select the VM "NixOS-Disko-Test"**
2. **Click "Settings" (gear icon)**

#### System Tab
```
Motherboard:
  - Boot Order: Uncheck "Floppy", keep "Optical" and "Hard Disk"
  - Extended Features: ☑️ Enable EFI (special OSes only)
  
Processor:
  - Processors: 2 (or more if available)
  - Execution Cap: 100%
  
Acceleration:
  - Enable VT-x/AMD-V
  - Enable Nested Paging
```

#### Display Tab
```
Screen:
  - Video Memory: 128 MB (or more)
  - Graphics Controller: VMSVGA (for Linux guests)
```

#### Storage Tab
```
Controller: IDE or SATA
  - Click the CD icon (Empty)
  - Click the disk icon on the right
  - Choose "Select a disk file..."
  - Browse to your downloaded NixOS ISO
  - Click OK
```

#### Network Tab
```
Adapter 1:
  - Enable Network Adapter: ☑️
  - Attached to: NAT
  - Advanced:
    - Cable connected: ☑️
```

3. **Click "OK" to save settings**

### Step 5: Start the VM

1. **Select "NixOS-Disko-Test"**
2. **Click "Start" (green arrow)**

3. **You'll see the GRUB menu:**
   ```
   Select: "NixOS default"
   Press Enter
   ```

4. **Wait for boot** (30-60 seconds)

5. **You'll see a black screen with a login prompt:**
   ```
   nixos login: root
   Press Enter
   
   # You're now logged in as root
   ```

## 🌐 Step 6: Connect to Internet in VM

### Check Network Status
```bash
# See network interfaces
ip link show

# You should see 'enp0s3' or similar
```

### For Ethernet (NAT mode - most reliable)
```bash
# Should already work, test it:
ping -c 3 google.com

# If it works, skip to Step 7
```

### For Wi-Fi (if needed)
```bash
# Use nmtui (Network Manager TUI)
nmtui

# In the menu:
# 1. Select "Activate a connection"
# 2. Choose your Wi-Fi network
# 3. Enter password
# 4. Select "Back" then "Quit"

# Test connection
ping -c 3 google.com
```

### If Network Doesn't Work
```bash
# Try manual configuration:
systemctl start NetworkManager
nmcli device wifi list
nmcli device wifi connect "SSID" password "your-password"
```

## 📥 Step 7: Clone Your Repository

```bash
# Navigate to a temporary location
cd /tmp

# Clone your nixme repository
git clone https://github.com/stefan-hacks/nixme.git

# Enter the repository
cd nixme

# Verify the files are there
ls -la hosts/ghost/
# You should see:
# - default.nix
# - disko.nix
# - disko-vm.nix  (VM version)
# - hardware.nix
# - install-ghost.sh
# - INSTALLATION-GUIDE.md
```

## 💿 Step 8: Run Disko (Partition the Virtual Disk)

### IMPORTANT: This DESTROYS all data on the virtual disk!

```bash
# Navigate to the ghost host directory
cd hosts/ghost

# View the available disk
lsblk

# You should see:
# NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
# sda      8:0    0   25G  0 disk    <- This is your virtual disk
# sr0     11:0    1 1024M  0 rom     <- This is the ISO

# For VM testing, use disko-vm.nix which uses /dev/sda
# Run disko to partition and format
nix run --extra-experimental-features 'nix-command flakes' github:nix-community/disko -- --mode disko ./disko-vm.nix
```

### During Disko Execution

1. **You'll be prompted for LUKS passphrase:**
   ```
   Enter passphrase for /dev/sda2: [type a password]
   Verify passphrase: [type it again]
   ```
   
   💡 **Tip:** Use something simple like "test123" for the VM
   
2. **Disko will:**
   - Create GPT partition table
   - Create EFI partition (512MiB, FAT32)
   - Create LUKS container on remaining space
   - Set up LVM volume group "pool"
   - Create BTRFS filesystem with subvolumes

3. **Wait for completion** (2-3 minutes)

### Verify Partitioning
```bash
# Check the layout
lsblk

# You should see:
# NAME          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
# sda             8:0    0   25G  0 disk
# ├─sda1          8:1    0  512M  0 part
# └─sda2          8:2    0 24.5G  0 part
#   └─cryptroot 254:0    0 24.5G  0 crypt
#     └─pool-root 254:1    0 24.5G  0 lvm

# Check BTRFS subvolumes
btrfs subvolume list /mnt
# Or if not mounted:
# mount /dev/mapper/pool-root /mnt
# btrfs subvolume list /mnt
```

## 🏗️ Step 9: Mount Filesystems and Install NixOS

### Mount the Filesystems
```bash
# Create mount point
mkdir -p /mnt

# Mount root (BTRFS)
mount /dev/mapper/pool-root /mnt

# Mount boot (EFI)
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Verify mounts
mount | grep /mnt
```

### Update Flake for VM (Important!)

The current flake uses `disko = true` which imports `disko.nix`. 
For VM testing, we need to use the VM-specific disko config.

**Option A: Quick edit (recommended for VM test)**
```bash
# Create a temporary copy of the flake.nix for VM testing
cp flake.nix flake-vm.nix

# Or simpler: use the original disko.nix but with device set to /dev/sda
# Edit the flake to point to disko-vm.nix instead
sed -i 's|./disko.nix|./disko-vm.nix|g' hosts/ghost/default.nix
```

**Option B: Create a VM-specific host config**
```bash
# Create a VM host directory
cd ../..
mkdir -p hosts/ghost-vm
cp -r hosts/ghost/* hosts/ghost-vm/

# Edit hosts/ghost-vm/default.nix to import disko-vm.nix
# (This is what you'd do for a permanent VM)
```

### Run NixOS Install

```bash
# From the nixme root directory
cd /tmp/nixme

# Install NixOS (takes 15-45 minutes)
nixos-install --flake .#ghost --no-root-passwd

# The --no-root-passwd flag means you'll set it next
```

### During Installation

- **Download Phase:** Nix downloads all packages
  - This can take 15-30 minutes depending on internet
  - You'll see progress bars for various packages

- **Build Phase:** Nix builds the system
  - Compiles configuration
  - Sets up users, services, etc.

- **Final Phase:** Installing bootloader
  - systemd-boot is installed to ESP
  - GRUB configuration is generated

## 🔐 Step 10: Set Root Password and Reboot

### Set Root Password
```bash
# Set password for root on the new system
passwd --root /mnt

# Enter a password twice:
# New password: [type password]
# Retype new password: [type again]
```

### Unmount and Reboot
```bash
# Unmount everything
umount -R /mnt

# Or individually:
# umount /mnt/boot
# umount /mnt

# Remove the ISO from the virtual drive (optional)
# In VirtualBox menu: Devices > Optical Drives > Remove disk from virtual drive

# Reboot
reboot
```

## 🎉 Step 11: First Boot - Verify Everything Works

### Boot Process
1. **VirtualBox BIOS/UEFI screen** - Press any key if prompted
2. **systemd-boot menu** - Select "NixOS" or wait for auto-boot
3. **LUKS passphrase prompt** - Enter the password you set during disko
4. **System boots** - You should see the NixOS boot messages

### Login
```bash
# At the login prompt:
nixos login: root
Password: [enter your root password]

# You should be logged in!
```

### Verify Installation

```bash
# Check the system is working
echo "Welcome to NixOS on Ghost (VM Test)!"

# Check NixOS version
nixos-version

# Check disk layout
lsblk

# Check BTRFS subvolumes
btrfs subvolume list /

# Check user exists
id stefan-hacks

# Check home directory
ls -la /home/

# Test GNOME (if installed and you have display)
# systemctl status display-manager
```

### Test the Flake System

```bash
# Test the flake can be rebuilt
nixos-rebuild switch --flake /etc/nixos#ghost --dry-run

# If that works, actually rebuild:
# nixos-rebuild switch --flake /etc/nixos#ghost
```

## 🔧 Troubleshooting Common Issues

### Issue: "device /dev/sda doesn't exist"
**Solution:**
```bash
# Check what devices exist
lsblk
fdisk -l

# VirtualBox might use different naming
# Try: /dev/vda (virtio), /dev/sda (SATA), /dev/hda (IDE)
# Edit disko-vm.nix to match
```

### Issue: "No space left on device"
**Solution:**
```bash
# The VM disk is too small
# Shutdown VM, go to Settings > Storage
# Increase virtual disk size or create new larger one
```

### Issue: "EFI partition not found"
**Solution:**
```bash
# Make sure VM is configured for EFI boot:
# VirtualBox Settings > System > Enable EFI

# Check if ESP was created
fdisk -l /dev/sda
# Should show partition 1 as EFI System
```

### Issue: "LUKS password not accepted"
**Solution:**
```bash
# During disko, you set the password
# Make sure keyboard layout matches (US by default)
# Try typing the password in plaintext first to verify
```

### Issue: "nixos-install: command not found"
**Solution:**
```bash
# You're probably not on NixOS
# Make sure you booted from NixOS ISO, not installed system

# If on installed system, use:
# nixos-rebuild switch --flake ...
```

### Issue: Network doesn't work after install
**Solution:**
```bash
# Check network interface name
ip link show

# It might have changed from enp0s3 to something else
# Edit /etc/nixos/configuration.nix or your flake

# Quick fix:
systemctl restart NetworkManager
```

### Issue: "error: path '/tmp/nixme' is not in Nix store"
**Solution:**
```bash
# The flake must be in the nix store or a git repo

# Option 1: Copy to /etc/nixos
sudo cp -r /tmp/nixme /etc/nixos
cd /etc/nixos
sudo nixos-install --flake .#ghost

# Option 2: Clone directly to a persistent location
sudo mkdir -p /mnt/etc/nixos
cd /mnt/etc/nixos
sudo git clone https://github.com/stefan-hacks/nixme.git .
sudo nixos-install --flake .#ghost
```

## 📊 What to Test in the VM

Before running on real hardware, verify:

### ✅ Basic Functionality
- [ ] Boots successfully
- [ ] LUKS decryption works
- [ ] Can login as root
- [ ] User `stefan-hacks` exists
- [ ] Home directory exists at `/home/stefan-hacks`

### ✅ Disk and Filesystem
- [ ] `lsblk` shows expected layout
- [ ] `btrfs subvolume list /` shows @, @home, @nix, @persist, @log
- [ ] Can write files to /home/stefan-hacks
- [ ] df -h shows correct sizes

### ✅ NixOS System
- [ ] `nixos-version` works
- [ ] `nixos-rebuild --help` works
- [ ] Can rebuild the system (even if just --dry-run)

### ✅ Home Manager (if configured)
- [ ] Can switch to stefan-hacks user
- [ ] Home directory has expected files
- [ ] Shell configuration loaded

### ✅ Desktop (if using GUI in VM)
- [ ] Display manager starts
- [ ] Can login to GNOME
- [ ] GNOME settings applied

## 🧹 Cleanup After Testing

### Delete the VM

**In VirtualBox:**
1. Right-click "NixOS-Disko-Test"
2. Select "Remove"
3. Choose "Delete all files" (removes the virtual disk too)

### Free Up Space

```bash
# The VM files are usually in:
# Windows: %USERPROFILE%\VirtualBox VMs\
# macOS: ~/VirtualBox VMs/
# Linux: ~/VirtualBox VMs/

# You can delete the folder manually if Remove didn't work
```

## 🔄 Quick Iteration Workflow

If you need to test multiple times:

### Snapshot Method (Fastest)
```bash
# In VirtualBox, before running disko:
# 1. Machine > Take Snapshot
# 2. Name: "Before Disko"

# Run disko, install, test...

# To reset:
# Machine > Restore Snapshot > "Before Disko"

# Now you can re-run disko without recreating VM
```

### Clone Method
```bash
# In VirtualBox:
# 1. Right-click VM > Clone
# 2. Full clone
# 3. Test on clone
# 4. Delete clone when done, keep original clean
```

## 📝 Summary

### What You Learned

1. **VirtualBox Setup:** Creating EFI-enabled VMs
2. **NixOS Live Environment:** Basic usage and tools
3. **Disko:** Declarative disk partitioning with LUKS
4. **NixOS Install:** Using flakes for system installation
5. **BTRFS:** Subvolumes and management
6. **Troubleshooting:** Common issues and fixes

### Ready for Real Hardware

Once the VM test succeeds, you're ready to run this on your Ghost laptop:

```bash
# The only difference on real hardware:
# 1. Use disko.nix (not disko-vm.nix) - it uses /dev/nvme0n1
# 2. Run the install-ghost.sh script
# 3. Everything else is the same!
```

### Files Created for VM Testing

```
hosts/ghost/
├── disko-vm.nix          # VM-specific disko config (/dev/sda)
└── VIRTUALBOX-VM-TESTING.md  # This guide
```

## 🔗 References

- [VirtualBox Documentation](https://www.virtualbox.org/manual/)
- [NixOS Installation Manual](https://nixos.org/manual/nixos/stable/#sec-installation)
- [Disko Project](https://github.com/nix-community/disko)
- [NixOS & LUKS](https://nixos.wiki/wiki/Full_Disk_Encryption)

## 💡 Tips

1. **Take snapshots:** Before any destructive operation
2. **Test incrementally:** Don't change too many things at once
3. **Read errors carefully:** Nix error messages are usually helpful
4. **Use `--dry-run`:** Test flakes without applying changes
5. **Keep notes:** Document what works and what doesn't

---

**Happy Testing! 🎉**

Once you confirm the VM installation works, you can confidently run it on your Ghost laptop.