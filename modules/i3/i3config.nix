{config, pkgs, ...}:
let 
  share = import ../../share/share.nix { inherit pkgs; };
  scripts = import ../scripts/scripts.nix { inherit pkgs; };
  lockScript = pkgs.writeTextFile {
    name = "lockScreen.sh";
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      systemctl stop --user picom.service
      xrandr --output HDMI-0 --mode 3840x1080 --rate 60

      i3lock-color \
        -i "${share.background}" \
        --date-str="%A, %B %d, %Y" \
        --time-str="%H:%M:%S" \
        --clock \
        --time-size=40 \
        --date-size=22 \
        --greeter-align=-20 \
        --date-color=ffffff \
        --time-color=ffffff \
        -e \
        --insidever-color=ebdbb2ff \
        --ringver-color=fe8019ff \
        --inside-color=076678ff \
        --ring-color=458588ff \
        --line-color=076678ff \
        --keyhl-color=fb4934ff \
        --bshl-color=d3869bff \
        --nofork \
        --composite

      xrandr --output HDMI-0 --mode 7680x2160 --rate 60
      systemctl start --user picom.service
    '';
  };
  i3config = ''
# i3 config file (v4)
#
# Please see https://i3wm.org/docs/userguide.html for a complete reference!
#
# This config file uses keycodes (bindsym) and was written for the QWERTY
# layout.
#
# To get a config file with the same key positions, but for your current
# layout, use the i3-config-wizard
#

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:DejaVu Sans 16
for_window [class=".*"] title_format "  %title"

# Start XDG autostart .desktop files using dex. See also
# https://wiki.archlinux.org/index.php/XDG_Autostart
exec --no-startup-id dex --autostart --environment i3

exec --no-startup-id xss-lock --transfer-sleep-lock -- "${lockScript}"

# Start polybar here because it starts up too fast and the i3 socket isn't ready
exec --no-startup-id "polybar >~/.polybarlogs 2>&1"

# NetworkManager is the most popular way to manage wireless networks on Linux,
# and nm-applet is a desktop environment-independent system tray GUI for it.
exec --no-startup-id nm-applet

# Use pactl to adjust volume in PulseAudio.
set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0"
bindsym XF86AudioLowerVolume exec --no-startup-id "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1.0"
bindsym XF86AudioMute exec --no-startup-id "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

exec --no-startup-id "${scripts.mediaControl} run"
bindsym XF86AudioPlay exec --no-startup-id "${scripts.mediaControl} play_pause_last_player"
bindsym XF86AudioNext exec --no-startup-id "${scripts.mediaControl} next_last_player"
bindsym XF86AudioPrev exec --no-startup-id "${scripts.mediaControl} previous_last_player"

# use these keys for focus, movement, and resize directions when reaching for
# the arrows is not convenient
set $up k
set $down j
set $left h
set $right l

# use Mouse+Mod1 to drag floating windows to their wanted position
floating_modifier Mod1

# move tiling windows via drag & drop by left-clicking into the title bar,
# or left-clicking anywhere into the window while holding the floating modifier.
tiling_drag modifier titlebar

# start a terminal
bindsym Mod1+Return exec i3-sensible-terminal

# kill focused window
bindsym Mod1+Shift+q kill

# A more modern dmenu replacement is rofi:
bindsym Mod1+d exec "rofi -modi drun -show drun"
bindsym Mod1+w exec "rofi -modi window -show window"

# change focus
bindsym Mod1+$left focus left
bindsym Mod1+$down focus down
bindsym Mod1+$up focus up
bindsym Mod1+$right focus right

# alternatively, you can use the cursor keys:
bindsym Mod1+Left focus left
bindsym Mod1+Down focus down
bindsym Mod1+Up focus up
bindsym Mod1+Right focus right

# move focused window
bindsym Mod1+Shift+$left move left
bindsym Mod1+Shift+$down move down
bindsym Mod1+Shift+$up move up
bindsym Mod1+Shift+$right move right

