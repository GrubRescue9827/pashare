# PAShare - Pulse/Pipewire Audio Share
PAShare is an easy to use BASH script to make using the `simple-protocol-tcp` functionality of PulseAudio/PipeWire easy, because I got tired of trying to debug its issues. I use this so I can use my wired headphones as if they were wireless- by keeping my phone in my pocket.

## Features:
* Attempt to auto-detect default audio output if `-s` or `--source` is not specified.
* Allows manually specifying an output/input to stream (Yes, you can stream microphone audio!)

## Dependencies:
Debian/Ubuntu: `sudo apt install -y bash netcat-openbsd pulseaudio-utils`

## Usage
### Minimal setup
1. Download pashare.sh into any user-accessible folder. [Default: `~/Documents/scripts/pashare/pashare.sh`]
2. Open a terminal in this folder, make the file executable `chmod +x ./pashare.sh`
3. Simply type `./pashare.sh` to start! Once done, type `./pashare.sh -k` to kill the server.
4. For more info, use the help dialogue `./pashare.sh --help`

### Optional: Add desktop icons
1. Download `startpashare.desktop` and `stoppashare.desktop` to your desktop
2. Open the file with any text editor of your choice
3. If your install is NOT in the default location, change `~/Documents/scripts/pashare/pashare.sh` under `exec=` to the location of the script.
4. If you don't want the terminal to stay open after clicking the pashare icon, remove ` ;  read -p '\\''Press any key to continue...'\\'''` from the `exec=` line. Be warned that this means you won't be able to read any error messages that appear.

### Using an Android device as a client


### Troubleshooting
Unfortunately pashare is not that smart. Sometimes it does not detect the default audio device correctly. To mitigate this, use the `-g` or `--guess-default` and `-l` or `--list-sources` command line flags to see available sources, then use the `-s` or `--source` flag to manually specify the correct audio device. I find that oftentimes the addition or removal of `.monitor` from the guessed source fixes the issue, like so:

```bash
user@ubuntu:~/Documents/scripts/pashare$ ./pashare.sh -g
Attempting to guess the default output...
alsa_output.pci-0000_00_1b.0.analog-stereo.2.monitor
user@ubuntu:~/Documents/scripts/pashare$ ./pashare.sh -l
455     alsa_output.pci-0000_00_1b.0.analog-stereo.2.monitor    PipeWire s32le 2ch 48000Hz        IDLE
user@ubuntu:~/Documents/scripts/pashare$ ./pashare.sh -s "alsa_output.pci-0000_00_1b.0.analog-stereo.2"
```
If pashare is correctly guessing the device, make sure your firewall isn't blocking port `8000`, and that no other services are currently listening on that port. If needed, you can specify an alternate port for pashare to use with the `-p` or `--port` command line flag. Note that ports below 1023 require root to open, and thus aren't recommended.

## Hardware requirements
As tested on Ubuntu 24.04 @ 48000hz, Stereo, minimum latency client settings. Intel Core I5 520M
* Host CPU Impact: `Unnoticable.`
* Network: `1.6 Megabit/Second Upload`
* Latency: Tested with up to 10ms w/ 30ms mdev (WiFi on both server and client)

Experience was analogous to good bluetooth, with added range.

## KNOWN ISSUES:
⚠️ `simple-protocol-tcp` sends audio entirely UNENCRYPTED! This is only intended for streaming non-sensitive audio (such as music) over private networks.

This is potentially fixable with the Multicast/RTP module, but I can't get it to work, and I'm not sure it supports Android clients. If you can get it to work, feel free to submit a pull request!
