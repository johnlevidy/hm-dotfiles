{ config, pkgs, ... }:
{
  programs.i3status.enable = true;
  # gruvbox-y
  programs.i3status.general = {
    colors = true;
    color_good = "#d4be98";
    color_degraded = "#d7ae00";
    color_bad = "#fa886a";
    interval = 1;
  };

  programs.i3status.enableDefault = true;
  programs.i3status.modules."disk /".enable = true;
  programs.i3status.modules.ipv6.enable = false;
  programs.i3status.modules."ethernet _first_".enable = false;
  programs.i3status.modules."battery all".enable = false;
  programs.i3status.modules."tztime local".enable = true;
  programs.i3status.modules."tztime local".position = 1;
  programs.i3status.modules.memory.enable = true;
  programs.i3status.modules.memory.settings.format = "%used/%available";
  programs.i3status.modules."wireless _first_".settings.format_up = "📡(%essid:%quality)";
  programs.i3status.modules.cpu_usage = {
    position = 3;
    settings = {
      format = "🔥 %usage";
    };
  };
  programs.i3status.modules."cpu_temperature 0" = {
    position = 4;
    settings = {
      format = "%degrees °C";
    };
  };
  programs.i3status.modules.load.enable = false;
  programs.i3status.modules."volume master" = {
    position = 2;
    settings = {
      format = "♪ %volume";
      format_muted = "♪ muted (%volume)";
      device = "pulse:alsa_output.pci-0000_0a_00.3.iec958-stereo";
    };
  };
  programs.i3status.modules."disk /" = {
    position = 10;
      settings = {
        # poor man's center justification
        format = "💽 %used                                                                              ";
      };        
  }; 

}
