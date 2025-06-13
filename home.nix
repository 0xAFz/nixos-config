{ config, pkgs, ... }:

let
  nix-vscode-extensions = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nix-vscode-extensions";
      ref = "refs/heads/master";
      rev = "00e11463876a04a77fb97ba50c015ab9e5bee90d";
    }
  );
in
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

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      github.github-vscode-theme
      pkief.material-icon-theme
      jnoortheen.nix-ide
    ];

    profiles.default.userSettings = {
        "files.autoSave" = "off";
        "[nix]"."editor.tabSize" = 2;
        "editor.tabSize" = 4;
        "editor.detectIndentation" = true;
        "editor.fontSize" = 24;
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.mouseWheelZoom" = true;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        "editor.guides.highlightActiveBracketPair" = true;
        "workbench.colorTheme" = "GitHub Dark";
        "workbench.startupEditor" = "none";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.editor.empty.hint" = "hidden";
      };
  };

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
    nixfmt-rfc-style
    # kubectl
  ];

  home.stateVersion = "25.05";
}
