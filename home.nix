{
  config,
  pkgs,
  lib,
  ...
}:

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

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
      fonts = {
        names = [ "Noto Sans" ];
        size = 12.0;
      };
      bars = [ ];
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+q" = "kill";
          "Print" = ''
            exec grim -g "$(slurp)" - | wl-copy
          '';
        };
      input = {
        "*" = {
          xkb_model = "pc105";
          xkb_layout = "us,ir";
          xkb_variant = ",";
          xkb_options = "grp:alt_shift_toggle";
        };
      };
    };
    extraConfig = ''
      font pango:Noto Sans 12
      seat seat0 xcursor_theme Adwaita 24
      exec ${pkgs.waybar}/bin/waybar

      default_border pixel 2
      default_floating_border pixel 2
      hide_edge_borders none
      for_window [class=".*"] border pixel 2, titlebar false
      for_window [app_id=".*"] border pixel 2, titlebar false

      client.focused #6272a4 #6272a4 #f8f8f2 #bd93f9 #6272a4
      client.unfocused #282a36 #282a36 #f8f8f2 #44475a #282a36
      client.focused_inactive #44475a #44475a #f8f8f2 #6272a4 #44475a
    '';
  };

  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: Noto Sans;
        font-size: 14px;
        color: #ffffff;
        border-radius: 0;
      }
      window#waybar {
        background: #282a36;
        border-radius: 0;
      }
      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #f8f8f2;
        border: none;
        border-radius: 0;
      }
      #workspaces button:hover {
        background: #44475a;
        border-radius: 0;
      }
      #workspaces button.focused {
        background: #6272a4;
        border-radius: 0;
      }
      #clock {
        padding: 0 10px;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
        ];
        clock = {
          format = "{:%Y-%m-%d %H:%M}";
        };
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };
    iconTheme = {
      package = pkgs.dracula-icon-theme;
      name = "Dracula";
    };
    cursorTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  programs.git = {
    enable = true;
    userName = "AFz";
    userEmail = "0xafz@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "GruvboxDarkHard";
      title = "ghostty";
      font-size = 18;
      font-family = "JetBrainsMono Nerd Font";
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
    ghostty
    ripgrep
    python313
    python313Packages.pip
    obs-studio
    adwaita-icon-theme
    swaybg
    waypaper
    networkmanagerapplet
    dracula-theme
    dracula-icon-theme
    dconf
    telegram-desktop
    yt-dlp
    ffmpeg_6
    # kubectl
  ];

  home.stateVersion = "25.05";
}
