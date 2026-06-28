# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/DEVELOPMENT.NIX - Development Tools
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  # ═══════════════════════════════════════════════════════════════════════════
  # EDITORS
  # ═══════════════════════════════════════════════════════════════════════════
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    
    # Use nixvim for more advanced configuration
    # For now, basic nvim with plugins
    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      vim-plug
      
      # Essential plugins
      nvim-treesitter
      nvim-lspconfig
      nvim-cmp
      nvim-tree-lua
      telescope-nvim
      which-key-nvim
    ];
  };
  
  # VSCode
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    extensions = with pkgs.vscode-extensions; [
      # General
      ms-vscode.atom-keybindings
      pkief.material-icon-theme
      
      # Nix
      jnoortheen.nix-ide
      bbenoist.nix
      
      # Python
      ms-python.python
      ms-python.vscode-pylance
      
      # JavaScript/TypeScript
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      
      # Rust
      rust-lang.rust-analyzer
      
      # Go
      golang.go
      
      # Shell
      timonwong.shellcheck
      
      # Git
      eamodio.gitlens
      github.copilot
      
      # Markdown
      yzhang.markdown-all-in-one
      
      # Docker
      ms-azuretools.vscode-docker
      
      # Kubernetes
      ms-kubernetes-tools.vscode-kubernetes-tools
    ];
    
    userSettings = {
      "editor.fontFamily" = "JetBrains Mono, monospace";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.5;
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = false;
      "editor.rulers" = [ 80 120 ];
      "editor.renderWhitespace" = "boundary";
      "editor.wordWrap" = "on";
      "editor.minimap.enabled" = false;
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "material-icon-theme";
      
      "terminal.integrated.fontFamily" = "JetBrains Mono";
      "terminal.integrated.fontSize" = 13;
      
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      
      "python.formatting.provider" = "black";
      "python.linting.enabled" = true;
      "python.linting.pylintEnabled" = true;
      
      "rust-analyzer.cargo.autoReload" = true;
      "rust-analyzer.checkOnSave.command" = "clippy";
    };
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # LANGUAGES
  # ═══════════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.black
    python3Packages.isort
    python3Packages.flake8
    python3Packages.pylint
    python3Packages.mypy
    poetry
    
    # Node.js
    nodejs
    yarn
    pnpm
    
    # Rust
    rustup
    cargo
    rustc
    rustfmt
    clippy
    cargo-watch
    cargo-edit
    
    # Go
    go
    gopls
    golint
    go-tools
    
    # C/C++
    gcc
    gdb
    gnumake
    cmake
    
    # Java
    jdk
    maven
    gradle
    
    # Haskell
    ghc
    cabal-install
    stack
    
    # Lua
    lua
    lua-language-server
    stylua
    
    # Shell
    shellcheck
    shfmt
    
    # Nix
    nixfmt
    nixpkgs-fmt
    nixd
    statix
    deadnix
    
    # Database
    postgresql
    redis
    sqlite
    
    # Container
    docker-compose
    kubectl
    helm
    
    # Cloud
    awscli2
    azure-cli
    google-cloud-sdk
    terraform
    ansible
    
    # Documentation
    graphviz
    plantuml
    
    # API testing
    postman
    insomnia
    httpie
    
    # Markdown
    glow
    marksman
    
    # JSON
    jq
    yq
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # DEVCONTAINERS
  # ═══════════════════════════════════════════════════════════════════════════
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
