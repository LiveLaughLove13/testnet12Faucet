#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./seeder.sh [FAUCET_URL]
# Example:
#   ./seeder.sh http://localhost:3010

FAUCET_URL="${1:-http://localhost:3010}"
STATUS_URL="$FAUCET_URL/status"

echo "Fetching faucet status from $STATUS_URL ..."
JSON="$(curl -fsS "$STATUS_URL")"

FAUCET_ADDRESS="$(printf '%s' "$JSON" | sed -n 's/.*"faucet_address"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"

if [ -z "$FAUCET_ADDRESS" ]; then
  echo "Failed to read faucet address from $STATUS_URL"
  echo "Response was: $JSON"
  exit 1
fi

echo
echo "Faucet address:"
echo "  $FAUCET_ADDRESS"
echo
echo "Next: seed/fund this address on testnet-12."
echo
echo "Optional miner integration:"
echo "  export KASPA_MINER_CMD='kaspa-miner -s 127.0.0.1:16210 -a {ADDRESS}'"
echo

if [ -n "${KASPA_MINER_CMD:-}" ]; then
  CMD="${KASPA_MINER_CMD//\{ADDRESS\}/$FAUCET_ADDRESS}"
  echo "Running:"
  echo "  $CMD"
  echo
  exec bash -lc "$CMD"
fi
