# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/DISKO.NIX - Declarative Disk Partitioning
# ═══════════════════════════════════════════════════════════════════════════════
#
# This configuration uses disko to declaratively partition and format disks.
# It creates a LUKS-encrypted BTRFS setup optimized for the Ghost laptop.
#
# PARTITION SCHEME:
# ─────────────────
# /dev/nvme0n1 (Main SSD)
# ├── Partition 1: EFI System (512MiB, FAT32, mounted at /boot)
# ├── Partition 2: LUKS-encrypted container
#     └── lvm-pool: LVM for flexibility
#         ├── root: BTRFS filesystem (mounted at /)
#         └── swap: Encrypted swap
#
# BTRFS SUBVOLUMES:
# ─────────────────
# @         - Root filesystem
# @home     - User home directories
# @nix      - Nix store (allows for rollback)
# @persist  - Persistent data across reinstalls
# @log      - Log files
#
# USAGE:
# ──────
# From a NixOS live USB, run:
#   sudo nix run github:nix-community/disko -- --mode disko /path/to/this/file.nix
#
# Then install NixOS:
#   sudo nixos-install --flake .#ghost
#
# ═══════════════════════════════════════════════════════════════════════════════

{
  disko.devices = {
    # ═══════════════════════════════════════════════════════════════════════════
    # DISK CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    disk = {
      main = {
        # Adjust this device name based on your actual disk
        # Use `lsblk` to find your disk (usually nvme0n1 for NVMe SSDs)
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # ───────────────────────────────────────────────────────────────────
            # EFI System Partition (ESP)
            # ───────────────────────────────────────────────────────────────────
            ESP = {
              name = "ESP";
              size = "512MiB";
              type = "EF00";  # EFI System Partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"  # Secure permissions
                ];
              };
            };

            # ───────────────────────────────────────────────────────────────────
            # LUKS-encrypted partition
            # ───────────────────────────────────────────────────────────────────
            luks = {
              name = "luks";
              size = "100%";  # Use remaining space
              content = {
                type = "luks";
                name = "cryptroot";  # Device will be /dev/mapper/cryptroot
                
                # Prompt for password during installation
                # For automated installs, use `settings.keyFile` or `passwordFile`
                # passwordFile = "/tmp/secret.key";  # Uncomment for key file
                
                # SSD optimizations
                settings = {
                  allowDiscards = true;      # Enable TRIM for SSD performance
                  bypassWorkqueues = true;     # Reduce latency
                };

                # Additional key files (optional)
                # extraKeyFiles = [ "/tmp/additional-secret.key" ];

                # The content inside the LUKS container
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # LVM CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        
        # Logical volumes
        lvs = {
          # ───────────────────────────────────────────────────────────────────
          # Root filesystem (BTRFS)
          # ───────────────────────────────────────────────────────────────────
          root = {
            size = "100%FREE";  # Use all remaining space
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];  # Force creation
              
              # BTRFS subvolumes
              subvolumes = {
                # Root filesystem
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd:1"    # Compression for SSD
                    "noatime"            # Reduce writes
                    "discard=async"      # Async TRIM
                  ];
                };
                
                # User home directories
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
                
                # Nix store - separate for easy rollback
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
                
                # Persistent data across reinstalls
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
                
                # Log files
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };

    # ═══════════════════════════════════════════════════════════════════════════
    # SWAP CONFIGURATION
    # ═══════════════════════════════════════════════════════════════════════════
    # Using swapfile on BTRFS instead of separate partition
    # This is more flexible and works with snapshots
    # Note: Swap files on BTRFS require Linux kernel 5.0+
    # Alternative: Create a separate swap LV if needed
  };
}