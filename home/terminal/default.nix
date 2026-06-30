# ═══════════════════════════════════════════════════════════════════════════════
# HOME/TERMINAL/DEFAULT.NIX - Terminal Tools (Home Manager)
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # KITTY TERMINAL
  # ═══════════════════════════════════════════════════════════════════════════
  programs.kitty = {
    enable = true;
    settings = {
      # Font
      font_family = "JetBrains Mono";
      font_size = 12;
      
      # Window
      remember_window_size = true;
      initial_window_width = "100c";
      initial_window_height = "30c";
      window_padding_width = "2.0";
      
      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0.5;
      
      # Scrollback
      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-control-chars";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Audio
      enable_audio_bell = false;
      
      # Colors (can be overridden)
      background_opacity = "0.95";
    };
    
    # Key mappings
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
      "ctrl+equal" = "increase_font_size";
      "ctrl+minus" = "decrease_font_size";
      "ctrl+0" = "restore_font_size";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ZELLIJ - Terminal Multiplexer
  # ═══════════════════════════════════════════════════════════════════════════
  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin";
      default_shell = "bash";
      pane_frames = false;
      copy_command = "wl-copy";
      copy_clipboard = "system";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NEOVIM
  # ═══════════════════════════════════════════════════════════════════════════
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Core
      nvim-treesitter
      nvim-lspconfig
      
      # UI
      lualine-nvim
      nvim-tree-lua
      telescope-nvim
      
      # Editing
      vim-surround
      vim-commentary
      
      # Git
      vim-fugitive
      gitsigns-nvim
    ];
    
    extraConfig = ''''
      " Basic settings
      set number
      set relativenumber
      set cursorline
      set nowrap
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set smartindent
      set clipboard=unnamedplus
      
      " Search
      set ignorecase
      set smartcase
      set hlsearch
      set incsearch
      
      " Enable mouse
      set mouse=a
      
      " Colors
      set termguicolors
      set background=dark
    ''';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # TMUX (backup for zellij)
  # ═══════════════════════════════════════════════════════════════════════════
  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    escapeTime = 0;
    baseIndex = 1;
    newSession = true;
    
    extraConfig = ''''
      # Mouse support
      set -g mouse on
      
      # Status bar
      set -g status-style bg=black,fg=white
      set -g status-left '#[fg=green]#S '
      set -g status-right '#[fg=yellow]%Y-%m-%d #[fg=green]%H:%M'
      
      # Window status
      setw -g window-status-current-style fg=black,bg=green
      
      # Enable vi keys
      setw -g mode-keys vi
      
      # Copy to clipboard
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
    ''';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # LAZYGIT
  # ═══════════════════════════════════════════════════════════════════════════
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        activeBorderColor = [ "#fab387" "bold" ];
        inactiveBorderColor = [ "#a6adc8" ];
        selectedLineBgColor = [ "#313244" ];
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # File managers
    ranger
    nnn
    
    # TUI apps
    lazygit
    lazydocker
    
    # Editors
    vim
    nano
    
    # Pagers
    less
    most
    
    # Diff
    delta
    difftastic
  ];
}
