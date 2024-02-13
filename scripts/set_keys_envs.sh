#!/bin/sh
set -euo pipefail

# set the environment variables KEY1 and KEY2 based on output from gmd keys list.
# this file should be sourced, `source scripts/set_keys_envs.sh` not executed.

export KEY1="$(gmd keys list --keyring-backend test | grep -v gm-key-2 | grep gm-key -B 1 | grep address | sed 's/- address: //')"
export KEY2="$(gmd keys list --keyring-backend test | grep gm-key-2 -B 1 | grep address | sed 's/- address: //')"
