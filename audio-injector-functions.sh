#
# Audio Injector mixer functions
#
readonly AI_MIXER=audioinjectorpi

mixer_query() {
    amixer -q -c ${AI_MIXER} scontents > /dev/null
}

mixer() {
    mixer -q -c ${AI_MIXER} cset name="$1" "$2"
}

# playback

ai_playback_to_lineout() {
}

# record

ai_record_from_linein() {
}

ai_record_from_mic() {
}

# listen/monitor

ai_listen_linein() {
}

ai_listen_mic() {
}
