#!/usr/bin/env zsh
set -eu

REPO_DIR="${0:h}"  # where the script resides
pushd "${REPO_DIR}"

IMAGE_PREFIX="${IMAGE_PREFIX:-custom-}"
IMAGE_TAG="${IMAGE_TAG:=latest}"

VERBOSE_SWITCH="--quiet"
declare -au IMAGES_TO_BUILD
DOCKERFILES=(**/Dockerfile)

function usage () {
    echo -e"USAGE:\n\t${0} [-v/--verbose] [image] {[image]}"
    exit 1
}

function handle_args () {
    while (( ${#} )); do
        case "${1}" in
            -h|--help)
                usage
                ;;
            -v|--verbose)
                VERBOSE_SWITCH=""
                ;;
            -s|--silent)
                VERBOSE_SWITCH="-s"
                ;;
            *)
                [[ -f "${1}/Dockerfile" ]] && IMAGES_TO_BUILD+=("${1}")
                ;;
        esac
        shift
    done

    if [[ ${#IMAGES_TO_BUILD[@]} -eq 0 ]]; then
        for dockerfile in "${DOCKERFILES[@]}"; do
            IMAGES_TO_BUILD+=("${dockerfile:h}")
        done
    fi
}

function _quiet () { echo -n "${1} > /dev/null" }
function _silent () { echo -n "${1} &> /dev/null" }

function _run_cmd () {
    [[ -n "${1}" ]] || return
    case "${2}" in
        -s|--silent)
            eval "$(_silent ${1})" ;;
        -q|--quiet)
            eval "$(_quiet ${1})" ;;
        *)
            eval "${1}" ;;
    esac
}

function run_log_cmd () {
    [[ -n "${1}" ]] || return
    echo -e "$(tput setaf 12)[$(date +'%H:%M:%S')] RUNNING: ${1}$(tput sgr0)"
    _run_cmd ${1} "${2:-${VERBOSE_SWITCH}}"
}

function _build () {
    local dockerfile_dir="${1}"
    local image_name="${IMAGE_PREFIX}${2-${dockerfile_dir}}"
    local image_tag="${3:-${IMAGE_TAG}}"
    run_log_cmd "pushd ${dockerfile_dir}"
    run_log_cmd "docker build . -t ${image_name}:${image_tag}"
    run_log_cmd "popd"
}

function build_images () {
    for image in "${IMAGES_TO_BUILD[@]}"; do
        _build "${image}"
    done
}

function main () {
    handle_args "${@}"
    build_images
}

main "${@}"
popd
