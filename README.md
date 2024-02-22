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

### Run hyperspace relayer

```bash
docker run -v /Users/chrly/IG/code/go/src/gm-demo/gm/test_configs:/test_configs ghcr.io/misko9/hyperspace:20231122v39 create-clients --config-b /test_configs/hyperspace_gm.toml --config-a /test_configs/hyperspace_simapp.toml --config-core /test_configs/config_core.toml
```
