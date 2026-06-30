# ═══════════════════════════════════════════════════════════════════════════════
# MODULES/HOME/GIT.NIX - Git Configuration
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    
    # Settings moved to settings.* in Home Manager 26.05+
    settings = {
      user = {
        name = "stefan-hacks";
        email = "stefan@example.com";  # Update with your actual email
      };
      
      core = {
        editor = "nvim";
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
      };
      
      init = {
        defaultBranch = "main";
      };
      
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      
      pull = {
        rebase = false;
      };
      
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      
      diff = {
        tool = "vimdiff";
        colorMoved = "zebra";
      };
      
      color = {
        ui = "auto";
      };
      
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        ca = "commit -a";
        cm = "commit -m";
        cam = "commit -am";
        amend = "commit --amend";
        unstage = "reset HEAD --";
        uncommit = "reset --soft HEAD^";
        last = "log -1 HEAD";
        lg = "log --oneline --graph --decorate --all";
        lga = "log --oneline --graph --decorate --all";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
        visual = "!gitk";
        d = "diff";
        dc = "diff --cached";
        ds = "diff --staged";
        aa = "add -A";
        fa = "fetch --all";
        pom = "push origin main";
        pog = "push origin gh";
        pu = "pull";
        pur = "pull --rebase";
        rb = "rebase";
        rbc = "rebase --continue";
        rba = "rebase --abort";
        rbs = "rebase --skip";
        cp = "cherry-pick";
        cpc = "cherry-pick --continue";
        cpa = "cherry-pick --abort";
        stp = "stash pop";
        sts = "stash save";
        std = "stash drop";
        stl = "stash list";
        sta = "stash apply";
      };
      
      credential = {
        helper = "cache --timeout=3600";
      };
      
      url = {
        "git@github.com:" = {
          insteadOf = "gh:";
        };
      };
    };
    
    # LFS
    lfs = {
      enable = true;
    };
  };
  
  # Delta moved to top-level in Home Manager 26.05+
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side line-numbers decorations";
      navigate = true;
      light = false;
    };
  };
  
  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
  
  programs.lazygit = {
    enable = true;
  };
}
