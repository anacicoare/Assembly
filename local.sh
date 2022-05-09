#!/bin/bash

cd "$(dirname "$0")" || exit 1

LOG_INFO() {
    echo "[INFO] $1"
}

image_name="$(basename "$(pwd)")"

tmpdir="$(mktemp -d)"
cp -R ./* "$tmpdir"

LOG_INFO "Building image..."
docker build -q -t "$image_name" .

LOG_INFO "Running checker..."
docker run --rm \
        --mount type=bind,source="$tmpdir",target=/build \
        "$image_name" /bin/bash /build/checker/checker.sh

LOG_INFO "Cleaning up..."
docker rmi -f "$image_name":latest
