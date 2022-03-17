require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-ethers');
require('solidity-coverage');
require('@nomiclabs/hardhat-etherscan');
require('hardhat-spdx-license-identifier');
require('hardhat-gas-reporter');
require('hardhat-abi-exporter');
require('@openzeppelin/hardhat-upgrades')


const { removeConsoleLog } = require('hardhat-preprocessor');

const { mnemonic,privatekey, apikey,ethscankey } = require('./secrets.json');

task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});
module.exports = {
  
  solidity: {
    compilers: [
      {
        version: "0.8.4"
      },
      {
        version: "0.8.2"
      }
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 1
      }
     }
  },
  abiExporter: {
    path: './abi',
    clear: false,
    flat: true
  },
  defaultNetwork: 'hardhat',
  networks: {
    localhost: {
      url: 'http://127.0.0.1:8545'
    },
    hardhat: {
      initialBaseFeePerGas: 0
    },
    arkonbeta:{
      url: 'http://34.124.255.240:8545',
      chainId: 55,
      gasPrice: 20*1e8,
      gas:500000,
      minGasPrice:500000,
      accounts:[privatekey]
    },
    testnet: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545',
      chainId: 97,
      gasPrice: 20*1e9,
      gas:500000,
      minGasPrice:500000,
      //accounts: { mnemonic: mnemonic } 
      accounts:[privatekey]// testnet acc "419fc5cf3708b9ae0d7f0a1d2091b9cd262ce608f9de5db73ce480077bbd5b70"
    }
  },
  
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts'
  },
  mocha: {
    timeout: 20000
  },
  etherscan: {
    apiKey:  apikey
  },
  preprocess: {
    eachLine: removeConsoleLog((bre) => bre.network.name !== 'hardhat' && bre.network.name !== 'localhost'),
  },
  spdxLicenseIdentifier: {
    overwrite: false,
    runOnCompile: true
  },
  gasReporter: {
    coinmarketcap: '[deploy then input token adress]',
    currency: 'USD',
    enabled: true
  }
  
};
