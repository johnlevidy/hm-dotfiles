{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  home-manager.users.john = {
    imports = [
      ./nvim.nix
    ];
     
    home.sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "konsole";
    };
    home.stateVersion = "23.11";
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
