#!/usr/bin/env sh

main() {
    if uses "${INPUT_WORKDIR}"; then
        cd "${INPUT_WORKDIR}"
    fi

    if ! uses "${INPUT_TAG}"; then
        INPUT_TAG="release-$(date +%Y%m%d%H%M%S)"
    fi

    set -- --generate-notes
    if usesBoolean "${INPUT_PRERELEASE}"; then
        set -- "$@" --prerelease
    fi

    gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" "$@"
}

uses() {
  [ ! -z "${1}" ]
}

usesBoolean() {
    [ ! -z "${1}" ] && [ "${1}" = "true" ]
}

main
