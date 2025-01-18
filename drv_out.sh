# Check if a .drv file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path-to-derivation.drv>"
    exit 1
fi

DRV_FILE=$1

# Check if the file exists
if [ ! -f "$DRV_FILE" ]; then
    echo "Error: File '$DRV_FILE' not found."
    exit 1
fi

# Extract the 'out' field from the derivation
nix --extra-experimental-features nix-command derivation show "$DRV_FILE" | jq '.[].env.out'
