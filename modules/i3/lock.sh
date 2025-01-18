# We have to turn off a bunch of stuff that doesn't play nice with lock screens it's a bit insane
systemctl stop --user picom.service
# This makes it more likely the GPU can complete link training with the monitor
xrandr --output HDMI-0 --mode 3840x1080 --rate 60
i3lock-color -i /home/john/hm-dotfiles/rosette_nebula.jpg --date-str="%A, %B %d, %Y" --time-str="%H:%M:%S" --clock --time-size=40 --date-size=22 --greeter-align=-20 --date-color=ffffff --time-color=ffffff -e --insidever-color=ebdbb2ff     --ringver-color=fe8019ff --inside-color=076678ff --ring-color=458588ff --line-color=076678ff --keyhl-color=fb4934ff --bshl-color=d3869bff -e --nofork --composite
xrandr --output HDMI-0 --mode 7680x2160 --rate 60
systemctl start --user picom.service
