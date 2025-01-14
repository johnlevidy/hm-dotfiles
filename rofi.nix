# TODO this has to do the same thing as the i3 config, not keep a separate file
{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    font = "Droid Sans Mono 24";
    theme = "/home/john/hm-dotfiles/rofi_config.rasi";
    # Using extraConfig to append settings
    extraConfig = {
      drun-display-format = "{icon} {name}";
      show-icons = true;
      yoffset = 200;
    };
  }; 
}
