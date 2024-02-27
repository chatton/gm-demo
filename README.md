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


Query the client states 

```bash
# docker exec -it <mycontainer> sh

simd q ibc client states --grpc-addr localhost:11290 --grpc-insecure
```

Perform msg transfer

```bash
simd tx ibc-transfer transfer transfer channel-0 cosmos1mjk79fjjgpplak5wq838w0yd982gzkyfrk07am 1000stake --from cosmos1mjk79fjjgpplak5wq838w0yd982gzkyfrk07am --keyring-backend test --chain-id wasm-simapp-1 --node tcp://localhost:46657
```