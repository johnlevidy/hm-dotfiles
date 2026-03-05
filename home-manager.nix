{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.users.john = {

    home.username = "john";
    home.homeDirectory = "/home/john";
    imports = [
      ./modules/nvim/nvim.nix
      ./modules/polybar/polybar.nix
      ./modules/rofi/rofi.nix
      ./modules/redshift/redshift.nix      
      ./modules/konsole/konsole.nix
      ./modules/picom/picom.nix
      ./modules/cursor/cursor.nix
      ./modules/starship/starship.nix
    ];

    # Do not change
    home.stateVersion = "23.11";
    xsession.enable = true; 
    gtk.enable = true;
    programs.bash = {
      enable = true;
      shellAliases = {
        gl = "git log --all --graph --decorate --oneline";
        # Simulates unplugging and replugging mouse, driver gets stuck often.
        bouncemouse = "sudo bash -c 'dev=5-4.2; echo 0 > /sys/bus/usb/devices/$dev/authorized; sleep 1; echo 1 > /sys/bus/usb/devices/$dev/authorized'";
      };
    };
    programs.dircolors = {
      enable = true;
      enableBashIntegration = true;
    };
    home.sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "brave";
      TERMINAL = "konsole";
    };
    
    home.packages = with pkgs; [
      pkgs.redshift
      playerctl
      ripgrep
      feh # Image viewer.
      xfce.thunar
      jq
      fzf
      llvmPackages_latest.clang-unwrapped
      compiledb
      ccls
      lua-language-server
      pyright
      lua
      (brave.override {
      commandLineArgs = [
      "--disable-gpu-process-crash-limit"
      "--ignore-gpu-blocklist"
      ];
      })
      spotify
      gcc11
      git
      tmux
      rofi
      discord
      htop
      libsForQt5.konsole
      pavucontrol
      hsetroot
      picom
      xss-lock
      rxvt-unicode-unwrapped
      scrot
      xclip
      cgdb
      starship
      bolt-launcher
      piper
      simplescreenrecorder
      vlc
    ];
  };
}