# alternatively, you can use the cursor keys:
bindsym Mod1+Shift+Left move left
bindsym Mod1+Shift+Down move down
bindsym Mod1+Shift+Up move up
bindsym Mod1+Shift+Right move right

# split in horizontal orientation
bindsym Mod1+x split h 

# split in vertical orientation
bindsym Mod1+v split v
# enter fullscreen mode for the focused container
bindsym Mod1+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym Mod1+s layout stacking
# bindsym Mod1+w layout tabbed
bindsym Mod1+e layout toggle split

# toggle tiling / floating
bindsym Mod1+Shift+space floating toggle

# Set inner and outer gaps
gaps inner 4
gaps outer 4
# centers first window, bit of a hack
# 1920 is such that the window is sized to a half screen
gaps horizontal 1600
smart_gaps inverse_outer

# change focus between tiling / floating windows
bindsym Mod1+space focus mode_toggle

# focus the parent container
bindsym Mod1+a focus parent

# focus the child container
#bindsym Mod1+d focus child

# move the currently focused window to the scratchpad
bindsym Mod1+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym Mod1+minus scratchpad show

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym Mod1+1 workspace number $ws1
bindsym Mod1+2 workspace number $ws2
bindsym Mod1+3 workspace number $ws3
bindsym Mod1+4 workspace number $ws4
bindsym Mod1+5 workspace number $ws5
bindsym Mod1+6 workspace number $ws6
bindsym Mod1+7 workspace number $ws7
bindsym Mod1+8 workspace number $ws8
bindsym Mod1+9 workspace number $ws9
bindsym Mod1+0 workspace number $ws10

# move focused container to workspace
bindsym Mod1+Shift+1 move container to workspace number $ws1
bindsym Mod1+Shift+2 move container to workspace number $ws2
bindsym Mod1+Shift+3 move container to workspace number $ws3
bindsym Mod1+Shift+4 move container to workspace number $ws4
bindsym Mod1+Shift+5 move container to workspace number $ws5
bindsym Mod1+Shift+6 move container to workspace number $ws6
bindsym Mod1+Shift+7 move container to workspace number $ws7
bindsym Mod1+Shift+8 move container to workspace number $ws8
bindsym Mod1+Shift+9 move container to workspace number $ws9
bindsym Mod1+Shift+0 move container to workspace number $ws10

# reload the configuration file
bindsym Mod1+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym Mod1+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym Mod1+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym $left       resize shrink width 10 px or 10 ppt
        bindsym $down       resize grow height 10 px or 10 ppt
        bindsym $up         resize shrink height 10 px or 10 ppt
        bindsym $right      resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left        resize shrink width 10 px or 10 ppt
        bindsym Down        resize grow height 10 px or 10 ppt
        bindsym Up          resize shrink height 10 px or 10 ppt
        bindsym Right       resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or Mod1+r
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym Mod1+r mode "default"
}

bindsym Mod1+r mode "resize"

#######################################################################
# automatically start i3-config-wizard to offer the user to create a
# keysym-based config which used their favorite modifier (alt or windows)
#
# i3-config-wizard will not launch if there already is a config file
# in ~/.config/i3/config (or $XDG_CONFIG_HOME/i3/config if set) or
# ~/.i3/config.
#
# Please remove the following exec line:
#######################################################################
exec i3-config-wizard
focus_follows_mouse no
# class                 border    background text    indicator child_border
client.focused          #282828   #d79921    #3c3836 #fabd2f   #282828
client.focused_inactive #3c3836   #928374    #ebdbb2 #665c54   #3c3836
client.unfocused        #32302f   #7c6f64    #fbf1c7 #504945   #32302f
client.urgent           #1d2021   #cc241d    #282828 #fb4934   #1d2021
client.placeholder      #3c3836   #a89984    #ebdbb2 #7c6f64   #3c3836

client.background       #ebdbb2
'';
in
{
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      rofi
      i3status
      i3lock-color
      i3blocks
    ];
    configFile = pkgs.writeText "i3-config" i3config;
  };
}
