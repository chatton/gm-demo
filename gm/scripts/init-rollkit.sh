#!/bin/sh

set -eou pipefail

# set variables for the chain
VALIDATOR_NAME=validator1
CHAIN_ID=gm
KEY_NAME=gm-key
KEY_2_NAME=gm-key-2
CHAINFLAG="--chain-id ${CHAIN_ID}"
TOKEN_AMOUNT="10000000000000000000000000stake"
STAKING_AMOUNT="1000000000stake"

if ! which jq > /dev/null; then
  echo "jq not found, please install jq"
  exit 1
fi

if ! which curl > /dev/null; then
  echo "curl not found, please install curl"
  exit 1
fi

echo "Running initialise Rollkit app script. Sleeping for 5 secs..."
sleep 5

# query the DA Layer start height, in this case we are querying
# our local devnet at port 26657, the RPC. The RPC endpoint is
# to allow users to interact with Celestia's nodes by querying
# the node's state and broadcasting transactions on the Celestia
# network. The default port is 26657.
DA_BLOCK_HEIGHT=$(curl http://celestia:26657/block | jq -r '.result.block.header.height')


# rollkit logo
cat <<'EOF'

                 :=+++=.                
              -++-    .-++:             
          .=+=.           :++-.         
       -++-                  .=+=: .    
   .=+=:                        -%@@@*  
  +%-                       .=#@@@@@@*  
    -++-                 -*%@@@@@@%+:   
       .=*=.         .=#@@@@@@@%=.      
      -++-.-++:    =*#@@@@@%+:.-++-=-   
  .=+=.       :=+=.-: @@#=.   .-*@@@@%  
  =*=:           .-==+-    :+#@@@@@@%-  
     :++-               -*@@@@@@@#=:    
        =%+=.       .=#@@@@@@@#%:       
     -++:   -++-   *+=@@@@%+:   =#*##-  
  =*=.         :=+=---@*=.   .=*@@@@@%  
  .-+=:            :-:    :+%@@@@@@%+.  
      :=+-             -*@@@@@@@#=.     
         .=+=:     .=#@@@@@@%*-         
             -++-  *=.@@@#+:            
                .====+*-.  

   ______         _  _  _     _  _   
   | ___ \       | || || |   (_)| |  
   | |_/ /  ___  | || || | __ _ | |_ 
   |    /  / _ \ | || || |/ /| || __|
   | |\ \ | (_) || || ||   < | || |_ 
   \_| \_| \___/ |_||_||_|\_\|_| \__|
EOF

# echo variables for the chain
echo -e "\n Your DA_BLOCK_HEIGHT is $DA_BLOCK_HEIGHT \n"

#rm -rf /root/.gm

# build the gm chain with Rollkit

# reset any existing genesis/chain data
gmd tendermint unsafe-reset-all

sleep 1

# initialize the validator with the chain ID you set
gmd init $VALIDATOR_NAME --chain-id $CHAIN_ID

VAL_MNEMONIC_1="clock post desk civil pottery foster expand merit dash seminar song memory figure uniform spice circle try happy obvious trash crime hybrid hood cushion"
WALLET_MNEMONIC_1="banner spread envelope side kite person disagree path silver will brother under couch edit food venture squirrel civil budget number acquire point work mass"
RLY_MNEMONIC_1="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"

echo "Adding genesis accounts..."
echo ${VAL_MNEMONIC_1} | gmd keys add validator1 --recover --keyring-backend=test
echo ${WALLET_MNEMONIC_1} | gmd keys add $KEY_NAME --recover --keyring-backend=test
echo ${RLY_MNEMONIC_1} | gmd keys add $KEY_2_NAME --recover --keyring-backend=test

gmd genesis add-genesis-account "$(gmd keys show validator1 --keyring-backend test -a)" 10000000000000000stake
gmd genesis add-genesis-account "$(gmd keys show $KEY_NAME --keyring-backend test -a)" 100000000000000000stake
gmd genesis add-genesis-account "$(gmd keys show $KEY_2_NAME --keyring-backend test -a)" 100000000000000000stake

# set the staking amounts in the genesis transaction
gmd genesis gentx validator1 $STAKING_AMOUNT --chain-id $CHAIN_ID --keyring-backend test

# collect genesis transactions
gmd genesis collect-gentxs

# copy centralized sequencer address into genesis.json
# Note: validator and sequencer are used interchangeably here
ADDRESS=$(jq -r '.address' ~/.gm/config/priv_validator_key.json)
PUB_KEY=$(jq -r '.pub_key' ~/.gm/config/priv_validator_key.json)
jq --argjson pubKey "$PUB_KEY" '.consensus["validators"]=[{"address": "'$ADDRESS'", "pub_key": $pubKey, "power": "1000", "name": "Rollkit Sequencer"}]' ~/.gm/config/genesis.json > temp.json && mv temp.json ~/.gm/config/genesis.json

# start the chain
gmd start --rollkit.aggregator --rollkit.da_address="celestia:26650" --rollkit.da_start_height $DA_BLOCK_HEIGHT --rpc.laddr tcp://0.0.0.0:36657 --grpc.address "0.0.0.0:9290" --p2p.laddr "0.0.0.0:36656" --minimum-gas-prices="0.025stake"
