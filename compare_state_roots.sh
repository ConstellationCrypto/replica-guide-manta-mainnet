#!/bin/bash

# Script to compare state roots between ETH_RPC_URL and L2_URL latest blocks
# Usage: ./compare_state_roots.sh

# Set default URLs if not already exported
export ETH_RPC_URL=${ETH_RPC_URL:-"http://localhost:8545"}
export L2_URL=${L2_URL:-"https://manta-pacific.calderachain.xyz/http"}

echo "Comparing state roots between:"
echo "ETH_RPC_URL: $ETH_RPC_URL"
echo "L2_URL: $L2_URL"
echo ""

# Check if cast is available
if ! command -v cast &> /dev/null; then
    echo "Error: 'cast' command not found. Please install foundry first."
    echo "Visit: https://book.getfoundry.sh/getting-started/installation"
    exit 1
fi

# Get latest block number from ETH_RPC_URL
echo "Getting latest block number from ETH_RPC_URL..."
ETH_LATEST_BLOCK=$(cast block latest --field number --rpc-url $ETH_RPC_URL 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Failed to get latest block from ETH_RPC_URL"
    exit 1
fi

echo "ETH latest block number: $ETH_LATEST_BLOCK"

# Get state root of latest block from ETH_RPC_URL
echo "Getting state root from ETH_RPC_URL latest block..."
ETH_STATE_ROOT=$(cast block $ETH_LATEST_BLOCK --field stateRoot --rpc-url $ETH_RPC_URL 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Failed to get state root from ETH_RPC_URL"
    exit 1
fi

echo "ETH state root: $ETH_STATE_ROOT"
echo ""


# Get state root of common latest block from L2_URL
echo "Getting state root from L2_URL latest block..."
L2_STATE_ROOT=$(cast block $ETH_LATEST_BLOCK --field stateRoot --rpc-url $L2_URL 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "Error: Failed to get state root from L2_URL"
    exit 1
fi

echo "L2 state root: $L2_STATE_ROOT"
echo ""

# Compare the state roots
echo "=== COMPARISON RESULTS ==="
echo "ETH_RPC_URL latest block: $ETH_LATEST_BLOCK"
echo "ETH_RPC_URL state root:   $ETH_STATE_ROOT"
echo ""
echo "L2_URL latest block:      $ETH_LATEST_BLOCK"
echo "L2_URL state root:        $L2_STATE_ROOT"
echo ""

if [ "$ETH_STATE_ROOT" = "$L2_STATE_ROOT" ]; then
    echo "✅ State roots MATCH!"
    echo "Both chains have the same state root."
else
    echo "❌ State roots DO NOT MATCH!"
    echo "The chains have different state roots."
fi
