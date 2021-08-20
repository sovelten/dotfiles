# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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
  nixpkgs.config.oraclejdk.accept_license = true;

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n.defaultLocale = "pt_BR.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];
  environment.systemPackages = with pkgs; [
    arandr
    apacheKafka
    awscli
    clojure
    compton
    dmenu
    docker-compose
    emacs
    ghc
    git
    gitAndTools.hub
    gmp
    gnupg
    google-cloud-sdk
    graphviz
    haskellPackages.yeganesh
    haskellPackages.xmobar
    i3lock
    kubectl
    leiningen
    /*
    (leiningen.overrideAttrs(oldAttrs: rec {
      pname = "leiningen";
      version = "2.8.3";
      name = "${pname}-${version}";

      src = fetchurl {
        url = "https://raw.github.com/technomancy/leiningen/${version}/bin/lein-pkg";
        sha256 = "1jbrm4vdvwskbi9sxvn6i7h2ih9c3nfld63nx58nblghvlcb9vwx";
      };

      jarsrc = fetchurl {
        url = "https://github.com/technomancy/leiningen/releases/download/${version}/${name}-standalone.zip";
        sha256 = "07kb7d84llp24l959gndnfmislnnvgpsxghmgfdy8chy7g4sy2kz";
      };
    }))
    */
    libu2f-host
    idris
    jupyter
    maven
    nssTools
    nodejs-10_x
    nodePackages.tern
    pcmanfm
    playerctl
    python3
    solaar
    spotify
    stack
    stalonetray
    termite
    texlive.combined.scheme-full
    texstudio
    unrar
    unzip
    yubikey-manager
    yubikey-personalization-gui
    vagrant
    zoom-us
  ] ++ nubank.all-tools;

  fonts.fonts = with pkgs; [
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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
    displayManager.defaultSession = "none+xmonad";
    #desktopManager.plasma5.enable = true;
    desktopManager.gnome.enable = true;
    desktopManager.xterm.enable = true;
    displayManager.gdm.enable = true;
    displayManager.sessionCommands = with pkgs; lib.mkAfter
      ''
      xsetroot -cursor_name left_ptr
      compton &
      '';
    enable = true;
    autorun = true;
    layout = "br,us";
    libinput.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
      ];
    };
   xkbOptions = "grp:shift_caps_toggle caps:swapescape";
  };

  # Network Manager
  programs.nm-applet.enable = true;

  # Enable Java.
  programs.java = {
    enable = true;
    package = pkgs.openjdk11;
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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}
