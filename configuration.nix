# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


let
  wallpaperd = pkgs.callPackage /home/sophia/wallpaperd/default.nix {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nubank/nixpkgs/archive/master.tar.gz;
    }))
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];


  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/dce4bf35-3a62-46cc-b57e-260d7b288956";
      preLVM = true;
      allowDiscards = true;
    };
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowBroken = true;
  nixpkgs.config.oraclejdk.accept_license = true;
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-10.24.1" 
    "electron-25.9.0"
  ];

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n.defaultLocale = "pt_BR.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  services.globalprotect = {
    enable = true;
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    arandr
    awscli
    chromium
    clojure
    clojure-lsp
    kubectl
    dmenu
    docker-compose
    dropbox-cli
    emacs
    firefox
    flameshot
    foliate
    gh
    ghc
    git
    gitAndTools.hub
    globalprotect-openconnect
    gmp
    gnupg
    google-cloud-sdk
    graphviz
    haskellPackages.xmobar
    haskellPackages.yeganesh
    i3lock
    (leiningen.override { jdk = pkgs.openjdk21; })
    libu2f-host
    logseq
    lsof
    gnumake
    google-chrome
    maven
    nix-prefetch-scripts
    nssTools
    ntfs3g
    openssl
    pcmanfm
    picom #replaces compton
    playerctl
    python3
    qdirstat
    racket
    ripgrep
    (sbt.override { jre = pkgs.jdk11; })
    slack
    solaar
    spotify
    stack
    stalonetray
    termite
    unrar
    unzip
    yubikey-manager
    yubikey-personalization-gui
    vagrant
    xmlstarlet # Required for aws cred refresh
    zoom-us
  ];

  fonts.packages = with pkgs; [
    google-fonts
    dejavu_fonts
  ];

  #Yubikey Configuration
  services.dbus.enable = true;
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];
  programs.ssh.startAgent = false;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # environment.shellInit = ''
  #   export GPG_TTY="$(tty)"
  #   gpg-connect-agent /bye
  #   export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  # '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 17500 ]; # For Dropbox
  networking.firewall.allowedUDPPorts = [ 17500 ]; # For Dropbox
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  ## Configure dropbox daemon
  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Xmonad
  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+xmonad";

    # required for XRDP remote desktop
    #displayManager.sddm.enable = true;
    #desktopManager.plasma5.enable = true;

    desktopManager.gnome.enable = true;
    desktopManager.xterm.enable = true;
    displayManager.gdm.enable = true;
    displayManager.sessionCommands = with pkgs; lib.mkAfter
      ''
      xsetroot -cursor_name left_ptr
      compton &
      '';
    autorun = true;
    layout = "br,us";
    libinput.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      enableConfiguredRecompile = true;
     };
   xkbOptions = "grp:shift_caps_toggle caps:swapescape";
  };

  #XRDP Support
  #services.xrdp.enable = true;
  #services.xrdp.defaultWindowManager = "startplasma-x11";
  #services.xrdp.openFirewall = true;

  # Network Manager
  programs.nm-applet.enable = true;

  # Enable Java.
  programs.java = {
    enable = true;
    package = pkgs.openjdk21;
  };

  programs.light.enable = true;

  virtualisation = {
    # Enable Docker.
    docker.enable = true;

    # Enable VirtualBox.
    virtualbox.host.enable = true;
    #virtualbox.host.enableExtensionPack = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sophia = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker" "vboxusers" "audio" "video" "plugdev"];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  services.sshd.enable = true;
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
