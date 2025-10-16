import * as dotenv from 'dotenv';
dotenv.config();

import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';

const ALCHEMY_URL = process.env.ALCHEMY_URL || '';
const PK = process.env.PRIVATE_KEY ? '0x' + process.env.PRIVATE_KEY : undefined;

const config: HardhatUserConfig = {
  solidity: { version: '0.8.24', settings: { optimizer: { enabled: true, runs: 200 } } },
  networks: {
    sepolia: {
      url: ALCHEMY_URL,
      chainId: 11155111,
      accounts: PK ? [PK] : []
    }
  }
};
export default config;
