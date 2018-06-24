#
# Audio Injector mixer functions
#

AI_DEBUG=0

readonly AI_DEVICE=hw:audioinjectorpi

# controls

readonly AI_MASTER_PLAYBACK_VOLUME='Master Playback Volume'
readonly AI_MASTER_PLAYBACK_ZC_SWITCH='Master Playback ZC Switch'
readonly AI_CAPTURE_VOLUME='Capture Volume'
readonly AI_LINE_CAPTURE_SWITCH='Line Capture Switch'
readonly AI_MIC_BOOST_VOLUME='Mic Boost Volume'
readonly AI_MIC_CAPTURE_SWITCH='Mic Capture Switch'
readonly AI_SIDETONE_PLAYBACK_VOLUME='Sidetone Playback Volume'
readonly AI_ADC_HIGH_PASS_FILTER_SWITCH='ADC High Pass Filter Switch'
readonly AI_STORE_DC_OFFSET_SWITCH='Store DC Offset Switch'
readonly AI_PLAYBACK_DEEMPHASIS_SWITCH='Playback Deemphasis Switch'
readonly AI_OUTPUT_MIXER_LINE_BYPASS_SWITCH='Output Mixer Line Bypass Switch'
readonly AI_OUTPUT_MIXER_MIC_SIDETONE_SWITCH='Output Mixer Mic Sidetone Switch'
readonly AI_OUTPUT_MIXER_HIFI_PLAYBACK_SWITCH='Output Mixer HiFi Playback Switch'
readonly AI_INPUT_MUX='Input Mux'

# internal mixer routines

ai_mixer_query() {
    if [[ $AI_DEBUG -ne 1 ]]; then
        amixer -q -D ${AI_DEVICE} scontents > /dev/null
    fi
}

ai_cset() {
    echo "cset 'name=$1' '$2'"
}

ai_mixer() {
    if [[ $AI_DEBUG -eq 1 ]]; then
        amixer -D ${AI_DEVICE} cset name="$1" "$2"
    else
        amixer -q -D ${AI_DEVICE} cset name="$1" "$2"
    fi
}

ai_mixer_script() {
    if [[ $AI_DEBUG -eq 1 ]]; then
        cat
    else
        amixer -q -D ${AI_DEVICE} -s
    fi
}

# init

ai_init_playback() {
    {
       ai_cset "$AI_MASTER_PLAYBACK_VOLUME" 121
       ai_cset "$AI_MASTER_PLAYBACK_ZC_SWITCH" off
       ai_cset "$AI_AI_CAPTURE_VOLUME" 23
       ai_cset "$AI_LINE_CAPTURE_SWITCH" off
       ai_cset "$AI_MIC_CAPTURE_SWITCH" off
       ai_cset "$AI_MIC_BOOST_VOLUME" 0
       ai_cset "$AI_SIDETONE_PLAYBACK_VOLUME" 0
       ai_cset "$AI_ADC_HIGH_PASS_FILTER_SWITCH" off
       ai_cset "$AI_STORE_DC_OFFSET_SWITCH" off
       ai_cset "$AI_PLAYBACK_DEEMPHASIS_SWITCH" off
       ai_cset "$AI_OUTPUT_MIXER_LINE_BYPASS_SWITCH" off
       ai_cset "$AI_OUTPUT_MIXER_MIC_SIDETONE_SWITCH" off
       ai_cset "$AI_OUTPUT_MIXER_HIFI_PLAYBACK_SWITCH" on
       ai_cset "$AI_INPUT_MUX" "Line In"
    } | ai_mixer_script
}

ai_listen_linein() {
    {
        ai_cset "$AI_OUTPUT_MIXER_HIFI_PLAYBACK_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_MIC_SIDETONE_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_LINE_BYPASS_SWITCH" on
    } | ai_mixer_script
}

# playback

ai_playback_to_lineout() {
    {
        ai_cset "$AI_MASTER_PLAYBACK_VOLUME" 121
        ai_cset "$AI_MASTER_PLAYBACK_ZC_SWITCH" off
        ai_cset "$AI_SIDETONE_PLAYBACK_VOLUME" 0
        ai_cset "$AI_OUTPUT_MIXER_LINE_BYPASS_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_MIC_SIDETONE_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_HIFI_PLAYBACK_SWITCH" on
    } | ai_mixer_script
}

# record

ai_record_from_linein() {
    {
        ai_cset "$AI_LINE_CAPTURE_SWITCH" on
        ai_cset "$AI_MIC_CAPTURE_SWITCH" off
        ai_cset "$AI_INPUT_MUX" "Line In"
        ai_cset "$AI_AI_CAPTURE_VOLUME" 23
    } | ai_mixer_script
}

ai_record_from_mic() {
    {
        ai_cset "$AI_LINE_CAPTURE_SWITCH" off
        ai_cset "$AI_MIC_CAPTURE_SWITCH" on
        ai_cset "$AI_INPUT_MUX" "Mic"
        ai_cset "$AI_AI_CAPTURE_VOLUME" 23
        ai_cset "$AI_MIC_BOOST_VOLUME" 1
    } | ai_mixer_script
}

ai_record_off() {
    {
        ai_cset "$AI_LINE_CAPTURE_SWITCH" off
        ai_cset "$AI_MIC_CAPTURE_SWITCH" off
    } | ai_mixer_script
}

# listen/monitor

ai_listen_linein() {
    {
        ai_cset "$AI_OUTPUT_MIXER_HIFI_PLAYBACK_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_MIC_SIDETONE_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_LINE_BYPASS_SWITCH" on
    } | ai_mixer_script
}

ai_listen_mic() {
    {
        ai_cset "$AI_OUTPUT_MIXER_HIFI_PLAYBACK_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_LINE_BYPASS_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_MIC_SIDETONE_SWITCH" on
    } | ai_mixer_script
}

ai_listen_off() {
    {
        ai_cset "$AI_OUTPUT_MIXER_LINE_BYPASS_SWITCH" off
        ai_cset "$AI_OUTPUT_MIXER_MIC_SIDETONE_SWITCH" off
    } | ai_mixer_script
}
