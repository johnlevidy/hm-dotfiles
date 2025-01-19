{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;
    package = pkgs.picom;
    backend = "xrender";
    vSync = true;
    fade = true;
    fadeDelta = 5;
    inactiveOpacity = .88; 
  };
}
