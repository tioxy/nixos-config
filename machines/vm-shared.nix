{ config, pkgs, lib, ... }:

{
  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    settings = {
      trusted-users = [
        "@wheel"
      ];
      experimental-features = [
        "nix-command" "flakes"
      ];
      substituters = [
        "https://mitchellh-nixos-config.cachix.org"
      ];
      trusted-public-keys = [
        "mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="
      ];

      extra-substituters = [
        "https://cache.floxdev.com"
      ];
      extra-trusted-public-keys = [
        "_FLOX_PUBLIC_KEYS()"
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.consoleMode = "0";

  networking.hostName = "dev";

  time.timeZone = "America/Sao_Paulo";

  fonts = {
    fontconfig.enable = true;    

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
  };

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    layout = "us";
    xkbVariant = "altgr-intl";
    dpi = 220;

    displayManager = {
      defaultSession = "xfce+i3";
      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
      '';
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  # Audio
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraConfig = ''
      load-module module-combine-sink
      unload-module module-suspend-on-idle
    '';
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Virtualization settings
  virtualisation.docker.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable flatpak. We try not to use this (we prefer to use Nix!) but
  # some software its useful to use this and we also use it for dev tools.
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    cachix
    gnumake
    killall
    niv
    rxvt_unicode
    xclip

    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')

    gtkmm3 # copy/paste
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  networking.firewall.enable = false;

  system.stateVersion = "23.05";
}
