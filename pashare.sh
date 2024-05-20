#!/bin/bash

# pashare.sh - An easy to use tool for sharing audio devices over the network.
# https://github.com/GrubRescue9827/pashare/
#
# Adapted from:
# https://superuser.com/questions/605445/how-to-stream-my-gnu-linux-audio-output-to-android-devices-over-wi-fi

show_help() {
    echo "Usage: $0 [OPTION]..."
    echo "Share a specified Pipewire/Pulseaudio device over TCP/IP."
    echo "  -s, --source        Name of the pipewire audio source to use."
    echo "  -g, --guess-default Attempt to guess the default source and exit."
    echo "  -l, --list-sources  List all pipewire audio sources connected to the system."
    echo "  -k, --kill          Unload the existing module and exit."
    echo "  -p  --port          Port to use. Default: [8000]"
    echo "  -h, --help          Display this help and exit."
    echo
    echo "If the default source is not automatically detected correctly, use the -l flag and manually specify the source using -s"
}

list_sources() {
    pactl list short sources
}

guess_default() {
    pactl info | grep 'Default Sink' | cut -f3 -d' '
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -s|--source) SOURCE="$2"; shift ;;
        -p|--port) PORT="$2"; shift ;;
        -g|--guess-default) echo "Attempting to guess the default output..."; guess_default; exit 0 ;;
        -l|--list-sources) list_sources; exit 0 ;;
        -k|--kill)
            MODULE_ID=$(pactl list | grep tcp -B1 | grep Module | sed 's/[^0-9]//g')
            pactl unload-module "$MODULE_ID"
            exit 0
            ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown option: $1" >&2; show_help; exit 1 ;;
    esac
    shift
done

# If no source specified, attempt to automatically detect default
if [[ -z "$SOURCE" ]]; then
    echo "Warning: No source specified. Attempting to guess..."
    SOURCE=$(guess_default)
fi

# Default port
if [[ -z "$PORT" ]]; then
    PORT=8000
fi

# Unload existing TCP module if loaded
MODULE_ID=$(pactl list | grep tcp -B1 | grep Module | sed 's/[^0-9]//g')
if [[ ! -z "$MODULE_ID" ]]; then
    echo "Warning: TCP module is already running, attempting to kill!"
    pactl unload-module "$MODULE_ID"
fi

# Actually do the thing
echo "Using source: $SOURCE"
echo "Using port: $PORT"
pactl load-module module-simple-protocol-tcp rate=48000 format=s16le channels=2 source="$SOURCE" record=true port=$PORT

# Check if it worked
if nc -zv localhost $PORT &>/dev/null; then
    echo "Success! Now listening on TCP/$PORT"
else
    echo "Error: Failed to open port."
fi


