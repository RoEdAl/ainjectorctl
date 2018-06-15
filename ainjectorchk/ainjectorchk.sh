#!/bin/bash -e

echoerr() {
    echo "$@" 1>&2
}

readonly ID_FILE=/sys/devices/platform/soc/soc:sound/sound/card0/id

is_audioinjector_installed() {

    if [[ ! -s $ID_FILE ]]; then
        echoerr Sound card not found.
        return 2
    fi

    local SOUND_CARD_ID=$(cat $ID_FILE)

    if [[ $SOUND_CARD_ID -ne audioinjectorpi ]]; then
        echoerr Another sound card installed -  $SOUND_CARD_ID.
        return 1
    fi
}

is_audioinjector_installed
