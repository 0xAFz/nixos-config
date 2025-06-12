{ config, pkgs, ... }:

{
  home.username = "cloud";
  home.homeDirectory = "/home/cloud";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "garyblessington";
      plugins = [ "git" ];
    };

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
  };

  programs.git = {
    enable = true;
    userName = "AFz";
    userEmail = "0xafz@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    bat
    fastfetch
    terraform
    ansible
    go
    rustup
    vscode
    neovim
    nodejs_24
    # kubectl
  ];
}
