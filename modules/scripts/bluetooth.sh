bluetooth_status() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        if bluetoothctl devices Connected | grep -q '^Device'; then
            # Powered and connected
            echo "%{F#2193ff}"
        else
            # Powered but no connection
            echo "%{F#ff5555}"
        fi
    else
        # Not powered
        echo "%{F#66ffffff}"
    fi
}

# Optionally, provide a way to call functions based on the script input
# TODO get rid of all these repeated suffixes
case "$1" in
    "status") bluetooth_status ;;
    *) echo "Invalid option"; exit 1;;
esac
