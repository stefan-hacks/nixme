# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/VIRTUALIZATION/QEMU.NIX - QEMU/KVM and VirtualBox Virtualization
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, const, ... }: {
  # Enable virtualization
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      # OVMF is now included with QEMU by default - no separate config needed
      swtpm.enable = true;
    };
  };
  
  # Add user to libvirtd and vboxusers groups
  users.users.${vars.username}.extraGroups = [ "libvirtd" "vboxusers" ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # VIRTUALBOX CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  virtualisation.virtualbox.host = {
    enable = true;
    # Enable the VirtualBox kernel module
    enableExtensionPack = false;  # Set to true if you need USB passthrough, PXE, etc.
  };
  
  # Enable KVM for VirtualBox (hybrid mode)
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
    options kvm nested=1
  '';
  
  environment.systemPackages = with pkgs; [
    # QEMU/KVM tools
    virt-manager
    virt-viewer
    spice-gtk
    spice-protocol
    virtio-win
    qemu_kvm
    qemu
    OVMF
    libguestfs
    
    # VirtualBox
    virtualbox
    
    # VM management helper
    vagrant
  ];
  
  # Enable SPICE USB redirection
  services.spice-vdagentd.enable = true;
  
  # VM SSH port forwarding
  networking.nat = {
    enable = true;
    internalInterfaces = [ "virbr0" ];
    externalInterface = "wlan0";
  };
  
  # Firewall rules for VM SSH
  networking.firewall.allowedTCPPorts = [
    const.vm-ssh-ports.kali-vm or 2221
    const.vm-ssh-ports.debian-vm or 2222
    const.vm-ssh-ports.fedora-vm or 2223
  ];
}
