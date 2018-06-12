#!/bin/bash -e

echoerr() {
    echo "$@" 1>&2
}

SCRIPT_NAME="${0/*\//}"
SCRIPT_NAME=${SCRIPT_NAME%.sh}
readonly SCRIPT_NAME

readonly TEST_DURATION=5
readonly INPUT_SKIP=0.8

readonly DEF_FREQ=10000
readonly DEF_AUDIO_DEVICE=hw:audioinjectorpi
readonly DEF_SAMPLE_RATE=48000

readonly FILTER_SPECTOGRAM='showspectrumpic=s=hd720:scale=log'
readonly FILTER_WAVEFORM='showwavespic=s=hd720'

declare AI_INPUT
declare PICTURE_FILE=''
declare AUDIO_DEVICE=$DEF_AUDIO_DEVICE
declare ADJUST_MIXER=1
declare SAMPLE_RATE=$DEF_SAMPLE_RATE
declare FREQ=$DEF_FREQ

usage() {
    echo "Usage: $SCRIPT_NAME [-o file-name] [-D audio-device] [-r sample_rate] [-f frequency ] source|help"
    echo '  source: line-in, mic, ref'
}

check_dependencies() {
    check_command() {
        local CMD=$(which $1 2> /dev/null)
        if [[ -z "$CMD" ]]; then
            echoerr Couldn\'t find the $1 command. Please install the $2 pacakge.
            return 1
        fi
    }

    local RES=0
    check_command ffmpeg ffmpeg || RES=1
    check_command aplay alsa-utils || RES=1
    check_command arecord alsa-utils || RES=1
    check_command bc bc || RES=1
    return $RES
}

check_dependencies || exit 1

while getopts ":D:r:o:f:h" opt; do
    case ${opt} in
        D)
        AUDIO_DEVICE=$OPTARG
        ADJUST_MIXER=0
        ;;

        r)
        SAMPLE_RATE=$OPTARG
        ;;
        
        o)
        PICTURE_FILE=$OPTARG
        ;;
        
        f)
        FREQ=$OPTARG
        ;;
        
        h)
        usage
        exit 0
        ;;

        \?)
        echoerr "Invalid option: $OPTARG"
        exit 1
        ;;

        :)
        echoerr "Invalid option: $OPTARG requires an argument"
        exit 1
        ;;
    esac
done
shift $((OPTIND -1))

if [[ $# -lt 1 ]]; then
    echoerr 'You must specify source - line-in, mic or ref'
    exit 1
fi

case $1 in
    line|line-in)
    AI_INPUT=line-in
    ;;

    mic|microphone)
    AI_INPUT=mic
    ;;

    ref|reference)
    AI_INPUT=ref
    ;;

    help)
    usage
    exit 0
    ;;

    *)
    echo "Invalid parameter: $1"
    exit 1
    ;;
esac

if [[ -z $PICTURE_FILE ]]; then
    PICTURE_FILE=audio-injector-$AI_INPUT.png
fi

readonly -a ARECORD_PARAMS=(-q -N -M -t raw -D $AUDIO_DEVICE -c 2 -r $SAMPLE_RATE -f S16_LE -d $TEST_DURATION)
readonly -a APLAY_PARAMS=(-q -N -M -t raw -D  $AUDIO_DEVICE -c 2 -r $SAMPLE_RATE -f S16_LE)

readonly -a FFMPEG_PLAY_PARAMS=(
    -hide_banner -loglevel repeat+error
    -f lavfi -i "sine=frequency=$FREQ:sample_rate=$SAMPLE_RATE"
    -f lavfi -i "sine=frequency=$(($FREQ/2)):sample_rate=$SAMPLE_RATE"
    -filter_complex "[0:a][1:a] amerge=inputs=2 , volume=18dB , tremolo=f=1.5:d=1 [out]"
    -map '[out]' -f s16le -t $TEST_DURATION pipe:1
)

readonly -a FFMPEG_PIC_PARAMS=(
    -y -hide_banner -loglevel repeat+error -ss $INPUT_SKIP
    -f s16le -ac 2 -ar $SAMPLE_RATE -i pipe:0
    -filter_complex "[0:a] $FILTER_SPECTOGRAM [pic]"
    -map '[pic]' "$PICTURE_FILE"
)

readonly REF_DURATION=$(echo $TEST_DURATION-$INPUT_SKIP|bc -l)

readonly -a FFMPEG_REF_PIC_PARAMS=(
    -y -hide_banner -loglevel repeat+error
    -f lavfi -i "sine=frequency=$FREQ:sample_rate=$SAMPLE_RATE:duration=$REF_DURATION"
    -f lavfi -i "sine=frequency=$(($FREQ/2)):sample_rate=$SAMPLE_RATE:duration=$REF_DURATION"
    -filter_complex "[0:a][1:a] amerge=inputs=2 , volume=18dB , tremolo=f=1.5:d=1 , $FILTER_SPECTOGRAM [pic]"
    -map '[pic]' "$PICTURE_FILE"
)

sine_playback() {
    ffmpeg "${FFMPEG_PLAY_PARAMS[@]}" | aplay "${APLAY_PARAMS[@]}"
}

draw_picture() {
    arecord "${ARECORD_PARAMS[@]}" | ffmpeg "${FFMPEG_PIC_PARAMS[@]}"
}

draw_ref_picture() {
    ffmpeg "${FFMPEG_REF_PIC_PARAMS[@]}"
}

case $AI_INPUT in
    line-in|mic)
    if [[ $ADJUST_MIXER -eq 1 ]]; then
        # Mixer settings
        audioinjectorctl listen off
        audioinjectorctl playback-to line-out
        audioinjectorctl record-from $AI_INPUT
    fi

    # Playback & record
    sine_playback &
    draw_picture
    wait
    ;;

    ref)
    draw_ref_picture
    ;;
esac
