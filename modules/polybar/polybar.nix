{ config, lib, pkgs, ... }:

let
  scripts = import ../scripts/scripts.nix { inherit pkgs; };
  polybarPackage = pkgs.polybar.override {
    i3Support = true;
    pulseSupport = true;
  };
  gruvbox = {
    dark0_hard = "#1d2021";
    dark0 = "#282828";
    dark0_soft = "#32302f";
    dark1 = "#3c3836";
    dark2 = "#504945";
    dark3 = "#665c54";
    dark4 = "#7c6f64";

    gray = "#928374";

    light0_hard = "#f9f5d7";
    light0 = "#fbf1c7";
    light0_soft = "#f2e5bc";
    light1 = "#ebdbb2";
    light2 = "#d5c4a1";
    light3 = "#bdae93";
    light4 = "#a89984";

    bright_red = "#fb4934";
    bright_green = "#b8bb26";
    bright_yellow = "#fabd2f";
    bright_blue = "#83a598";
    bright_purple = "#d3869b";
    bright_aqua = "#8ec07c";
    bright_orange = "#fe8019";
  };
  fonts = {
    font-0 = "SauceCodePro Nerd Font:size=26;0";
    font-1 = "Noto Color Emoji:scale=4;0";
    font-2 = "SauceCodePro Nerd Font:size=32;0";
  };
in
{
  services.polybar = {
    enable = true;
    package = polybarPackage;
    # We just null this because i3 has to start it. otherwise this doesn't wait long enough 
    # and the i3 socket isn't available when it starts
    script = "";
    config = {
      "bar/main" = fonts // {
        height = 70;
        radius = 0;
        fixed-center = true;
        bottom = true;

        background = gruvbox.dark0;
        foreground = gruvbox.light0;

        line-size = 2;
        line-color = gruvbox.bright_red;

        border-size = 0;

        padding-left = 0;
        padding-right = 0;

        module-margin-left = 1;
        module-margin-right = 1;

        modules-left = "i3";
        modules-center = "date";
        modules-right = "media cpu temperature memory wlan volume";
      };

      "module/media" = {
        type = "custom/script";
        exec = "${scripts.mediaControl} run";
        tail = true;
        format-underline = gruvbox.bright_purple;
        click-left = "${scripts.mediaControl} play_pause_last_player";
      };
      "module/wlan" = {
        type = "internal/network";
        interval = "3.0";
      
        interface-type = "wireless";
        format-connected = "<label-connected>";
        label-connected =
          "WLAN %signal%% ";
        format-connected-underline = gruvbox.bright_orange;
      };

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
      
        # Only show workspaces on the same output as the bar
        pin-workspaces = true;
      
        # Workspace label styling
        label-mode-padding = 2;
        label-mode-foreground = gruvbox.light0;
        label-mode-background = gruvbox.dark2;
      
        # Focused workspace style
        label-focused = "%index%";
        label-focused-background = gruvbox.dark1;
        label-focused-underline = gruvbox.bright_orange;
        label-focused-foreground = gruvbox.light4;
        label-focused-padding = 2;
      
        # Unfocused workspace style
        label-unfocused = "%index%";
        label-unfocused-background = gruvbox.dark0;
        label-unfocused-foreground = gruvbox.light4;
        label-unfocused-padding = 2;
      
        # Visible but not focused workspace style
        label-visible = "%index%";
        label-visible-background = gruvbox.bright_blue;
        label-visible-foreground = gruvbox.dark0;
        label-visible-padding = 2;
      
        # Workspace with an urgency hint
        label-urgent = "%index%";
        label-urgent-background = gruvbox.bright_red;
        label-urgent-foreground = gruvbox.light0;
        label-urgent-padding = 2;
      
        # Separator styling
        label-separator = "|";
        label-separator-foreground = gruvbox.gray;
        label-separator-padding = 2;
      };

      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = "0";
        warn-temperature = "60";
      
        format-underline = gruvbox.bright_blue;
        format = "TMP <label>";
        format-warn-underline = gruvbox.bright_red;
        format-warn = "TMP %label-warn%";
      
        label = "%temperature-c%";  
        label-warn = "%temperature-c%";  
        label-warn-foreground = gruvbox.bright_red;
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
      
        format-font = 3;
        date = "%Y-%m-%d";
        time = "%H:%M";
        format = "<label>";
        label = "%time% %date%";
        format-underline = gruvbox.bright_blue;
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 5;
        label = "CPU: %percentage%%";
        format = "<label>";
        format-underline = gruvbox.bright_green;
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 5;
        format = "<label>";
        label = "MEM: %percentage_used%%";
        format-underline = gruvbox.bright_yellow;
      };

      "module/volume" = {
        type = "internal/pulseaudio";
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage%%";
        ramp-volume-0 = "🔈";
        ramp-volume-1 = "🔉";
        ramp-volume-2 = "🔊";
        label-muted = "🔇 -- ";
        label-muted-foreground = "#66";
        format-muted-underline = gruvbox.bright_purple;
        format-volume-underline = gruvbox.bright_purple;
      };

      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };
  };
}
