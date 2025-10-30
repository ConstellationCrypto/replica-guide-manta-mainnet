# Manta Pacific Replica Guide

1. Download the datadir snapshot to ./datadir.
2. Set `L1_RPC_URL` in `up.sh`
3. Run `make up`.

## Latest snapshot
date: 2025-10-28

https://caldera-chain-data-snapshots.s3.us-west-2.amazonaws.com/exported-snapshots/bedrock-manta-pacific/bedrock-manta-pacific-2025-Oct-28.tar

## Commands:

```
make up
make down
make clean
```

To query the RPC:

```
RPC_URL=http://localhost:8545
curl $RPC_URL -X POST -H "Content-Type: application/json" --data \
    '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

To check on the sync status of the node:

```
RPC_URL=http://localhost:7545
curl $RPC_URL -X POST -H "Content-Type: application/json" --data \
    '{"jsonrpc":"2.0","method":"optimism_syncStatus","params":[],"id":1}' | jq .
```

or `bash progress.sh`

## Celestia upgrades
Please refer to celestia docs for network upgrades: https://docs.celestia.org/how-to-guides/participate#network-upgrades
