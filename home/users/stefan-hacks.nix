# ═══════════════════════════════════════════════════════════════════════════════
# HOME/USERS/STEFAN-HACKS.NIX - Home Manager for stefan-hacks
# ═══════════════════════════════════════════════════════════════════════════════
#
# This defines Home Manager configuration for stefan-hacks user.
# Imported by hosts that include Home Manager.
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  home.username = "stefan-hacks";
  home.homeDirectory = "/home/stefan-hacks";
  home.stateVersion = "26.05";

  # ═══════════════════════════════════════════════════════════════════════════
  # IMPORTS
  # ═══════════════════════════════════════════════════════════════════════════
  imports = [
    ../common                           # Common home settings
    ../terminal                         # Terminal tools
    ../desktop                          # Desktop/GUI (optional - can be removed for servers)
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # USER-SPECIFIC PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # Personal tools
    bitwarden-cli
    # Add more personal packages here
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # PROGRAMS
  # ═══════════════════════════════════════════════════════════════════════════
  programs = {
    # Bash configuration
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        "ll" = "eza -la";
        "la" = "eza -a";
        "lt" = "eza --tree";
        "cat" = "bat";
        ".." = "cd ..";
        "..." = "cd ../..";
        "nixme" = "cd ~/.config/nixme";
        "nrs" = "sudo nixos-rebuild switch --flake ~/.config/nixme#ghost";
        "nrt" = "cd ~/.config/nixme && ./scripts/test-build.sh check";
      };
      initExtra = ''''
        # Starship prompt
        eval "$(${pkgs.starship}/bin/starship init bash)"
        
        # Zoxide
        eval "$(${pkgs.zoxide}/bin/zoxide init bash)"
        
        # Direnv
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      ''';
    };

    # Git
    git = {
      enable = true;
      userName = "Stefan Hacks";
      userEmail = lib.mkDefault "stefan@example.com";  # Change this
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        core.editor = "vim";
        delta.enable = true;
      };
    };

    # SSH
    ssh = {
      enable = true;
      matchBlocks = {
        # Example host
        # "my-server" = {
        #   hostname = "192.168.1.100";
        #   user = "admin";
        #   identityFile = "~/.ssh/id_ed25519";
        # };
      };
    };

    # Starship prompt
    starship = {
      enable = true;
      settings = {
        format = "$all$character";
        character = {
          success_symbol = "[➜](green)";
          error_symbol = "[✗](red)";
        };
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
        git_branch = {
          symbol = "🌱 ";
        };
        nix_shell = {
          symbol = "❄️ ";
          format = "via [$symbol$state](bold blue) ";
        };
      };
    };

    # Direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SERVICES
  # ═══════════════════════════════════════════════════════════════════════════
  services = {
    # Keyring
    gnome-keyring.enable = true;
    
    # File syncing (optional)
    # syncthing.enable = true;
  };
}
