{ config, pkgs, options, ... }:

{
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
}
