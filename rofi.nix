{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    font = "Droid Sans Mono 28";
    theme = "gruvbox-dark-soft";
  };
}
