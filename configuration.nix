{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sdb";
  boot.loader.grub.useOSProber = true;

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
    "kernel.watchdog" = 0;
    "kernel.nmi_watchdog" = 0;
    "kernel.printk" = "0 4 1 3";
    "kernel.randomize_va_space" = 2;
    "kernel.perf_event_max_sample_rate" = 100;
    "kernel.core_pattern" = "/dev/null";
    "kernel.timer_migration" = 0;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; 
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tehran";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bkp";
  home-manager.users.cloud = import ./home.nix;

  users.users.cloud = {
    isNormalUser = true;
    description = "cloud";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

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
  docker
  google-chrome
  ];

  system.stateVersion = "25.05"; 
}
