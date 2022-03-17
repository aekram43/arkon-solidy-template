# yarn init
yarn install
yarn build

# arkon-solidity-template
Arkon chain soilidity hardhat template development 

Setting in hardhat.config

Arkon chain beta
rpc: http://34.124.255.240:8545

chainID: 55

blockexpleror :http://34.124.255.240:4000

faucet :http://34.124.255.240:3000


# to custom etherscan library for validating contracts

node_modules/@nomiclabs/hardhat-etherscan/dist/disc/ChainConfig.js
//add this config below up

arkonbeta: {

        chainId: 55,
        
        urls: {
        
            apiURL: "http://34.124.255.240:4000/api",
            
            browserURL: "http://34.124.255.240:4000",
            
        },
        
    },
    
    
 node_modules/@nomiclabs/hardhat-etherscan/dist/disc/types.d.ts
//add this config below up

 | "arkonbeta"
    
 
