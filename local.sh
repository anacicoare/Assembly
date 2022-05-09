#!/bin/bash

cd "$(dirname "$0")" || exit 1

#=============================================================================
#=================================== UTILS ===================================
#=============================================================================

LOG_INFO() {
    echo "[INFO] $1"
}

#=============================================================================
#=============================================================================
#=============================================================================

print_help() {
    echo "Usage:"
    echo ""
    echo "local.sh [-h|--help] [--remove_image] [argumets_for_checker]"
    echo ""
    echo "      --remove_image - remove the checker's docker image after the run"
    echo "      -h|--help - prints this message"
    echo "      argumets_for_checker - list of space separated arguments to be passed to the checker"
    echo ""
}

main() {
    local script_args=()
    local remove_image=''

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_help
                exit 0
            ;;
            --remove_image)
                remove_image='true'
            ;;
            *)
                script_args+=("$1")
            ;;
        esac
        shift
    done

    image_name="$(basename "$(pwd)")"

    LOG_INFO "Building image..."
    docker build -q -t "$image_name" .


    tmpdir="$(mktemp -d)"
    cp -R ./* "$tmpdir"

    LOG_INFO "Running checker..."
    docker run --rm \
            --name "$image_name-container" \
            --mount type=bind,source="$tmpdir",target=/build \
            "$image_name" /bin/bash /build/checker/checker.sh "${script_args[@]}"

    if [ -n "$remove_image" ] ; then
        LOG_INFO "Cleaning up..."
        docker rmi -f "$image_name":latest
    fi

}

main "$@"
