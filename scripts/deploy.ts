import { ethers } from 'hardhat';
import * as fs from 'fs';
import * as path from 'path';

const OUT = path.join('deployments', 'sepolia.json');

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deployer:', deployer.address);

  const PRESS = await ethers.getContractFactory('PRESS');
  const press = await PRESS.deploy(deployer.address);
  await press.deployed();

  const Registry = await ethers.getContractFactory('ArticleRegistry');
  const registry = await Registry.deploy();
  await registry.deployed();

  const Treasury = await ethers.getContractFactory('Treasury');
  const treasury = await Treasury.deploy();
  await treasury.deployed();

  const Governor = await ethers.getContractFactory('GovernorSimple');
  const governor = await Governor.deploy(deployer.address, 3000); // ~ 10 min @ 2s blocks
  await governor.deployed();

  const Loan = await ethers.getContractFactory('NFTLoanManager');
  const loan = await Loan.deploy();
  await loan.deployed();

  const result = {
    network: 'sepolia',
    press: press.address,
    articleRegistry: registry.address,
    treasury: treasury.address,
    governor: governor.address,
    nftLoanManager: loan.address
  };
  fs.mkdirSync('deployments', { recursive: true });
  fs.writeFileSync(OUT, JSON.stringify(result, null, 2));
  console.log('Deployed:', result);
}

main().catch((e) => { console.error(e); process.exit(1); });
