#!/usr/bin/env zsh
set -e

REPO_DIR="${0:a:h}"  # where the script resides
IMAGE_PREFIX="custom-"
IMAGE_TAG="stable"

function handle_args () {
    return
}

function quiet () {
    eval "${1} > /dev/null"
}

function _build () {
    local dockerfile_dir="${1}"
    local image_name="${IMAGE_PREFIX}${2-${dockerfile_dir}}"
    local image_tag="${3:-${IMAGE_TAG}}"
    quiet "pushd ${dockerfile_dir}"
    docker build . -t "${image_name}:${image_tag}"
    quiet "popd"
}

function build_images () {
    local dockerfiles=(**/Dockerfile)
    if [[ -n "${1}" ]] && [[ -f "${1}/Dockerfile" ]]; then
        local dockerfiles=("${1}/Dockefile")
    fi

    for dockerfile in "${dockerfiles[@]}"; do
        _build "$(dirname ${dockerfile})"
    done
}

function main () {
    pushd "${REPO_DIR}"
    build_images "${@}"
    popd
}

main "${@}"
