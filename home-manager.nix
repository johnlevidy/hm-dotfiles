{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
  ];
  home-manager.users.john = {
    home.username = "john";
    home.homeDirectory = "/home/john";
    imports = [
      ./nvim.nix
      ./polybar.nix
      # ./i3status.nix
      ./rofi.nix
    ];

    home.stateVersion = "23.11";
    home.sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "konsole";
    };
    home.packages = with pkgs; [
      ripgrep
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
    ];
    programs.dircolors = {
      enable = true;
      enableBashIntegration = true;
    };
    
    xsession = {
      enable = true;
    }; 
  };
}
