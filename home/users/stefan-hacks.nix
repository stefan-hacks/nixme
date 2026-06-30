{ config, pkgs, lib, ... }:

{
  home.username = "stefan-hacks";
  home.homeDirectory = "/home/stefan-hacks";
  home.stateVersion = "26.05";

  imports = [
    ../common
    ../terminal
    ../desktop
  ];

  home.packages = with pkgs; [
    bitwarden-cli
  ];

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        "ll" = "eza -la";
        "la" = "eza -a";
        "lt" = "eza --tree";
        "cat" = "bat";
        ".." = "cd ..";
        "..." = "cd ../..";
        "nixme" = "cd ~/.config/nixme";
        "nrs" = "sudo nixos-rebuild switch --flake ~/.config/nixme#ghost";
        "nrt" = "cd ~/.config/nixme && ./scripts/test-build.sh check";
      };
      initExtra = "eval \"$(${pkgs.starship}/bin/starship init bash)\"\neval \"$(${pkgs.zoxide}/bin/zoxide init bash)\"\neval \"$(${pkgs.direnv}/bin/direnv hook bash)\"";
    };

    git = {
      enable = true;
      userName = "Stefan Hacks";
      userEmail = "stefan@example.com";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        core.editor = "vim";
      };
    };

    ssh = {
      enable = true;
    };

    starship = {
      enable = true;
      settings = {
        format = "$all$character";
        character = {
          success_symbol = "[> ](green)";
          error_symbol = "[x ](red)";
        };
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services.gnome-keyring.enable = true;
}
