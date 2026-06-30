# ═══════════════════════════════════════════════════════════════════════════════
# PROFILES/TERMINAL/DEFAULT.NIX - Terminal Development Environment
# ═══════════════════════════════════════════════════════════════════════════════
#
# Comprehensive terminal tooling. Import this for consistent CLI experience.
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # SHELLS
  # ═══════════════════════════════════════════════════════════════════════════
  programs = {
    # Bash with customization
    bash = {
      enable = true;
      enableCompletion = true;
      # Note: Interactive config in Home Manager
    };

    # Zsh (optional, for those who prefer it)
    zsh.enable = lib.mkDefault false;

    # Fish (optional)
    fish.enable = lib.mkDefault false;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ESSENTIAL CLI TOOLS
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Modern replacements
    eza              # ls replacement
    bat              # cat replacement
    fd               # find replacement
    ripgrep          # grep replacement
    fzf              # fuzzy finder
    zoxide           # cd replacement
    btop             # top replacement
    duf              # df replacement
    dust             # du replacement
    procs            # ps replacement
    sd               # sed replacement
    choose           # cut/awk replacement

    # Shell enhancements
    starship         # prompt
    zellij           # terminal multiplexer
    tmux             # backup multiplexer

    # File operations
    rsync
    rclone
    restic

    # Text processing
    jq
    yq
    jc
    csvkit

    # Compression
    zstd
    brotli

    # Network
    curl
    wget
    httpie
    dogdns           # dig replacement
    mtr
    nmap

    # Development
    git
    git-lfs
    lazygit
    delta            # git pager
    just             # command runner
    gnumake
    cmake
    pkg-config

    # Languages (compilers/runtimes)
    gcc
    clang
    llvm
    python3
    nodejs
    go
    rustup

    # Containers
    podman
    podman-compose
    buildah
    skopeo

    # Virtualization
    qemu
    quickemu
    virt-manager

    # Cloud
    kubectl
    helm
    k9s
    terraform
    ansible

    # Security
    age
    sops
    ssh-to-age
    sshpass

    # Fun
    fastfetch
    cowsay
    lolcat
    cmatrix
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # KITTY TERMINAL
  # ═══════════════════════════════════════════════════════════════════════════
  programs.kitty = {
    enable = lib.mkDefault true;
    settings = {
      font_size = lib.mkDefault 12;
      scrollback_lines = lib.mkDefault 10000;
      enable_audio_bell = false;
      cursor_shape = "beam";
      cursor_blink_interval = 0.5;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NEOVIM
  # ═══════════════════════════════════════════════════════════════════════════
  programs.neovim = {
    enable = true;
    defaultEditor = lib.mkDefault true;
    viAlias = true;
    vimAlias = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # CONTAINER TOOLS
  # ═══════════════════════════════════════════════════════════════════════════
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    libvirtd = {
      enable = lib.mkDefault false;
      qemu = {
        ovmf.enable = true;
        swtpm.enable = true;
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # USERS
  # ═══════════════════════════════════════════════════════════════════════════
  users.users.stefan-hacks.extraGroups = [ "podman" ];
}
