#!/bin/bash -e

readonly SCRIPT_NAME="${0/*\//}"
readonly SCRIPT_DIR=$(dirname "$0")
readonly FN_SCRIPT=audio-injector-functions.sh

echoerr() {
    echo "$@" 1>&2
}

# include functions
if [ -f /usr/share/audio-injector/${FN_SCRIPT} ]; then
    . /usr/share/audio-injector/${FN_SCRIPT}
elif [ -f ${SCRIPT_DIR}/${FN_SCRIPT} ]; then
    . ${SCRIPT_DIR}/${FN_SCRIPT}
else
    echoerr "${SCRIPT_NAME}: Unable to find ${FN_SCRIPT} file"
    exit 1
fi

# init[-playback]
usage_init_playback() {
    echo "usage: ${SCRIPT_NAME} init-playback|help"
}

cmd_init_playback() {
    if [ $# -lt 1 ]; then
        ai_init_playback
        return 0
    fi
    
    local INIT_PARAM="$1"
    shift

    case "${INIT_PARAM}" in
        help)
        usage_playback_to
        ;;

        *)
        echoerr "${SCRIPT_NAME} init-playback: Unknown parameter - ${INIT_PARAM}"
        return 1
        ;;
    esac
}

# playback[-to]
usage_playback_to() {
    echo "usage: ${SCRIPT_NAME} playback-to output|help"
    echo ' output: line-out'
}

cmd_playback_to() {
    if [ $# -lt 1 ]; then
        usage_playback_to
        return 0
    fi
    
    local PLAYBACK_OUT="$1"
    shift

    case "${PLAYBACK_OUT}" in
        line|line-out)
        ai_playback_to_lineout "$@"
        ;;

        help)
        usage_playback_to
        ;;

        *)
        echoerr "${SCRIPT_NAME} playback-to: Unknown output - ${PLAYBACK_OUT}"
        return 1
        ;;
    esac
}

# record[-from]

usage_record_from() {
    echo "usage: ${SCRIPT_NAME} record-from input|help"
    echo ' input: mic, line-in'
}

cmd_record_from() {
    if [ $# -lt 1 ]; then
        usage_record_from
        return 0
    fi
    
    local RECORD_IN="$1"
    shift
    case "${RECORD_IN}" in
        mic)
        ai_record_from_mic "$@"
        ;;

        line|line-in)
        ai_record_from_linein "$@"
        ;;

        help)
        usage_record_from
        ;;

        *)
        echoerr "${SRCIPT_NAME} record-from: Unknown input - ${RECORD_IN}"
        return 1
        ;;
    esac
}

# listen

usage_listen() {
    echo "usage: ${SRIPT_NAME} listen input|help"
    echo ' input: line-in, mic'
}

cmd_listen() {
    if [ $# -lt 1 ]; then
        usage_listen
        return 0
    fi
    local LISTEN_IN="$1"
    shift 1
    case "$LISTEN_IN" in
        line|line-in)
        ai_listen_linein "$@"
        ;;
        
        mic)
        ai_listen_mic "$@"
        ;;
        
        help)
        usage_listen
        ;;

        *)
        echoerr "${SCRIPT_NAME} listen: invalid input - ${LISTEN_IN}"
        return 1
        ;;
    esac
}

# ainjectorctl

usage() {
    echo "usage: ${SCRIPT_NAME} command|help [...]"
    echo ' command: init-playback, playback-to, record-from, listen'
}

mixer_query || {
    exit 2
}

# check parameters
if [ $# -lt 1 ]; then
    usage
    exit 0
fi

CMD=$1
shift

case "$CMD" in
    init|init-playback)
    cmd_init_playback "$@"

    playback|playback-to)
    cmd_playback_to "$@"
    ;;

    record|record-from)
    cmd_record_from "$@"
    ;;

    listen|monitor)
    cmd_listen "$@"
    ;;

    help)
    usage
    ;;

    *)
    echoerr "${SCRIPT_NAME}: Unknown command - ${CMD}"
    exit 1
    ;;
esac
