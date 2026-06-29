# ═══════════════════════════════════════════════════════════════════════════════
# NIXOS INSTALLATION GUIDES - Master Index
# ═══════════════════════════════════════════════════════════════════════════════
#
# Welcome to the nixme NixOS configuration installation guides!
#
# This repository contains multiple installation methods for different scenarios.
# Choose the guide that matches your needs.
#
# ═══════════════════════════════════════════════════════════════════════════════

## 📚 Available Guides

### 1. 🖥️ Bare-Metal Installation (Ghost Laptop)
**File:** `INSTALL-GUIDE-BARE-METAL.md`

**Use this if:**
- You want to install NixOS on your actual Ghost laptop (Lenovo ThinkPad P1 Gen 4)
- You're ready to erase your disk and install fresh
- You want the full system with LUKS encryption and BTRFS

**What's included:**
- Creating bootable USB
- Disk partitioning with disko
- LUKS encryption setup
- Full system installation
- Post-installation configuration

**Time required:** 45-90 minutes  
**Difficulty:** Intermediate  
**⚠️ WARNING:** Erases all data on target disk

[Open Bare-Metal Guide →](INSTALL-GUIDE-BARE-METAL.md)

---

### 2. 🧪 VirtualBox VM Testing
**File:** `INSTALL-GUIDE-VIRTUALBOX.md`

**Use this if:**
- You want to test the installation before risking your real hardware
- You want to learn NixOS without affecting your current system
- You want to verify the configuration works

**What's included:**
- VirtualBox VM setup on Windows/macOS/Linux
- NixOS ISO installation in VM
- Testing disko partitioning safely
- Validating the full configuration
- Troubleshooting common issues

**Time required:** 60-90 minutes  
**Difficulty:** Beginner-friendly  
**✅ SAFE:** No risk to real hardware

[Open VirtualBox Guide →](INSTALL-GUIDE-VIRTUALBOX.md)

---

## 🗂️ Quick Reference

### What Gets Installed

Both guides install the same NixOS configuration:

| Component | Description |
|-----------|-------------|
| **OS** | NixOS Unstable (latest rolling release) |
| **Disk** | LUKS-encrypted BTRFS with subvolumes |
| **Boot** | GRUB with UEFI support |
| **Desktop** | GNOME 40+ with full customization |
| **User** | stefan-hacks with Home Manager |
| **Shell** | Bash with extensive aliases |
| **Terminal** | Kitty + Zellij multiplexing |
| **Browser** | Firefox with profiles |
| **Tools** | Git, development tools, productivity apps |

### Partition Layout

```
/dev/nvme0n1 (Bare Metal) or /dev/sda (VM)
├── p1: EFI System (512MiB, FAT32) → /boot
└── p2: LUKS-encrypted
    └── LVM: pool
        └── BTRFS with subvolumes:
            ├── @ → / (root)
            ├── @home → /home
            ├── @nix → /nix
            ├── @persist → /persist
            └── @log → /var/log
```

---

## 🚀 Recommended Workflow

### For First-Time NixOS Users
1. **Start here:** VirtualBox Guide
2. **Practice:** Run through installation 1-2 times in VM
3. **Verify:** Ensure you understand each step
4. **Proceed:** Bare-Metal Guide for real hardware

### For Experienced NixOS Users
1. **Review:** Bare-Metal Guide for Ghost-specific details
2. **Prepare:** USB drive and backups
3. **Install:** Follow bare-metal guide directly

---

## 📋 Prerequisites Summary

### Both Guides Require
- USB drive (8GB+)
- Internet connection
- Basic Linux command-line knowledge
- 2-4 hours of uninterrupted time

### Bare-Metal Additional Requirements
- Lenovo ThinkPad P1 Gen 4 (Ghost laptop)
- **BACKUP OF ALL IMPORTANT DATA**
- LUKS passphrase (memorable but secure)

### VirtualBox Additional Requirements
- 8GB+ RAM (4GB for VM)
- 25GB free disk space
- VirtualBox installed

---

## 🆘 Getting Help

### If You Encounter Issues

1. **Check the Troubleshooting section** in the relevant guide
2. **Review the logs:**
   ```bash
   # During install
   journalctl -xb
   
   # After install
   sudo journalctl -u nixos-rebuild-switch
   ```
3. **NixOS Manual:** https://nixos.org/manual/nixos/stable/
4. **Disko Docs:** https://github.com/nix-community/disko

### Common Issues Quick Fix

| Issue | Quick Solution |
|-------|---------------|
| Can't find disk | Run `lsblk` and identify correct device |
| Network not working | Use `nmtui` to configure Wi-Fi |
| LUKS passphrase rejected | Check keyboard layout (US default) |
| Boot failure | Reboot from USB and check GRUB config |

---

## 🎓 Learning Resources

### Nix/NixOS Basics
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Tutorial series
- [NixOS Wiki](https://nixos.wiki/) - Community documentation
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

### Advanced Topics
- [Flakes](https://nixos.wiki/wiki/Flakes) - Modern Nix package management
- [Disko](https://github.com/nix-community/disko) - Declarative partitioning
- [Impermanence](https://github.com/nix-community/impermanence) - Ephemeral root

---

## 📝 Repository Structure

```
nixme/
├── 📄 INSTALL-GUIDE-BARE-METAL.md    ← Bare-metal installation
├── 📄 INSTALL-GUIDE-VIRTUALBOX.md      ← VM testing guide (this file)
├── 📄 INSTALL-GUIDES-INDEX.md          ← This index
├── flake.nix                          ← Main flake configuration
├── hosts/
│   └── ghost/
│       ├── default.nix               ← Ghost laptop config
│       ├── disko.nix                 ← Disk partitioning
│       ├── hardware.nix              ← Hardware settings
│       └── install-ghost.sh          ← Automated installer script
├── modules/
│   ├── nixos/                        ← System modules
│   └── home/                         ← Home Manager modules
└── parts/                             ← Flake parts
```

---

## ✅ Pre-Installation Checklist

Before starting either guide, ensure you have:

- [ ] USB drive (8GB+)
- [ ] Stable internet connection
- [ ] 2-4 hours uninterrupted time
- [ ] Read through the guide once
- [ ] For bare-metal: **BACKUPS COMPLETED**
- [ ] LUKS passphrase decided (write it down securely!)

---

## 🎉 Ready to Start?

Choose your path:

**🧪 Test First:** [VirtualBox Guide →](INSTALL-GUIDE-VIRTUALBOX.md)

**🚀 Install Now:** [Bare-Metal Guide →](INSTALL-GUIDE-BARE-METAL.md)

---

*Good luck with your NixOS journey!* 🚀