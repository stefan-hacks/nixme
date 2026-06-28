# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/CLI-TOOLS.NIX - Modern CLI Tools
# ═══════════════════════════════════════════════════════════════════════════════
#
# Comprehensive collection of modern Unix replacements and CLI utilities.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  programs = {
    zoxide = { enable = true; flags = [ "--cmd cd" ]; };
    fzf = { fuzzyCompletion = true; keybindings = true; };
    
    bat = {
      enable = true;
      settings = { theme = "TwoDark"; style = "numbers,changes,header"; };
      extraPackages = with pkgs.bat-extras; [ batdiff batgrep batman batpipe batwatch prettybat ];
    };
    
    git = { enable = true; };
    
    lazygit = {
      enable = true;
      settings = {
        gui = { showIcons = true; };
        git = {
          paging = { colorArg = "always"; pager = "delta --dark --paging=never"; };
          log = { showGraph = "always"; };
        };
      };
    };
  };
  
  environment.systemPackages = with pkgs; [
    # Modern Unix replacements
    eza fd ripgrep sd procs duf dust bottom
    
    # System monitoring
    btop fastfetch cpufetch onefetch
    
    # Terminal utilities
    grc lolcat figlet chafa cava
    
    # Recording & streaming
    asciinema asciinema-agg
    
    # Shells
    nushell carapace
    
    # Language servers
    bash-language-server nixd pyright typescript-language-server rust-analyzer gopls
    lua-language-server clang-tools vscode-langservers-extracted yaml-language-server marksman
    
    # Tools
    glow gum tealdeer yazi gh gh-dash zstd terminator
    
    # File management
    tree p7zip unzip zip xz zstd
    
    # System monitoring
    htop iotop ncdu
    
    # Network tools
    curl wget rsync nettools inetutils nmap whois dnsutils
    
    # Text processing
    jq yq csvkit
    
    # Misc
    which file lsof pciutils usbutils
  ];
  
  environment.interactiveShellInit = ''
    if command -v carapace &> /dev/null; then source <(carapace _carapace bash); fi
    function yy() { local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"; yazi "$@" --cwd-file="$tmp"; if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then cd -- "$cwd"; fi; rm -f -- "$tmp"; }
  '';
}
