# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/VIRTUALIZATION/DEFAULT.NIX - Virtualization Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Configures QEMU/KVM, VirtualBox, and Podman container support.
# Optimized for Ghost laptop running 4 Linux distro VMs.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, const, ... }: {

  # ═══════════════════════════════════════════════════════════════════════════
  # QEMU/KVM CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };
  
  # Add user to libvirtd group for VM management
  users.users.${vars.username}.extraGroups = [ "libvirtd" ];

  # ═══════════════════════════════════════════════════════════════════════════
  # VIRTUALBOX CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  virtualisation.virtualbox.host = {
    enable = true;
    # Extension pack provides USB passthrough, PXE boot, VRDE support
    # Note: Requires manual acceptance of license on first use
    enableExtensionPack = false;
  };
  
  # Add user to vboxusers group for USB device access
  users.users.${vars.username}.extraGroups = [ "vboxusers" ];
  
  # Enable KVM nested virtualization for VirtualBox
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm nested=1
  '';

  # ═══════════════════════════════════════════════════════════════════════════
  # PODMAN (Rootless Containers)
  # ═══════════════════════════════════════════════════════════════════════════
  virtualisation.podman = {
    enable = true;
    # Enable Docker-compatible socket
    dockerSocket.enable = true;
    # Use extraPackages to install additional Podman tools
    extraPackages = with pkgs; [
      podman-compose
      podman-tui
    ];
  };
  
  # Enable container networking
  virtualisation.containers.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # QEMU/KVM tools
    virt-manager        # GUI for VM management
    virt-viewer       # VM display viewer
    spice-gtk         # SPICE protocol client
    spice-protocol    # SPICE protocol headers
    virtio-win        # Windows virtio drivers (for Windows VMs)
    qemu_kvm          # KVM-accelerated QEMU
    qemu              # Full QEMU emulator
    OVMF              # UEFI firmware for VMs
    libguestfs        # VM disk image manipulation
    
    # VirtualBox
    virtualbox
    
    # Podman tools
    podman
    podman-compose
    podman-tui
    skopeo            # Container image management
    buildah           # Build OCI images
    
    # VM management
    vagrant
    distrobox         # Run any Linux distro in containers
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # SERVICES
  # ═══════════════════════════════════════════════════════════════════════════
  # SPICE agent for clipboard sharing between host and VMs
  services.spice-vdagentd.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORKING FOR VMs
  # ═══════════════════════════════════════════════════════════════════════════
  # NAT configuration for VM networking
  networking.nat = {
    enable = true;
    internalInterfaces = [ "virbr0" ];
    externalInterface = lib.mkDefault "wlan0";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # VM SSH PORT FORWARDING (4 Linux Distro VMs)
  # ═══════════════════════════════════════════════════════════════════════════
  # Configure port forwarding for SSH access to VMs
  # Each VM gets a unique host port to avoid conflicts
  
  networking.firewall.allowedTCPPorts = [
    # SSH ports for VMs (from const or defaults)
    (const.vm-ssh-ports.kali-vm or 2221)      # Kali Linux VM
    (const.vm-ssh-ports.debian-vm or 2222)    # Debian VM  
    (const.vm-ssh-ports.fedora-vm or 2223)    # Fedora/Rocky VM
    # Add Rocky Linux VM port if different from Fedora
    # (const.vm-ssh-ports.rocky-vm or 2224)   # Rocky Linux VM
    # (const.vm-ssh-ports.nixos-vm or 2225)   # NixOS VM
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # VM CONFIGURATION EXAMPLES (Commented)
  # ═══════════════════════════════════════════════════════════════════════════
  # To create the 4 Linux VMs (Kali, Debian, Rocky, NixOS):
  #
  # 1. Kali Linux VM:
  #    - Download Kali Linux ISO
  #    - virt-install --name kali-vm --memory 4096 --vcpus 2 \
  #      --disk size=40 --cdrom kali-linux.iso --network bridge=virbr0
  #
  # 2. Debian VM:
  #    - Download Debian ISO
  #    - virt-install --name debian-vm --memory 4096 --vcpus 2 \
  #      --disk size=40 --cdrom debian.iso --network bridge=virbr0
  #
  # 3. Rocky Linux VM:
  #    - Download Rocky Linux ISO
  #    - virt-install --name rocky-vm --memory 4096 --vcpus 2 \
  #      --disk size=40 --cdrom rocky.iso --network bridge=virbr0
  #
  # 4. NixOS VM:
  #    - Build from this flake
  #    - virt-install --name nixos-vm --memory 4096 --vcpus 2 \
  #      --disk size=40 --cdrom nixos.iso --network bridge=virbr0
  #
  # SSH Access from host:
  #   ssh -p 2221 user@localhost    # Kali VM
  #   ssh -p 2222 user@localhost    # Debian VM
  #   ssh -p 2223 user@localhost    # Rocky/Fedora VM
  #   ssh -p 2224 user@localhost    # NixOS VM
  #
  # ═══════════════════════════════════════════════════════════════════════════
  # VIRTUALBOX SPECIFIC VM CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  # To create VMs in VirtualBox:
  #
  # 1. Enable KVM nested virtualization for better performance:
  #    VBoxManage modifyvm "VM-Name" --hwvirtex on
  #    VBoxManage modifyvm "VM-Name" --nested-hw-virt on
  #
  # 2. Enable 3D acceleration (optional):
  #    VBoxManage modifyvm "VM-Name" --vram 128 --accelerate3d on
  #
  # 3. Configure networking (NAT with port forwarding):
  #    VBoxManage modifyvm "VM-Name" --nic1 nat
  #    VBoxManage modifyvm "VM-Name" --natpf1 "ssh,tcp,,2221,,22"
}
