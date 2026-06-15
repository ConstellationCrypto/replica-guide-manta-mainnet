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

## op-reth replica (AltDA)

Uses [docker-compose-reth.yml](docker-compose-reth.yml) with:

- **op-reth** `public.ecr.aws/i6b2w2n6/op-reth:v2.2.3`
- **op-node** `public.ecr.aws/i6b2w2n6/op-node:1.16.1-celestia-e9ec322-altda` ([AltDA mode](https://docs.optimism.io/builders/chain-operators/features/alt-da-mode))
- **op-alt-da** `public.ecr.aws/i6b2w2n6/op-alt-da:v0.15.0-4d9d54d` ([celestiaorg/op-alt-da](https://github.com/celestiaorg/op-alt-da))

Celestia namespace: `866269ddf77dbc40ed9d` (29-byte v0 form in config: `00000000000000000000000000000000000000866269ddf77dbc40ed9d`).

### Reth datadir snapshot (recommended)

Download and extract into `./reth_data` before the first start. This snapshot includes proofs data under `proofs-db/`:

https://caldera-chain-data-snapshots.s3.us-west-2.amazonaws.com/exported-snapshots/bedrock-manta-pacific/bedrock-manta-pacific-reth-2026-Jun-15.tar

If you do not need proofs, remove these flags from `docker-compose-reth.yml` (`op-reth` service):

```
--proofs-history --proofs-history.storage-path=/root/datadir/proofs-db --proofs-history.storage-version=v2 --rpc.eth-proof-window=1209600 --proofs-history.window=5184000
```

and delete `reth_data/proofs-db`.

### Configure op-alt-da

Edit [op-alt-da-config.toml](op-alt-da-config.toml): set Celestia bridge gRPC URL and auth token for read-only access.

### Run

`L1_RPC_URL` must point at Ethereum mainnet (chain id `1`).

```bash
cp .env.example .env   # set L1_RPC_URL
make reth-up
# or: export L1_RPC_URL=<mainnet-rpc> && docker compose -f docker-compose-reth.yml up -d
```

Rollup sync status (default op-node port `17545`):

```bash
RPC_URL=http://localhost:17545 bash progress.sh
```

    make reth-down

## Celestia upgrades
Please refer to celestia docs for network upgrades: https://docs.celestia.org/how-to-guides/participate#network-upgrades
