# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/SHELL.NIX - Shell Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# User-level shell aliases and configuration.
# These take priority over system-wide aliases.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  # ═══════════════════════════════════════════════════════════════════════════
  # SHELL ALIASES
  # ═══════════════════════════════════════════════════════════════════════════
  home.shellAliases = {
    # Modern replacements
    "ls" = "eza --icons --group-directories-first";
    "ll" = "eza -l --icons --git";
    "la" = "eza -la --icons";
    "lt" = "eza -T --icons --git-ignore";
    "cat" = "bat";
    "catp" = "bat -p";
    "grep" = "rg";
    "find" = "fd";
    "du" = "dust";
    "df" = "duf";
    "ps" = "procs";
    "top" = "btm";
    "man" = "batman";
    
    # Safety aliases
    "rm" = "rm -i";
    "cp" = "cp -i";
    "mv" = "mv -i";
    "mkdir" = "mkdir -p";
    
    # Git shortcuts
    "g" = "git";
    "ga" = "git add";
    "gc" = "git commit";
    "gp" = "git push";
    "gpl" = "git pull";
    "gst" = "git status";
    "gco" = "git checkout";
    "gbr" = "git branch";
    "glog" = "git log --oneline --graph --decorate";
    "gd" = "git diff";
    
    # Nix shortcuts
    "hm" = "home-manager";
    "hms" = "home-manager switch --flake";
    
    # Tool shortcuts
    "y" = "yazi";
    "lg" = "lazygit";
    "glow" = "glow -p";
    
    # Navigation
    "~" = "cd ~";
    "-" = "cd -";
    
    # Quick edits
    "zshrc" = "nvim ~/.zshrc";
    "bashrc" = "nvim ~/.bashrc";
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # STARSHIP - Cross-shell prompt
  # ═══════════════════════════════════════════════════════════════════════════
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      add_newline = false;
      command_timeout = 500;
      continuation_prompt = "▸ ";
      format = "$all$line_break$character";
      
      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
        vicmd_symbol = "[V](bold blue) ";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        fish_style_pwd_dir_length = 2;
      };
      
      git_branch = {
        format = "[$branch]($style) ";
        style = "bold purple";
      };
      
      git_status = {
        format = "[($all_status$ahead_behind)]($style) ";
        style = "bold yellow";
      };
      
      nix_shell = {
        format = "[$symbol($name)]($style) ";
        symbol = "❄️ ";
        style = "bold blue";
      };
      
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bold yellow";
      };
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # ATUIN - Shell history
  # ═══════════════════════════════════════════════════════════════════════════
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      sync.enabled = false;
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # ZOXIDE - Smart cd
  # ═══════════════════════════════════════════════════════════════════════════
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # DIRENV - Environment switcher
  # ═══════════════════════════════════════════════════════════════════════════
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # ZSH - Z shell (optional, if you prefer zsh)
  # ═══════════════════════════════════════════════════════════════════════════
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    
    oh-my-zsh = {
      enable = false;  # Using starship instead
    };
    
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];
    
    initExtra = ''
      # Additional zsh configuration
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      
      # Better history
      HISTSIZE=100000
      SAVEHIST=100000
    '';
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # BASE PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # Shell utilities
    fortune
    cowsay
    lolcat
    figlet
    cmatrix
    
    # File manager
    yazi
    
    # Process viewer
    btop
    
    # System info
    fastfetch
    neofetch
  ];
}
