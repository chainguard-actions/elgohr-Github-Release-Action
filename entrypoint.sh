#!/usr/bin/env sh

main() {
    if uses "${INPUT_WORKDIR}"; then
        cd "${INPUT_WORKDIR}"
    fi

    if ! uses "${INPUT_TAG}"; then
        INPUT_TAG="release-$(date +%Y%m%d%H%M%S)"
    fi

    if usesBoolean "${INPUT_PRERELEASE}"; then
        gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" --generate-notes --prerelease
    else
        gh release create "$INPUT_TAG" -t "${INPUT_TITLE}" --generate-notes
    fi
}

uses() {
  [ ! -z "${1}" ]
}

usesBoolean() {
    [ ! -z "${1}" ] && [ "${1}" = "true" ]
}

main
