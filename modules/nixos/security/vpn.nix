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
    # Note: networkmanager-wireguard plugin removed - WireGuard support 
    # is now built into NetworkManager itself in recent versions
  ];
  
  # WireGuard kernel module
  boot.kernelModules = [ "wireguard" ];
}
