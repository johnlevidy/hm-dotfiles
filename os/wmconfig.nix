{ config, lib, pkgs, modulePath, ... }:
{
  imports =
  [
    ./../modules/i3/i3.nix
  ];
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    desktopManager = {
      xterm.enable = false;
    };
  };
}
