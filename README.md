# gm-demo

### Build wasm simapp image in ibc-go

in ibc-go directory

```bash
make build-docker-wasm
```

### Create celestia dev testnet

gm-demo repo.

In a new terminal.

```bash
make celestia-devnet
```

### Start rollkit rollup app.

```bash
make rollkit
```

### Start wasm simapp

```bash
make wasm-simapp
```