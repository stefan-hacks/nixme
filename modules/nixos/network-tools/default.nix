# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/NETWORK-TOOLS/DEFAULT.NIX - Network Tools
# ═══════════════════════════════════════════════════════════════════════════════
#
# Network diagnostic and monitoring tools.
# (Renamed from 'network/' to avoid confusion with core/networking.nix)
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    # Network monitoring
    bandwhich
    iftop
    iotop
    nethogs
    
    # Packet capture/analysis
    tcpdump
    termshark
    
    # Network utilities
    mtr
    iperf3
    socat
    netcat-gnu
    bind
    dogdns
    
    # WiFi
    wavemon
    iw
    
    # Bandwidth testing
    speedtest-cli
    fast-cli
  ];
}
