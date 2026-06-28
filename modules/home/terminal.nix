# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/TERMINAL.NIX - Terminal Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Kitty terminal emulator and Zellij multiplexer configuration.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  # ═══════════════════════════════════════════════════════════════════════════
  # KITTY - Terminal Emulator
  # ═══════════════════════════════════════════════════════════════════════════
  programs.kitty = {
    enable = true;
    
    settings = {
      # Font configuration
      font_family = "JetBrains Mono";
      bold_font = "JetBrains Mono Bold";
      italic_font = "JetBrains Mono Italic";
      bold_italic_font = "JetBrains Mono Bold Italic";
      font_size = 11;
      
      # Colors - Catppuccin Mocha theme
      foreground = "#cdd6f4";
      background = "#1e1e2e";
      selection_foreground = "#1e1e2e";
      selection_background = "#f5e0dc";
      
      # Cursor
      cursor = "#f5e0dc";
      cursor_text_color = "#1e1e2e";
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      
      # Scrollback
      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS";
      
      # URLs
      url_color = "#f5e0dc";
      url_style = "curly";
      
      # Window
      window_padding_width = 4;
      window_margin_width = 0;
      hide_window_decorations = false;
      confirm_os_window_close = 0;
      
      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_bar_min_tabs = 2;
      
      # Bell
      enable_audio_bell = false;
      visual_bell_duration = 0;
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Terminal
      term = "xterm-256color";
      shell = ".";
      close_on_child_death = false;
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";
    };
    
    # Color scheme
    extraConfig = ''
      # Catppuccin Mocha colors
      color0  #45475a
      color1  #f38ba8
      color2  #a6e3a1
      color3  #f9e2af
      color4  #89b4fa
      color5  #f5c2e7
      color6  #94e2d5
      color7  #bac2de
      color8  #585b70
      color9  #f38ba8
      color10 #a6e3a1
      color11 #f9e2af
      color12 #89b4fa
      color13 #f5c2e7
      color14 #94e2d5
      color15 #a6adc8
      
      # Tab bar colors
      active_tab_foreground   #1e1e2e
      active_tab_background   #cba6f7
      inactive_tab_foreground #cdd6f4
      inactive_tab_background #313244
      tab_bar_background      #181825
    '';
    
    # Key mappings
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+f" = "show_scrollback";
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      "ctrl+shift+e" = "kitten hints";
      "ctrl+shift+p>n" = "kitten hints --type=linenum";
      "ctrl+shift+p>f" = "kitten hints --type=path";
      "ctrl+shift+p>shift+f" = "kitten hints --type=path --program -";
      "ctrl+shift+p>h" = "kitten hints --type=hash";
      "ctrl+shift+p>ip" = "kitten hints --type=ip";
      "ctrl+shift+p>url" = "kitten hints --type=url";
      "ctrl+shift+p>uuid" = "kitten hints --type=uuid";
      "f11" = "toggle_fullscreen";
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      "ctrl+shift+f5" = "load_config_file";
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # ZELLIJ - Terminal Multiplexer
  # ═══════════════════════════════════════════════════════════════════════════
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    # Zsh disabled - using bash as default shell
    enableZshIntegration = false;
    
    settings = {
      theme = "catppuccin-mocha";
      default_shell = "bash";
      
      ui = {
        pane_frames = true;
        
        # Theme colors
        "theme" = "catppuccin-mocha";
      };
      
      # Keybinds
      keybinds = {
        normal = {
          "bind \"Ctrl h\"" = { "SwitchToMode\" = "Move\""; };
          "bind \"Ctrl t\"" = { "SwitchToMode\" = "Tab\""; };
          "bind \"Ctrl n\"" = { "NewPane\" = ""; };
          "bind \"Ctrl f\"" = { "ToggleFocusFullscreen\" = ""; };
          "bind \"Ctrl p\"" = { "SwitchToMode\" = "Pane\""; };
        };
        locked = {
          "bind \"Ctrl g\"" = { "SwitchToMode\" = "Normal\""; };
        };
      };
      
      # Layouts
      simplified_ui = false;
      
      # Scrollback
      scrollback_editor = "nvim";
      
      # Copy
      copy_command = "wl-copy";
      copy_clipboard = "system";
      
      # Mirroring
      mirror = "both";
      
      # Layout directory
      layout_dir = "$HOME/.config/zellij/layouts";
    };
  };
  
  # Create Zellij layouts directory
  home.file.".config/zellij/layouts/default.kdl".text = ''
    layout {
        pane split_direction="vertical" {
            pane
            pane split_direction="horizontal" {
                pane
                pane
            }
        }
        pane size=2 borderless=true {
            plugin location="zellij:status-bar"
        }
    }
  '';
  
  # ═══════════════════════════════════════════════════════════════════════════
  # Additional terminal packages
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # Terminal recording
    asciinema
    
    # Terminal image viewer
    chafa
    
    # Terminal music visualizer
    cava
    
    # TTY clock
    tty-clock
  ];
}
