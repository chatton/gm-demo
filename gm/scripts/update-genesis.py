import gzip
import json
import sys
import base64


def _read_wasm_bytes(wasm_contract_path: str):
    with open(wasm_contract_path, 'rb') as f:
        gzipped = gzip.compress(f.read())
        encoded = base64.b64encode(gzipped)
        return encoded.decode('utf-8')


def _modify_genesis(genesis_contents: str, genesis_file_path: str, wasm_contract_path: str) -> None:
    data = genesis_contents
    if not data:
        raise ValueError("invalid genesis file contents")

    data = json.loads(data)

    data['app_state']['08-wasm'] = {
        "contracts": [
            {"code_bytes": _read_wasm_bytes(wasm_contract_path)}
        ],
    }

    updated_genesis = json.dumps(data, indent=4)
    with open(genesis_file_path, "w") as outfile:
        outfile.write(updated_genesis)

    print("Genesis file updated successfully")
    print(updated_genesis)


def main():
    file_contents: str = sys.argv[1]
    file_path: str = sys.argv[2]
    wasm_contract_path: str = sys.argv[3]
    _modify_genesis(file_contents, file_path, wasm_contract_path)


if __name__ == '__main__':
    main()
