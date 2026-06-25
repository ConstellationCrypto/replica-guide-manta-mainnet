# Manta Pacific Replica Guide

Manta Pacific replica using op-reth, op-node (AltDA), and op-alt-da (Celestia).

## Quick start

1. Download the [reth datadir snapshot](#datadir-snapshot) into `./reth_data`.
2. Copy `.env.example` to `.env` and set `L1_RPC_URL` (Ethereum mainnet, chain id `1`).
3. Configure [op-alt-da](#op-alt-da-configuration) for Celestia access.
4. Run `make up`.

## Stack

- **op-reth** `public.ecr.aws/i6b2w2n6/op-reth:v2.2.3`
- **op-node** `public.ecr.aws/i6b2w2n6/op-node:1.16.1-celestia-e9ec322-altda` ([AltDA mode](https://docs.optimism.io/builders/chain-operators/features/alt-da-mode))
- **op-alt-da** `public.ecr.aws/i6b2w2n6/op-alt-da:v0.15.0-4d9d54d` ([celestiaorg/op-alt-da](https://github.com/celestiaorg/op-alt-da))

Celestia namespace: `866269ddf77dbc40ed9d` (29-byte v0 form in config: `00000000000000000000000000000000000000866269ddf77dbc40ed9d`).

## Datadir snapshot

Download and extract into `./reth_data` before the first start. This snapshot includes proofs data under `proofs-db/`:

https://caldera-chain-data-snapshots.s3.us-west-2.amazonaws.com/exported-snapshots/bedrock-manta-pacific/bedrock-manta-pacific-reth-2026-Jun-24.tar

If you do not need proofs, remove these flags from `docker-compose.yml` (`op-reth` service):

```
--proofs-history --proofs-history.storage-path=/root/datadir/proofs-db --proofs-history.storage-version=v2 --rpc.eth-proof-window=1209600 --proofs-history.window=5184000
```

and delete `reth_data/proofs-db`.

## op-alt-da configuration

Edit [op-alt-da-config.toml](op-alt-da-config.toml): set Celestia bridge gRPC URL and auth token for read-only access. Fallback S3 is configured with `mode = "read_fallback"` so the replica only reads from the public cache and does not attempt S3 writes.

## Commands

```bash
make up
make down
make clean
```

Or directly:

```bash
export L1_RPC_URL=<mainnet-rpc>
docker compose up -d
```

### Query L2 RPC

```bash
RPC_URL=http://localhost:8545
curl $RPC_URL -X POST -H "Content-Type: application/json" --data \
    '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

### Rollup sync status

```bash
RPC_URL=http://localhost:17545
curl $RPC_URL -X POST -H "Content-Type: application/json" --data \
    '{"jsonrpc":"2.0","method":"optimism_syncStatus","params":[],"id":1}' | jq .
```

or `RPC_URL=http://localhost:17545 bash progress.sh`

## Celestia upgrades

Please refer to celestia docs for network upgrades: https://docs.celestia.org/how-to-guides/participate#network-upgrades
