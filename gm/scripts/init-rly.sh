#!/bin/bash

set -eou pipefail

RLY_MNEMONIC="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"

CHAIN_A_NAME="wasm-simapp-1"
CHAIN_B_NAME="gm"

CHAIN_A_KEY="rly-a"
CHAIN_B_KEY="gm-key"

mkdir -p ${HOME}/.relayer/config

# mount the config file into a different directory so the config directory is writable.
cp /home/relayer/docker/config.yaml ${HOME}/.relayer/config/config.yaml

echo "Using Config"
rly --home ${HOME}/.relayer config show

# relayer will have same address on both chains.
rly --home ${HOME}/.relayer keys restore ${CHAIN_A_NAME} ${CHAIN_A_KEY} "${RLY_MNEMONIC}" || true
rly --home ${HOME}/.relayer keys restore ${CHAIN_B_NAME} ${CHAIN_B_KEY} "${RLY_MNEMONIC}" || true

rly q balance ${CHAIN_A_NAME}
rly q balance ${CHAIN_B_NAME}

rly tx link rollkit-path --src-wasm-code-id 10165ede3c84872d173e57e3fa22c55f73ae41c89e1108e9975ec34568fc7090

rly start
