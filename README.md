# Uniswap V2

[![Actions Status](https://github.com/Uniswap/uniswap-v2-core/workflows/CI/badge.svg)](https://github.com/Uniswap/uniswap-v2-core/actions)
[![Version](https://img.shields.io/npm/v/@uniswap/v2-core)](https://www.npmjs.com/package/@uniswap/v2-core)

In-depth documentation on Uniswap V2 is available at [uniswap.org](https://uniswap.org/docs).

The built contract artifacts can be browsed via [unpkg.com](https://unpkg.com/browse/@uniswap/v2-core@latest/).

# Local Development

The following assumes the use of `12=>node@>=10`.

## Install Dependencies

`yarn`

## Compile Contracts

`yarn compile`

## Run Tests

`yarn test`

## Patch before run on the ethereum node
file:
`../node_modules/@ethereum-waffle/chai/dist/cjs/matchers/emit.js`

string:

`const derivedPromise = promise.then((tx) => contract.provider.getTransactionReceipt(tx.hash) ).then((receipt) => {`

replace: 

`const derivedPromise = promise.then((tx) => contract.provider.waitForTransaction(tx.hash, 3) ).then((receipt) => {`

 
## Deploy ethereum node

#### download Geth 
`https://geth.ethereum.org/downloads/`

(doc: `https://geth.ethereum.org/docs/interface/command-line-options`)

#### extract, mkdir, create account 
`mkdir FirstEthBlockchain`

`./geth --datadir FirstEthBlockchain account new`

#### create file genesis.json (specify public key of created account)
```
{
  "config": {
    "chainId": 1,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "ethash": {},
    "istanbul": {
        "epoch": 30000,
        "policy": 0,
        "ceil2Nby3Block": 0
      }
  },
  "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000f897f893946571d97f340c8495b661a823f2c2145ca47d63c2948157d4437104e3b8df4451a85f7b2438ef6699ff94b131288f355bc27090e542ae0be213c20350b76794b912de287f9b047b4228436e94b5b78e3ee1617194d8dba507e85f116b1f7e231ca8525fc9008a696694e36cbeb565b061217930767886474e3cde903ac594f512a992f3fb749857d758ffda1330e590fa915e80c0",
  "gasLimit": "0xffffffffffff",
  "difficulty": "0x1",
  "mixHash": "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365",
  "nonce": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00",
  "alloc": {
    "0x3b07948f3DDA04BC8040b139AC06a68CE28301F2":{"balance": "2000000000000000000000"}
  }
}
```

#### init
`./geth --datadir ./FirstEthBlockchain init genesis.json`

#### start node

`./geth --rpc --rpccorsdomain="https://remix.ethereum.org" --allow-insecure-unlock --mine --rpcapi web3,eth,debug,personal,net --vmdebug --datadir ./FirstEthBlockchain console --dev console`

#### start mining 
in geth console:

`miner.start()`
 
#### Cli 

cli is same binary
`./geth attach http://127.0.0.1:8545`

Example:

unlock account:
`web3.personal.unlockAccount('0x3b07948f3DDA04BC8040b139AC06a68CE28301F2', '')`

transfer:
`web3.eth.sendTransaction({
    from: "0x3b07948f3dda04bc8040b139ac06a68ce28301f2",
    to: "0x5E77e1FfBdC797bE8FAb84144C0e79C28593F712",
    value: web3.toWei(5, "ether")
})`


## Precondition for tests
	
Tests contain two private keys for "wallet" and "other" accounts.
These accounts must be created and have non-zero balance (for exclusion error "gas required exceeds allowance (0)").
For description private key this code may be used:
```	
   it('wallet', async () => {
	 const js_w = "{\"address\":\"3b07948f3dda04bc8040b139ac06a68ce28301f2\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"526621e3d63660ef12aca531f63a27da1ae3b0c985dee2ed5a83cb9ddbc7c0c1\",\"cipherparams\":{\"iv\":\"4d352cee67766e59cfadfcc5bea4030b\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"a072190a5e8342d633cd6ea2a17ce133b88498f4d2fbce4ae1e74cc0a8c5734d\"},\"mac\":\"35b65364d73d9463d4b36fc277d2ae34c767b5b3f1502245c8610183271f45e9\"},\"id\":\"7f465bb3-234b-4ea0-8552-bf335959d778\",\"version\":3}"
    
     const wallet = await Wallet.fromEncryptedJson(js_w, "password")
     console.log("Private Key: " + wallet.privateKey)
     console.log("Address: " + wallet.address)
   })```
