#!/bin/bash
set -xeo pipefail

TESTSET=${1:-}
echo "\$TESTSET='$TESTSET'"

if [[ -z "$FAUCET_URL" ]]; then
    echo 'FAUCET_URL is not set'
    exit 1
else
    for ADDRESS in 0xaA4d6f4FF831181A2bBfD4d62260DabDeA964fF1 0x6970d087e7e78A13Ea562296edb05f4BB64D5c2E; do
        REQUEST='{ "wallet": "'$ADDRESS'", "amount": 5000 }'
        echo curl -i -X POST -H "Content-Type: text/plain" "$FAUCET_URL/request_neon" -d "$REQUEST"
        curl -i -X POST -H "Content-Type: text/plain" "$FAUCET_URL/request_neon" -d "$REQUEST"
    done
fi

if [ "$TESTSET" = "all" ]; then
    yarn test
else
    node node_modules/mocha/bin/mocha --grep "^$TESTSET"
fi

exit 0
