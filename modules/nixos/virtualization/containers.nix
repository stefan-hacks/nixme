# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/VIRTUALIZATION/CONTAINERS.NIX - Container Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, ... }: {
  # Enable Podman (Docker-compatible)
  virtualisation.podman = {
    enable = true;
    # Note: dockerCompat removed - conflicts with virtualisation.docker
    # Use 'alias docker=podman' in shell if needed
    defaultNetwork.settings.dns_enabled = true;
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
