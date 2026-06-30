{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      cursor_shape = "beam";
      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "default";
      default_shell = "bash";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [ nvim-treesitter lualine-nvim ];
    extraConfig = "set number\nset expandtab\nset tabstop=2\nset shiftwidth=2";
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "screen-256color";
    escapeTime = 0;
    baseIndex = 1;
    newSession = true;
  };

  programs.lazygit = {
    enable = true;
  };

  home.packages = with pkgs; [
    ranger nnn lazygit lazydocker vim nano less delta
  ];
}
