# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  share = import ../share/share.nix { inherit pkgs; };
  secrets = import /etc/nixos/secrets.nix;
in
{
  # TODO pull out themes
  environment.systemPackages = with pkgs; [
    dconf # Required for gtk to be enabled, which is required to get cursor configs working
    gruvbox-gtk-theme
    home-manager
    bazecor
  ];
  imports =
    [ # Include the results of the hardware scan.
      ./unfree.nix
      ./hardware-configuration.nix
      ./../home-manager.nix
      ./wmconfig.nix
    ];
  boot.initrd.luks.devices = {
    root = {
      name = "root";
      device = "/dev/disk/by-uuid/c6bd9976-f376-4f2d-ac68-dd4d3d51a1f8";
      preLVM = true;
    };
  };

  programs.dconf.enable = true;
  # TODO: Not sure if this is necessary...
  programs.nix-ld.enable = true;

  # Use the GRUB 2 boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = true;
  networking.networkmanager.enable = false;
  networking.wireless.networks = secrets.wifi;

  # Set your time zone.
  time.timeZone = "America/New_York";

  fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.wlp5s0.useDHCP = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
  };
  # services.blueman-applet.enable = true;
  services.blueman = {
    enable = true;
  };
  services.pipewire = {
    enable = true;
    alsa.support32Bit = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
  "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
  };
};

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    
    displayManager.lightdm.greeters.gtk = {
      enable = true;
      theme.name = "Gruvbox-Dark";
      theme.package = pkgs.gruvbox-gtk-theme;
      indicators = [ "~clock" ];
      cursorTheme.name = "phinger-cursors-light";
      cursorTheme.package = pkgs.phinger-cursors;
      extraConfig = ''
        background = ${share.desktopBackground}
        font-name = SauceCodePro 8 
        cursor-theme-size = 32 
      '';
    };
    # Weird waking issues so just keep the screen on at all times
    displayManager.sessionCommands = ''
      xset -dpms s 600 600;
      xset s noblank;
      ${pkgs.hsetroot}/bin/hsetroot -fill ${share.desktopBackground};
    '';
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --mode 7680x2160 --rate 60
      ${pkgs.xorg.xrandr}/bin/xrandr --dpi 140
    '';
  };

  # power management causes weirdness getting out of hibernation so we just disable
  powerManagement.enable = false;
  services.tlp.enable = false;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  systemd.user.services.pipewire.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "1s";
  };

  users.users."${secrets.user0}" = secrets.user0config;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}

