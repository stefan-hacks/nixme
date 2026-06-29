# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/DISKO-VM.NIX - Disko Configuration for VirtualBox VM
# ═══════════════════════════════════════════════════════════════════════════════
#
# This is a modified disko configuration for testing in VirtualBox.
# It uses /dev/sda instead of /dev/nvme0n1 (VirtualBox uses SCSI/SATA device naming).
#
# DIFFERENCES FROM DISKO.NIX:
# - Device: /dev/sda (VirtualBox virtual disk)
# - No EFI partition size increase needed
# - Same LUKS + BTRFS layout
#
# ═══════════════════════════════════════════════════════════════════════════════

{
  disko.devices = {
    disk = {
      main = {
        # VirtualBox virtual disk - typically /dev/sda for SATA/SCSI
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition
            ESP = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };

            # LUKS-encrypted partition
            luks = {
              name = "luks";
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };

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

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                    "discard=async"
                  ];
                };
                
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
                
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
                
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                };
                
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
  };
}