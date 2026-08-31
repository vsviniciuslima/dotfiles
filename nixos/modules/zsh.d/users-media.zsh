#!/usr/bin/env bash
# @file users-media
# @brief Media player control aliases and utilities for playerctl.
# @description
#     Provides convenient shell aliases and functions for controlling media playback
#     across multiple applications via playerctl. Includes playback controls, volume
#     management, and status/metadata queries.
#
#     Features:
#      * Playback control (play, pause, next, previous, stop)
#      * Volume adjustment and querying
#      * Track metadata and status display
#      * Per-application or last-played-media targeting
#
# @requires playerctl - Media player controller utility

# @description My super function.
# Not thread-safe.
#
# @example
#    echo "test: $(say-hello World)"
#
#
# @option -h | --help Display help.
# @option -v<value> | --value=<value> Set a value.
#
# @arg $1 string A value to print
#
# @stdout Output 'Hello $1'.
#   It hopes you say Hello back.
# @stderr Output 'Oups !' on error.
#   It did it again.
#
# @exitcode 0 If successful.
# @exitcode 1 If an empty string passed.
#
# @see validate()
# @see [shdoc](https://github.com/reconquest/shdoc).
say-hello() {
    if [[ ! "$1" ]]; then
        echo "Oups !" >&2
        return 1;
    fi

    echo "Hello $1"
}

# @description
#     Default playerctl target for media control commands.
#     Set to target a specific app (e.g. "--player=spotify"), or clear to control last played media.
# @default "--player=spotify"
PLAYER_ARG="--player=spotify"

# @description Playback control aliases.
#   play      - Start playback
#   pause     - Pause playback
#   pp        - Toggle play/pause
#   next      - Skip to next track
#   prev      - Skip to previous track
#   stop      - Stop playback
alias play="playerctl ${PLAYER_ARG} play"
alias pause="playerctl ${PLAYER_ARG} pause"
alias pp="playerctl ${PLAYER_ARG} play-pause"
alias next="playerctl ${PLAYER_ARG} next"
alias prev="playerctl ${PLAYER_ARG} previous"
alias stop="playerctl ${PLAYER_ARG} stop"

# @description Volume control aliases.
#   vol-up   - Increase volume by 5%
#   vol-down - Decrease volume by 5%
alias vol-up="playerctl ${PLAYER_ARG} volume 0.05+"
alias vol-down="playerctl ${PLAYER_ARG} volume 0.05-"

# @description Status and metadata display aliases.
#   play-status - Show current playback status
#   play-list   - List available media players
#   playing     - Display current artist and title
#   play-info   - Display detailed track information (title, artist, album)
alias play-status="playerctl ${PLAYER_ARG} status"
alias play-list="playerctl -l"
alias playing="playerctl ${PLAYER_ARG} metadata --format 'Playing: {{ artist }} - {{ title }}'"
alias play-info="playerctl ${PLAYER_ARG} metadata --format 'Now Playing:\nTitle:  {{ title }}\nArtist: {{ artist }}\nAlbum:  {{ album }}'"

# @description Query or set the current playback volume.
#   Without arguments, returns the current volume level (0.0-1.0).
#   With an argument, sets the volume to the specified level or adjustment.
#
# @example
#    vol              # Show current volume
#    vol 0.5          # Set volume to 50%
#    vol 0.1+         # Increase by 10%
#
# @arg $1 string Volume level (0.0-1.0) or adjustment (e.g., "0.05+", "0.1-")
#
# @stdout Current volume level if no arguments provided.
# @see play-status
# @see vol-up
# @see vol-down
vol() {
  if [ -z "$1" ]; then
    playerctl ${PLAYER_ARG} volume
  else
    playerctl ${PLAYER_ARG} volume "$1"
  fi
}
