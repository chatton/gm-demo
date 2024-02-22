import json
import sys
import gzip


def _read_wasm_bytes(wasm_contract_path):
    # return wasm_contract_path
    with open(wasm_contract_path, 'rb') as f:
        return str(gzip.compress(f.read()))


def _modify_genesis(genesis_contents, genesis_file_path, wasm_contract_path):
    data = genesis_contents
    if not data:
        raise ValueError("failed to load genesis file")

    data = json.loads(data)

    if '08-wasm' not in ['app_state']:
        data['app_state']['08-wasm'] = {}

    data['app_state']['08-wasm']['contracts'] = [
        {"code_bytes": _read_wasm_bytes(wasm_contract_path)}
    ],

    updated_genesis = json.dumps(data, indent=4)
    with open(genesis_file_path, "w") as outfile:
        outfile.write(updated_genesis)

    print("Genesis file updated successfully")
    print(updated_genesis)


def main():
    file_contents = sys.argv[1]
    file_path = sys.argv[2]
    wasm_contract_path = sys.argv[3]
    _modify_genesis(file_contents, file_path, wasm_contract_path)


if __name__ == '__main__':
    main()
