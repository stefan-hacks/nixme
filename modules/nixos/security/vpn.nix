# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/SECURITY/VPN.NIX - VPN Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # VPN clients
    openvpn
    wireguard-tools
    mullvad-vpn
    
    # Network tools
    networkmanager-openvpn
    networkmanager-wireguard
  ];
  
  # WireGuard kernel module
  boot.kernelModules = [ "wireguard" ];
}
