# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/VIRTUALIZATION/CONTAINERS.NIX - Container Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, ... }: {
  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  
  # Enable Docker (optional - using Podman as default)
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "dns" = [ "1.1.1.1" "8.8.8.8" ];
    };
  };
  
  # Add user to docker/podman groups
  users.users.${vars.username}.extraGroups = [ "docker" ];
  
  environment.systemPackages = with pkgs; [
    podman
    podman-compose
    docker-compose
    skopeo
    buildah
    distrobox
    lazydocker
  ];
}
