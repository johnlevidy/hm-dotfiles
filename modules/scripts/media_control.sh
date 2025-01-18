#
# There are some pathological cases not handled here but it deals with 
# most of the annoying corner cases.
#
# playerctl follow shows only the most recent interaction, which might not be 
# what you want if you have two sources playing and pause one.
#

# Define the path to the player name file
PLAYER_NAME_FILE="/tmp/player_name"

# Function to listen to player metadata and handle both display and control functionalities
run() {
    # Listen to the player status and update the output along with storing the player name
    playerctl -F metadata -f '{{playerName}} {{status}} {{artist}} - {{title}}' | \
    while IFS= read -r line; do
        # Extract the playerName and the rest of the metadata
        playerName=$(echo "$line" | awk '{print $1}')
        status_artist_title=$(echo "$line" | cut -d' ' -f2-)
        status_artist_title=$(echo "$status_artist_title" | sed 's/VEVO//; s/ - Topic//')
        status_artist_title=$(echo "$status_artist_title" | sed 's/(Official Video)//; s/Official Video//')
        status_artist_title=$(echo "$status_artist_title" | \
            sed -e 's/^Playing /♪ /' \
                -e 's/^Paused /⏸ /' \
                -e 's/^Stopped /⏹ /' )

        # Write the playerName to a file
        echo "$playerName" > "$PLAYER_NAME_FILE"

        # Print the status, artist, and title
        echo "$status_artist_title"
    done
}

# Function to toggle play-pause based on the last known player name
command_last_player() {
    if [[ -f "$PLAYER_NAME_FILE" ]]; then
        # Read player name from the file
        playerName=$(cat "$PLAYER_NAME_FILE")
        # Execute play-pause command for the player
        playerctl --player="$playerName" $1
    else
        echo "No player name available"
    fi
}

# Optionally, provide a way to call functions based on the script input
# TODO get rid of all these repeated suffixes
case "$1" in
    "run") run;;
    "play_pause_last_player") command_last_player play-pause;;
    "next_last_player") command_last_player next;;
    "previous_last_player") command_last_player previous;;
    *) echo "Invalid option"; exit 1;;
esac
