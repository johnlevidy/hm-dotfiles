{ config, pkgs, ... }:
{
  home.pointerCursor = with pkgs; {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    x11.enable = true;
    gtk.enable = true;
  };
}
