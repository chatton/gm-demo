# gm-demo

### Build wasm simapp image in ibc-go

in ibc-go root directory (branch feat/rollkit)

```bash
make build-docker-wasm
```

### Build extended wasm image in this repo in `gm` directory.

```bash
make build-docker-wasm
```

> this is an additional image which adds dependencies only required by this demo repo.

### Build rollkit rollapp image in this repo in `gm` directory.

```bash
make build-docker-rollkit
```

### Install rly binary locally

Checkout [this fork](https://github.com/charleenfei/relayer/tree/feat/tm_wasm_support) of the relayer (branch
feat/tm_wasm_support).

Build the binary with

```bash
make install
```

### Initialize the relayer's configuration directory/file.

```bash
mkdir -p ~/.relayer/config
cp test_configs/config.yaml ~/.relayer/config/config.yaml
```

> run this each time you want to reset the relayer's configuration

### Spin up environment

This will create a wasm simapp, the rollkit app and a celestia dev net.

```bash
docker-compose up
```

or

```bash
docker compose up
```

> It may be required to run `docker system prune` in between runs to wipe state.

### Link the path with the relayer

In a different terminal, run

```bash
./init-rly.sh
```

This will create the clients, connection and channel.

### Send IBC transfer from rollkit app to simapp

1. IBC Transfer cmd:

```bash
gmd tx ibc-transfer transfer transfer channel-0 cosmos1m9l358xunhhwds0568za49mzhvuxx9uxre5tud 1000stake --from gm-key --key
ring-backend test --chain-id gm --node tcp://localhost:36657  --gas 150000 --fees 4000stake
```

2. Start Relayer:

```bash
rly start
```

3. Query balance on simapp account

```bash
docker exec -it gm_wasm-simapp_1 /bin/sh

simd q bank balances cosmos1m9l358xunhhwds0568za49mzhvuxx9uxre5tud --node tcp://localhost:46657
```