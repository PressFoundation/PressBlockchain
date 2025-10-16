# Press Blockchain B1

Fully wired Hardhat contracts + WordPress plugins + Bot apps scaffolding.
Prefilled for **Sepolia**.

## Quick start (contracts)
```bash
npm i
cp .env.example .env   # fill PRIVATE_KEY
npx hardhat compile
npx hardhat test
npx hardhat run scripts/deploy.ts --network sepolia
```
Outputs deployment addresses to `deployments/sepolia.json`.

## Packages
- `contracts/` — Solidity sources (PRESS, ArticleRegistry, Governor, Treasury, NFTLoanManager)
- `scripts/` — Hardhat deploy/verify
- `packages/wp-newsroom/` — Press Blockchain Newsroom (WordPress)
- `packages/wp-sync-admin/` — Press Blockchain Admin (SYNC) with progress bars
- `apps/press-bot/` — Bot Hosting Kit
- `apps/press-bot-suite/` — MEE6-style bot suite

## Networks
Sepolia RPC and your contract addresses are set in `.env.example` and `hardhat.config.ts`.
