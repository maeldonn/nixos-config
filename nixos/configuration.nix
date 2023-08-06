# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { mdonnart = import ./home.nix; };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = lib.mkForce true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 20;
  };

  # Bootloader settings
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # Hostname
  networking.hostName = "slimbook"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # security.rtkit.enable = true;
  # sound.enable = lib.mkForce false;
  # hardware.pulseaudio.enable = lib.mkForce false;
  # services.pipewire = {
  #   enable = true;
  #   alsa = {
  #     enable = true;
  #     support32Bit = true;
  #   };
  #   pulse.enable = true;
  #   wireplumber.enable = true;
  # };

  # Use zsh
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mdonnart = {
    isNormalUser = true;
    description = "mdonnart";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    exa
    jq
    zip
    unzip
    htop
    tmux
    neofetch
    lf
    ffmpeg
    stow
    fd

    ripgrep
    bat
    brightnessctl
    fzf
    pfetch
    gnumake
    gcc

    obsidian
    spotify
    firefox
    xfce.thunar
    evince
    virt-manager

    go
    nodejs_18
    rustup
    lazygit
    dbeaver
    insomnia
    neovim
    nil
    nix-fmt
    lua-language-server
    nodePackages.typescript-language-server

    # GTK
    gtk2
    gtk3
    gtk4

    # QT
    qt5.qtwayland
    qt6.qtwayland
    qt6.qmake
    libsForQt5.qt5.qtwayland
    qt5ct

    kitty
    wofi
    wlogout
    swaybg
    swaylock
    swayidle
    wl-clipboard
    mako
    wdisplays
    xdg-utils
    libnotify
    # grimblast # TODO: Mettre en place
    # pulseaudio
    pavucontrol
  ];

  # Thunar
  programs.thunar.enable = true;
  services.devmon.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true; # Thumbnail support for images
  services.gvfs.enable = true; # Mount, trash, and other functionalities

  # Hyprland
  programs.hyprland.enable = true;
  programs.waybar.enable = true;

  # Fonts
  fonts.fonts = with pkgs;
    [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  # Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05"; # Did you read the comment?
}
