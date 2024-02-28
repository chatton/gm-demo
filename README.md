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
