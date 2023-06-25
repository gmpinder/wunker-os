#!/usr/bin/env bash

# https://docs.gitlab.com/runner/install/docker.html#selinux

set -euo pipefail

git clone https://github.com/dpw/selinux-dockersock.git /tmp/selinux-dockersock

pushd /tmp/selinux-dockersock

make dockersock.pp

semodule -i dockersock.pp

popd