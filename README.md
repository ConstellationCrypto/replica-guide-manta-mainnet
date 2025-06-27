# Manta Pacific Replica Guide

1. Download the datadir snapshot to ./datadir.
2. Set `L1_RPC_URL` in `up.sh`
3. Run `make up`.

## Latest snapshot
https://constellationlabs-dashboard-beta.s3.amazonaws.com/manta-pacific-25-03-2025.tar.gz 

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
