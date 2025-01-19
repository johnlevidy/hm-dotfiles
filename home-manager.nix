{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
  ];
  home-manager.users.john = {
    home.username = "john";
    home.homeDirectory = "/home/john";
    imports = [
      ./modules/nvim/nvim.nix
      ./modules/polybar/polybar.nix
      ./modules/rofi/rofi.nix
      ./modules/redshift/redshift.nix      
      ./modules/konsole/konsole.nix
    ];

    # Do not change
    home.stateVersion = "23.11";
    
    xsession.enable = true; 
    home.sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "konsole";
    };
    home.pointerCursor = with pkgs; {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
      x11.enable = true;
      gtk.enable = true;
    };
    gtk.enable = true;
    home.packages = with pkgs; [
      pkgs.redshift
      playerctl
      ripgrep
      feh # Image viewer.
      xfce.thunar
      jq
      fzf
      llvmPackages_latest.clang-unwrapped
      python311Packages.compiledb
      ccls
      lua-language-server
      lua
      brave
      spotify
      gcc11
      git
      tmux
      rofi
      discord
      htop
      firefox
      google-chrome
      konsole
      pavucontrol
    ];
    programs.dircolors = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
