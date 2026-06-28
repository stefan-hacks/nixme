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
    # Note: dogdns was removed in NixOS 26.05 (unmaintained, insecure dependencies)
    # Replaced with doggo - a similar modern DNS client written in Go
    doggo
    
    # WiFi
    wavemon
    iw
    
    # Bandwidth testing
    # Note: fast-cli was removed in NixOS 26.05 (unmaintainable in nixpkgs)
    # speedtest-cli remains available for command-line bandwidth testing
    speedtest-cli
  ];
}
