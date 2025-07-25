{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  imports = [
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-ADATA_SU650_2M232L2GAEYC";
  boot.loader.grub.useOSProber = false;

  # boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.kernelPackages = pkgs.linuxPackages_6_15;

  boot.kernelParams = [
    "quiet"
    "splash"
    "nohz=off"
    "audit=0"
    "loglevel=0"
    "nokprobes"
    "numa=off"
    "mitigations=off"
    "nohalt"
    "nopti"
    "mce=ignore_ce"
    "selinux=0"
    "apparmor=0"
    "schedstats=disable"
    "transparent_hugepage=never"
    "intel_pstate=disable"
  ];

  boot.kernel.sysctl = {
    "vm.stat_interval" = 120;
    "vm.swappiness" = 0;
    "vm.dirty_ratio" = 2;
    "vm.dirty_background_ratio" = 1;
    "vm.dirty_expire_centisecs" = 300;
    "vm.dirty_writeback_centisecs" = 100;
    "vm.compaction_proactiveness" = 5;
    "vm.vfs_cache_pressure" = 200;
    "kernel.watchdog" = 1;
    "kernel.nmi_watchdog" = 0;
    "kernel.printk" = "0 4 1 3";
    "kernel.randomize_va_space" = 2;
    "kernel.perf_event_max_sample_rate" = 100;
    "kernel.core_pattern" = "/dev/null";
    "kernel.timer_migration" = 0;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ mesa ];
  };

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.videoDrivers = [ "radeon" ];

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   konsole
  # ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      # log-driver = "journald";
      # registry-mirrors = [ "https://mirror.gcr.io" ];
      # storage-driver = "overlay2";
    };
  };

  networking.hostName = "nixos";
  networking.nameservers = [ "178.22.122.100" "185.51.200.2" "10.202.10.10" "10.202.10.11" "1.1.1.1" "8.8.8.8" ];
  networking.networkmanager.insertNameservers = [ "178.22.122.100" "185.51.200.2" "10.202.10.10" "10.202.10.11" "1.1.1.1" "8.8.8.8" ];
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bkp";
  home-manager.users.cloud = import ./home.nix;

  users.users.cloud = {
    isNormalUser = true;
    description = "cloud";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    vim
    git
    nerd-fonts.jetbrains-mono
    zip
    unzip
    curl
    jq
    wget
    htop
    google-chrome
    xkeyboard_config
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
    vazir-fonts
    dejavu_fonts
    liberation_ttf
    mesa
    libglvnd
    libdrm
    mesa-demos
    libvdpau
    bat
    fastfetch
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
    dconf
    yt-dlp
    ffmpeg_6
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      vazir-fonts
      dejavu_fonts
      liberation_ttf
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Vazir Matn"
          "Source Han Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "Vazir Matn"
          "Source Han Sans"
        ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
      hinting = {
        enable = true;
        style = "full";
      };
      antialias = true;
      subpixel = {
        rgba = "rgb";
      };
    };
  };

  system.autoUpgrade.enable = false;
  system.autoUpgrade.dates = "monthly";

  nix.optimise.automatic = true;
  nix.gc.automatic = false;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 365d";
  nix.settings.auto-optimise-store = true;

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "25.05";
}
