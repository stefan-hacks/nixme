# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/GHOST/HOME.NIX - stefan-hacks User Configuration (Simplified)
# ═══════════════════════════════════════════════════════════════════════════════
#
# Home Manager configuration for stefan-hacks on Ghost laptop.
# Dotfiles, terminal config, and daily driver applications.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, vars, ... }: {

  # ═══════════════════════════════════════════════════════════════════════════
  # USER PACKAGES - Daily Driver Applications
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # ═══════════════════════════════════════════════════════════════════════════
    # BROWSERS
    # ═══════════════════════════════════════════════════════════════════════════
    firefox
    chromium
    
    # ═══════════════════════════════════════════════════════════════════════════
    # COMMUNICATION
    # ═══════════════════════════════════════════════════════════════════════════
    discord
    # telegram-desktop    # Uncomment if needed
    # signal-desktop      # Uncomment if needed
    
    # ═══════════════════════════════════════════════════════════════════════════
    # PRODUCTIVITY
    # ═══════════════════════════════════════════════════════════════════════════
    libreoffice
    obsidian
    # joplin-desktop    # Uncomment if needed
    # thunderbird       # Email client
    
    # ═══════════════════════════════════════════════════════════════════════════
    # MEDIA
    # ═══════════════════════════════════════════════════════════════════════════
    vlc
    mpv
    # spotify           # Uncomment if needed
    # obs-studio        # Screen recording/streaming
    
    # ═══════════════════════════════════════════════════════════════════════════
    # DEVELOPMENT
    # ═══════════════════════════════════════════════════════════════════════════
    # vscode            # Use pkgs.vscode or pkgs.vscodium
    # jetbrains.idea-ultimate  # IntelliJ IDEA
    # postman           # API testing
    # insomnia          # Alternative API client
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SYSTEM TOOLS
    # ═══════════════════════════════════════════════════════════════════════════
    htop
    btop
    ncdu              # Disk usage analyzer
    fd                # Better find
    ripgrep           # Better grep
    fzf               # Fuzzy finder
    zoxide            # Better cd
    bat               # Better cat
    eza               # Better ls
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SECURITY
    # ═══════════════════════════════════════════════════════════════════════════
    # 1password         # Password manager (uncomment when ready)
    # mullvad-vpn       # VPN client (uncomment when ready)
    # wireguard-tools   # WireGuard CLI
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # DOTFILES - Terminal Configuration
  # ═══════════════════════════════════════════════════════════════════════════
  # 
  # Kitty terminal configuration is handled by modules/home/terminal.nix
  # which is imported via the home configuration.
  # 
  # To customize kitty settings, edit modules/home/terminal.nix or
  # add host-specific overrides below.

  # ═══════════════════════════════════════════════════════════════════════════
  # SHELL CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  programs.bash = {
    enable = true;
    
    # Aliases (using mkForce to override home-manager defaults)
    shellAliases = lib.mkForce {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Better defaults
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      tree = "eza --tree --icons";
      cat = "bat";
      
      # Nix
      ns = "sudo nixos-rebuild switch --flake /home/stefan-hacks/.config/nixme#ghost";
      nb = "sudo nixos-rebuild build --flake /home/stefan-hacks/.config/nixme#ghost";
      ncg = "sudo nix-collect-garbage -d";
      nf = "nix flake check --flake /home/stefan-hacks/.config/nixme";
      
      # System
      c = "clear";
      
      # Git
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gs = "git status";
      gl = "git log --oneline --graph";
      gd = "git diff";
      
      # SSH to VMs (convenience aliases)
      sshkali = "ssh kali";
      sshdebian = "ssh debian";
      sshrocky = "ssh rocky";
      sshnixos = "ssh nixos";
      sshlin = "ssh lin";
    };
    
    # Bash prompt (simple, can customize later)
    bashrcExtra = ''
      # Custom prompt with git branch
      parse_git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \\(.\\*\\)/ (\\1)/'
      }
      export PS1="\\u@\\h \\[\\033[34m\\]\\w\\[\\033[0m\\]\\[\\033[33m\\]\\$(parse_git_branch)\\[\\033[0m\\] \\$ "
      
      # Enable fzf key bindings
      if [ -f "${pkgs.fzf}/share/bash-completion/completions/fzf.bash" ]; then
        source "${pkgs.fzf}/share/bash-completion/completions/fzf.bash"
      fi
      
      # zoxide initialization
      eval "$(zoxide init bash)"
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SSH CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  # Disable defaults, define our own
    
    # Host-specific configurations using the new settings format
    settings = {
      # Wildcard - default settings for all hosts
      "*" = {
        # Global settings
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        TCPKeepAlive = "yes";
        
        # Control master settings (connection multiplexing)
        ControlMaster = "auto";
        ControlPath = "~/.ssh/controlmasters/%r@%h:%p";
        ControlPersist = "10m";
      };
      
      # Virtual Machines (all on localhost via port forwarding)
      "kali" = {
        HostName = "localhost";
        User = "h4ck3r";
        Port = 2221;
      };
      
      "debian" = {
        HostName = "localhost";
        User = "user1";
        Port = 2222;
      };
      
      "rocky" = {
        HostName = "localhost";
        User = "user1";
        Port = 2223;
      };
      
      "nixos" = {
        HostName = "localhost";
        User = "stefan-hacks";
        Port = 2224;
      };
      
      # LIN AI - Remote machine
      "lin" = {
        HostName = "192.168.0.155";
        User = "lin";
        Port = 22;
      };
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # FILE AND DIRECTORY SETUP
  # ═══════════════════════════════════════════════════════════════════════════
  home.file = {
    # SSH controlmasters directory for connection multiplexing
    ".ssh/controlmasters/.keep".text = "";
    
    # Create common directories
    "Documents/.keep".text = "";
    "Downloads/.keep".text = "";
    "Pictures/.keep".text = "";
    "Music/.keep".text = "";
    "Videos/.keep".text = "";
    "Workspace/.keep".text = "";
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # KANATA CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  # Kanata is configured at the system level in modules/nixos/hardware/kanata.nix
  # The config file is at assets/kanata/kanata.kbd
  # Home-level kanata configuration would go here if needed
  # (e.g., per-user kanata instances)
}
