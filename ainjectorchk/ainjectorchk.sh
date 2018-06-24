#!/bin/bash -e

echoerr() {
    echo "$@" 1>&2
}

readonly SOC_SOUND=/sys/devices/platform/soc/soc:sound/sound

is_audioinjector_installed() {
    local scard
    local scard_id

    for scard in ${SOC_SOUND}/card*; do
        if [[ ! -s ${scard}/id ]]; then
            continue
        fi

        scard_id=$(cat ${scard}/id)

        if [[ ${scard_id} -eq audioinjectorpi ]]; then
            return 0
        fi
    done

    echoerr 'Sound card not found'
    return 1
}

is_audioinjector_installed
