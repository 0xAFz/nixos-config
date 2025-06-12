{ config, pkgs, ... }:

{
  home.username = "cloud";
  home.homeDirectory = "/home/cloud";

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
