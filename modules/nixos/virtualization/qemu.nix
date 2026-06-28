# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/VIRTUALIZATION/QEMU.NIX - QEMU/KVM Virtualization
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
  
  # Add user to libvirtd group
  users.users.${vars.username}.extraGroups = [ "libvirtd" ];
  
  # VirtualBox (optional - usually one or the other)
  # virtualisation.virtualbox.host.enable = true;
  # users.users.${vars.username}.extraGroups = [ "vboxusers" ];
  
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice-gtk
    spice-protocol
    virtio-win
    qemu_kvm
    qemu
    OVMF
    libguestfs
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
