#!/usr/bin/env bash

set -eou pipefail

# Enable fingerprintd service

sudo systemctl enable fprintd.service