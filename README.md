# gm-demo

> NOTE: The following steps are only applicable when building images manually. The `docker-compose` file uses images pushed to this repository.

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
The go relayer will also be started and the path will be linked.

> the rollkit and wasm image can be overridden by setting the `ROLLKIT_IMAGE` and `WASM_SIMAPP_IMAGE` environment variables.
> By default, images built in CI will be used.

```bash
docker-compose up
```

or

```bash
docker compose up
```

> It may be required to run `docker system prune` in between runs to wipe state.

### Send IBC transfer from rollkit app to simapp

1. IBC Transfer cmd:

```bash
make ibc-transfer
```

2. Query packet commitments on rollkit app
```bash
gmd q ibc channel packet-commitments transfer channel-0 --node tcp://localhost:36657
```

3. Start Relayer:

```bash
rly start
```

4. Query balance on simapp account

```bash
docker exec -it wasm-simapp /bin/sh

simd q bank balances cosmos1m9l358xunhhwds0568za49mzhvuxx9uxre5tud --node tcp://localhost:46657
```