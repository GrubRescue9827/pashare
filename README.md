# PAShare - Pulse/Pipewire Audio Share
PAShare is an easy to use BASH script to make using the `simple-protocol-tcp` functionality of PulseAudio/PipeWire easy, because I got tired of trying to debug its issues. I use this so I can use my wired headphones as if they were wireless- by keeping my phone in my pocket.

## Features:
* Attempt to auto-detect default audio output if `-s` or `--source` is not specified.
* Allows manually specifying an output/input to stream (Yes, you can stream microphone audio!)

## Dependencies:
Debian/Ubuntu: `sudo apt install -y bash netcat-openbsd pulseaudio-utils`

## Hardware requirements
As tested on Ubuntu 24.04 @ 48000hz, Stereo, minimum latency client settings. Intel Core I5 520M
* Host CPU Impact: `Unnoticable.`
* Network: `1.6 Megabit/Second Upload`
* Latency: Tested with up to 10ms w/ 30ms mdev (WiFi on both server and client)

Experience was analogous to good bluetooth, with added range.

## KNOWN ISSUES:
⚠️ `simple-protocol-tcp` sends audio entirely UNENCRYPTED! This is only intended for streaming non-sensitive audio (such as music) over private networks.

This is potentially fixable with the Multicast/RTP module, but I can't get it to work, and I'm not sure it supports Android clients. If you can get it to work, feel free to submit a pull request!
