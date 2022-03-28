# Setup
add your key to secrets.json
# yarn init
yarn install
yarn build

# arkon-solidity-template
Arkon chain soilidity hardhat template development 

Setting in hardhat.config

Arkon chain testnet
http://arkscan-testnet.arkon.network:4000/
http://rpc-testnet.arkon.network:8545/
Chain:8888
Symbol:KON

http://faucet-testnet.arkon.network:3000/


# to custom etherscan library for validating contracts

node_modules/@nomiclabs/hardhat-etherscan/dist/disc/ChainConfig.js
//add this config below up

arkonbeta: {

        chainId: 8888,
        
        urls: {
        
            apiURL: "http://arkscan-testnet.arkon.network:4000/api",
            
            browserURL: "http://arkscan-testnet.arkon.network:4000",
            
        },
        
    },
    
    
 node_modules/@nomiclabs/hardhat-etherscan/dist/disc/types.d.ts
//add this config below up

 | "arkonbeta"
    
 
