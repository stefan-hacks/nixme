# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/NIXOS/PROGRAMS/BASH.NIX - Bash Shell Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  # ═══════════════════════════════════════════════════════════════════════════
  # BASH CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  programs.bash = {
    enable = true;
    
    # Enable bash completion
    completion.enable = true;
    
    # Interactive shell initialization
    # This runs when bash starts interactively
    interactiveShellInit = ''
      # ═══════════════════════════════════════════════════════════════════════════
      # BLESH - Bash Line Editor (syntax highlighting, auto-suggestions, etc.)
      # ═══════════════════════════════════════════════════════════════════════════
      # Source blesh if available (provides modern features like zsh)
      if [ -f "${pkgs.blesh}/share/blesh/ble.sh" ]; then
        source "${pkgs.blesh}/share/blesh/ble.sh" noattach
        
        # Configure blesh settings
        bleopt history_share=1                    # Share history between sessions
        bleopt highlight_syntax=on                # Enable syntax highlighting
        bleopt highlight_filename=on              # Highlight filenames
        bleopt highlight_variable=on              # Highlight variables
        bleopt complete_auto_complete=on          # Auto-completion
        bleopt complete_menu=on                   # Show completion menu
        bleopt complete_menu_select=on            # Select from menu
        bleopt prompt_rps1=                       # Disable right-side prompt
        
        # Bind keys similar to zsh
        ble-bind -f 'C-r' history-isearch-backward  # Ctrl+R for history search
        ble-bind -f 'C-s' history-isearch-forward   # Ctrl+S for forward search
        ble-bind -f 'up' history-beginning-search-backward
        ble-bind -f 'down' history-beginning-search-forward
      fi
      
      # ═══════════════════════════════════════════════════════════════════════════
      # SHELL HISTORY CONFIGURATION
      # ═══════════════════════════════════════════════════════════════════════════
      # Append to history instead of overwriting
      shopt -s histappend
      
      # History size
      HISTSIZE=100000
      HISTFILESIZE=100000
      HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and commands starting with space
      
      # History timestamp
      HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
      
      # Save and reload history after each command
      PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
      
      # ═══════════════════════════════════════════════════════════════════════════
      # BASH BEHAVIOR OPTIONS
      # ═══════════════════════════════════════════════════════════════════════════
      # Check window size after each command
      shopt -s checkwinsize
      
      # Enable extended glob patterns
      shopt -s extglob
      
      # Enable globstar (**) for recursive matching
      shopt -s globstar 2>/dev/null || true
      
      # ═══════════════════════════════════════════════════════════════════════════
      # BETTER DIRECTORY NAVIGATION
      # ═══════════════════════════════════════════════════════════════════════════
      # Auto-correct minor typos in cd
      shopt -s cdspell
      
      # ═══════════════════════════════════════════════════════════════════════════
      # COLORED MAN PAGES
      # ═══════════════════════════════════════════════════════════════════════════
      export LESS_TERMCAP_mb=$'\e[1;32m'
      export LESS_TERMCAP_md=$'\e[1;32m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'e[0m'
      export LESS_TERMCAP_so=$'\e[01;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;4;31m'
    '';
    
    # Login shell initialization
    # Runs for login shells (e.g., when SSHing in)
    loginShellInit = '''';
    
    # Shell prompt (we're using starship instead, but this is a fallback)
    promptInit = '''';
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM-WIDE BASH ALIASES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.shellAliases = lib.mkDefault {
    # ═══════════════════════════════════════════════════════════════════════════
    # NAVIGATION SHORTCUTS
    # ═══════════════════════════════════════════════════════════════════════════
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "c" = "clear";
    "q" = "exit";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # LISTING (use eza if available, fallback to ls)
    # ═══════════════════════════════════════════════════════════════════════════
    "ls" = "ls --color=auto";
    "l" = "ls -lh";
    "la" = "ls -lah";
    "ll" = "ls -lh";
    "l." = "ls -ldh .*";
    "lx" = "ls -lhX";  # Sort by extension
    "lk" = "ls -lhSr"; # Sort by size (smallest first)
    "lt" = "ls -lhtr"; # Sort by date (newest last)
    
    # ═══════════════════════════════════════════════════════════════════════════
    # FILE OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    "cp" = "cp -iv";  # Interactive, verbose
    "mv" = "mv -iv";  # Interactive, verbose
    "rm" = "rm -I --preserve-root";  # Safer rm
    "mkdir" = "mkdir -pv";  # Create parent directories, verbose
    "mkd" = "mkdir -pv";
    "rmdir" = "rmdir -v";
    "df" = "df -h";  # Human readable
    "du" = "du -h";  # Human readable
    "dud" = "du -d 1 -h";  # Current directory sizes
    "dus" = "du -d 1 -h | sort -h";  # Sort by size
    
    # ═══════════════════════════════════════════════════════════════════════════
    # GREP
    # ═══════════════════════════════════════════════════════════════════════════
    "grep" = "grep --color=auto";
    "fgrep" = "fgrep --color=auto";
    "egrep" = "egrep --color=auto";
    "G" = "| grep";  # Quick pipe to grep
    "L" = "| less";   # Quick pipe to less
    
    # ═══════════════════════════════════════════════════════════════════════════
    # FILE SEARCHING
    # ═══════════════════════════════════════════════════════════════════════════
    "findf" = "find . -type f -name";  # Find files by name
    "findd" = "find . -type d -name";  # Find directories by name
    "findfi" = "find . -type f -iname";  # Find files case-insensitive
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SYSTEM INFO / FETCH TOOLS
    # ═══════════════════════════════════════════════════════════════════════════
    "ff" = "fastfetch";  # Fast system info fetch
    "ffa" = "fastfetch -c all";  # Fastfetch with all modules
    
    # ═══════════════════════════════════════════════════════════════════════════
    # NIXOS SPECIFIC
    # ═══════════════════════════════════════════════════════════════════════════
    "nrs" = "sudo nixos-rebuild switch --flake";
    "nrt" = "sudo nixos-rebuild test --flake";
    "nrb" = "sudo nixos-rebuild build --flake";
    "nrbu" = "sudo nixos-rebuild boot --flake";
    "nfu" = "nix flake update";
    "nfl" = "nix flake lock";
    "nfc" = "nix flake check";
    "nb" = "nix build";
    "ns" = "nix shell";
    "nsp" = "nix-shell -p";  # Quick nix-shell
    "nsh" = "nix-shell";
    "ngc" = "nix-collect-garbage -d";
    "nsr" = "nix search nixpkgs";
    "npi" = "nix path-info -Sh";  # Show closure size
    "npl" = "nix profile list";
    "npr" = "nix profile remove";
    "npiw" = "nix profile wipe-history";
    "ncg" = "nix-collect-garbage --delete-older-than 30d";
    "nh" = "nix-help";
    "nch" = "sudo nix-channel --list";
    "ncha" = "sudo nix-channel --add";
    "nchr" = "sudo nix-channel --remove";
    "nchup" = "sudo nix-channel --update";
    "nd" = "nix develop";
    "nr" = "nix run";
    "ne" = "nix edit";
    "ni" = "nix info";
    "nst" = "nix store";
    "nstgc" = "nix store gc";
    "nstopt" = "nix store optimise";
    "nstverify" = "nix store verify";
    "nstrepair" = "nix store repair";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # GIT SHORTCUTS
    # ═══════════════════════════════════════════════════════════════════════════
    "g" = "git";
    "ga" = "git add";
    "gaa" = "git add --all";
    "gap" = "git add -p";  # Interactive patch add
    "gb" = "git branch";
    "gba" = "git branch -a";  # All branches
    "gbd" = "git branch -d";  # Delete branch
    "gbD" = "git branch -D";  # Force delete
    "gc" = "git commit";
    "gcm" = "git commit -m";
    "gca" = "git commit --amend";
    "gcan" = "git commit --amend --no-edit";
    "gcam" = "git commit -am";  # Add and commit
    "gcl" = "git clone";
    "gco" = "git checkout";
    "gcb" = "git checkout -b";  # Create and checkout branch
    "gcob" = "git checkout -b";
    "gcp" = "git cherry-pick";
    "gd" = "git diff";
    "gds" = "git diff --staged";
    "gf" = "git fetch";
    "gfa" = "git fetch --all";
    "gl" = "git log";
    "glo" = "git log --oneline";
    "glog" = "git log --oneline --graph --decorate";
    "gloga" = "git log --oneline --graph --decorate --all";
    "gm" = "git merge";
    "gp" = "git push";
    "gpf" = "git push --force-with-lease";  # Safer force push
    "gpo" = "git push origin";
    "gpr" = "git pull --rebase";
    "gpl" = "git pull";
    "gr" = "git remote";
    "grv" = "git remote -v";
    "grb" = "git rebase";
    "grbi" = "git rebase -i";  # Interactive rebase
    "grbc" = "git rebase --continue";
    "grba" = "git rebase --abort";
    "grs" = "git reset";
    "grsh" = "git reset --hard";
    "grss" = "git reset --soft";
    "grm" = "git rm";
    "grmc" = "git rm --cached";
    "gst" = "git status";
    "gss" = "git status -s";  # Short status
    "gs" = "git status -s";
    "gsh" = "git show";
    "gstp" = "git stash pop";
    "gstl" = "git stash list";
    "gstd" = "git stash drop";
    "gsta" = "git stash push -m";
    "gsw" = "git switch";  # Modern replacement for checkout
    "gswc" = "git switch -c";  # Create and switch
    "gt" = "git tag";
    "gta" = "git tag -a";
    "gtd" = "git tag -d";
    "gpush" = "git push origin $(git branch --show-current)";
    "gpull" = "git pull origin $(git branch --show-current)";
    "gcurrent" = "git branch --show-current";
    "gunstage" = "git restore --staged";  # Unstage files
    "guncommit" = "git reset --soft HEAD~1";  # Undo last commit, keep changes
    "glast" = "git log -1 HEAD --stat";  # Show last commit details
    "gundo" = "git checkout --";  # Discard changes in file
    
    # ═══════════════════════════════════════════════════════════════════════════
    # DOCKER (if enabled)
    # ═══════════════════════════════════════════════════════════════════════════
    "d" = "docker";
    "dc" = "docker-compose";
    "dps" = "docker ps";
    "dpsa" = "docker ps -a";
    "di" = "docker images";
    "dr" = "docker run";
    "drm" = "docker rm";
    "drmi" = "docker rmi";
    "dstop" = "docker stop";
    "dstart" = "docker start";
    "dlogs" = "docker logs";
    "dexec" = "docker exec -it";
    "dbuild" = "docker build";
    "dpull" = "docker pull";
    "dpush" = "docker push";
    "dcup" = "docker-compose up";
    "dcdown" = "docker-compose down";
    "dcrestart" = "docker-compose restart";
    "dclogs" = "docker-compose logs -f";
    "dcps" = "docker-compose ps";
    "dcbuild" = "docker-compose build";
    "dcpull" = "docker-compose pull";
    "dcbash" = "docker-compose exec";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SYSTEM INFO
    # ═══════════════════════════════════════════════════════════════════════════
    "mem" = "free -h";  # Memory usage
    "cpu" = "lscpu";      # CPU info
    "disk" = "df -h";     # Disk usage
    "mounts" = "mount | column -t";  # Pretty print mounts
    "path" = 'echo -e ${PATH//:/\\n}';  # Show PATH components
    "ports" = "ss -tulanp";  # Show listening ports
    "listening" = "ss -tulanp | grep LISTEN";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # ARCHIVE OPERATIONS
    # ═══════════════════════════════════════════════════════════════════════════
    "tarx" = "tar -xvf";  # Extract
    "tarc" = "tar -cvf";  # Create
    "tarz" = "tar -czvf"; # Create gzip
    "tarxz" = "tar -xzvf"; # Extract gzip
    "untar" = "tar -xvf";
    "unzip" = "unzip -q";  # Quiet unzip
    
    # ═══════════════════════════════════════════════════════════════════════════
    # PROCESS MANAGEMENT
    # ═══════════════════════════════════════════════════════════════════════════
    "psg" = "ps aux | grep";  # Search processes
    "psa" = "ps aux";           # All processes
    "psm" = "ps aux --sort=-%mem | head";  # Top memory users
    "psc" = "ps aux --sort=-%cpu | head";  # Top CPU users
    
    # ═══════════════════════════════════════════════════════════════════════════
    # NETWORK
    # ═══════════════════════════════════════════════════════════════════════════
    "ping" = "ping -c 5";  # Default 5 pings
    "pingg" = "ping -c 5 google.com";  # Quick test
    "myip" = "curl -s ifconfig.me";  # Public IP
    "localip" = "ip addr show | grep 'inet ' | awk '{print $2}' | cut -d/ -f1";  # Local IPs
    "ips" = "ip -c addr";  # Colored IP output
    "nm" = "nmcli";  # NetworkManager
    "nmd" = "nmcli device";
    "nmw" = "nmcli device wifi";
    "nml" = "nmcli connection";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SUDO SHORTCUTS
    # ═══════════════════════════════════════════════════════════════════════════
    "s" = "sudo";
    "se" = "sudoedit";
    "snrs" = "sudo nixos-rebuild switch --flake";
    "snfu" = "sudo nix flake update";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # EDITOR SHORTCUTS
    # ═══════════════════════════════════════════════════════════════════════════
    "v" = "nvim";
    "vi" = "nvim";
    "vim" = "nvim";
    "n" = "nvim";
    "nv" = "nvim";
    "e" = "$EDITOR";
    "sudoedit" = "sudo -e";
    "brc" = "nvim ~/.bashrc";
    "zrc" = "nvim ~/.zshrc";  # Keep for convenience even with bash
    "nconf" = "cd /etc/nixos \u0026\u0026 sudo nvim";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # QUICK CONFIG EDITS
    # ═══════════════════════════════════════════════════════════════════════════
    "hosts" = "sudo nvim /etc/hosts";
    "fstab" = "sudo nvim /etc/fstab";
    "sshconfig" = "nvim ~/.ssh/config";
    "sshd" = "sudo nvim /etc/ssh/sshd_config";
    
    # ═══════════════════════════════════════════════════════════════════════════
    # SAFETY ALIASES
    # ═══════════════════════════════════════════════════════════════════════════
    "please" = "sudo";  # Polite sudo
    "fuck" = "sudo !!"; # Fix last command with sudo (requires thefuck or similar)
    "kill9" = "kill -9";  # Force kill
    "kill15" = "kill -15"; # Graceful kill
    
    # ═══════════════════════════════════════════════════════════════════════════
    # MISCELLANEOUS
    # ═══════════════════════════════════════════════════════════════════════════
    "h" = "history";
    "j" = "jobs -l";  # List jobs with PIDs
    "reload" = "exec bash -l";  # Reload bash
    "rsync" = "rsync -avz --progress";  # Rsync with progress
    "rsyncd" = "rsync -avz --progress --delete";  # Rsync with delete
    "wget" = "wget -c";  # Continue partial downloads
    "sha" = "sha256sum";  # Quick checksum
    "md5" = "md5sum";
    "weather" = "curl wttr.in";  # Weather info
    "moon" = "curl wttr.in/Moon";  # Moon phase
    "cal" = "ncal -3";  # 3-month calendar
    "calendar" = "ncal -y";  # Year calendar
  };
  
  environment.systemPackages = with pkgs; [ bash-completion blesh ];
}
