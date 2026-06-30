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
  # DOTFILES - Kitty Terminal Configuration
  # ═══════════════════════════════════════════════════════════════════════════
  
  # Kitty configuration
  programs.kitty = {
    enable = true;
    settings = {
      # Font
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      
      # Colors (Catppuccin Mocha theme)
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      cursor = "#f38ba8";
      cursor_text_color = "#1e1e2e";
      selection_background = "#353749";
      selection_foreground = "#cdd6f4";
      
      # Color scheme
      color0 = "#45475a";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#89b4fa";
      color5 = "#f5c2e7";
      color6 = "#94e2d5";
      color7 = "#bac2de";
      color8 = "#585b70";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#89b4fa";
      color13 = "#f5c2e7";
      color14 = "#94e2d5";
      color15 = "#a6adc8";
      
      # Window settings
      background_opacity = "0.95";
      enable_audio_bell = false;
      scrollback_lines = 10000;
      window_padding_width = 4;
      
      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0.5;
      
      # Shell
      shell = "${pkgs.bash}/bin/bash";
      
      # Tabs
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_foreground = "#1e1e2e";
      active_tab_background = "#89b4fa";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#313244";
    };
    
    # Keyboard shortcuts
    keybindings = {
      # Tab navigation
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+t" = "new_tab";
      "ctrl+w" = "close_tab";
      
      # Font size
      "ctrl+plus" = "increase_font_size";
      "ctrl+minus" = "decrease_font_size";
      "ctrl+0" = "restore_font_size";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GIT CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  programs.git = {
    enable = true;
    userName = "stefan-hacks";
    userEmail = "stefan@example.com";  # Update with your email
    
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.editor = "nano";
      
      # Delta pager for better diffs
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      delta.line-numbers = true;
      delta.side-by-side = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
    
    # Delta package for better git diffs
    delta.enable = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # BASH SHELL CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  programs.bash = {
    enable = true;
    
    # Aliases
    shellAliases = {
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
    
    # Global settings for all hosts
    extraOptionOverrides = {
      ServerAliveInterval = "60";
      ServerAliveCountMax = "3";
      TCPKeepAlive = "yes";
    };
    
    # Control master settings (connection multiplexing)
    controlMaster = "auto";
    controlPath = "~/.ssh/controlmasters/%r@%h:%p";
    controlPersist = "10m";
    
    # Match blocks for specific hosts
    matchBlocks = {
      # Virtual Machines (all on localhost via port forwarding)
      "kali" = {
        hostname = "localhost";
        user = "h4ck3r";
        port = 2221;
      };
      
      "debian" = {
        hostname = "localhost";
        user = "user1";
        port = 2222;
      };
      
      "rocky" = {
        hostname = "localhost";
        user = "user1";
        port = 2223;
      };
      
      "nixos" = {
        hostname = "localhost";
        user = "stefan-hacks";
        port = 2224;
      };
      
      # LIN AI - Remote machine
      "lin" = {
        hostname = "192.168.0.155";
        user = "lin";
        port = 22;
      };
      
      # ═══════════════════════════════════════════════════════════════════════════
      # ADDITIONAL HOST EXAMPLES (Commented)
      # ═══════════════════════════════════════════════════════════════════════════
      # "myserver" = {
      #   hostname = "192.168.1.100";
      #   user = "admin";
      #   port = 22;
      #   identityFile = "~/.ssh/id_ed25519";
      #   # Or use specific key
      #   # identityFile = "~/.ssh/myserver_key";
      # };
      #
      # "github" = {
      #   hostname = "github.com";
      #   user = "git";
      #   identityFile = "~/.ssh/github_ed25519";
      # };
      #
      # "myserver-proxy" = {
      #   hostname = "192.168.1.100";
      #   user = "admin";
      #   proxyJump = "bastion-host";
      #   # Or use ProxyCommand
      #   # extraOptions = {
      #   #   ProxyCommand = "ssh -W %h:%p bastion-host";
      #   # };
      # };
      #
      # "myserver-tunnel" = {
      #   hostname = "192.168.1.100";
      #   user = "admin";
      #   localForwards = [
      #     { bind.port = 8080; host.address = "localhost"; host.port = 80; }
      #   ];
      #   remoteForwards = [
      #     { bind.port = 9090; host.address = "localhost"; host.port = 9090; }
      #   ];
      # };
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
