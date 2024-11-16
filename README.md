# CuriosChallenge Smart Contract

This repository contains the **CuriosChallenge** and **Groth16Verifier** smart contracts, along with a Hardhat-based development setup. The CuriosChallenge contract enables the creation of challenges, prize distribution, and proof verification using zk-SNARKs.

---

## Features

- **Groth16Verifier**: 
  - Verifies zk-SNARK proofs. 
  - [Verifier contract deployed on Zircuit testnet](https://explorer.testnet.zircuit.com/address/0x201B30C1B71E3Dcf61bE22D04166A854203c6E90?activeTab=3)
- **CuriosChallenge**:
  - Allows users to create challenges with prize pools.
  - Supports Merkle tree roots for secure participant verification.
  - Implements prize claiming with zk-SNARK proof verification.
  - Admin tools for invalidating challenges.
  - [CuriosChallenge contract deployed on Zircuit testnet](https://explorer.testnet.zircuit.com/address/0xBcF2EbE34681ea0a0F7D93E3326EBB9a16a5C35C)

---

## Prerequisites

- [Node.js](https://nodejs.org/) v16 or later
- [Hardhat](https://hardhat.org/)
- A Zircuit-compatible wallet and API key

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/CuriosChallenge.git
   cd CuriosChallenge
   ```

Install dependencies:

bash
```bash
npm install
```

Set up your .env file with the following variables:
```bash
PRIVATE_KEY=your_private_key_here
ZIRCUIT_API_KEY=your_zircuit_api_key_here
```

## Directory Structure
- **contracts/**: Contains the Solidity smart contracts.
- **scripts/**: Deployment scripts for the contracts.
- **test/**: Mocha/Chai tests for the contracts.
- **circom/**: zk-SNARK circuits and related files.
- **artifacts/**: Generated files for compiled contracts (excluded from Git).
- **build/**: Generated zk-SNARK files (excluded from Git).

## zk-SNARK Integration
This project uses a zk-SNARK setup with Groth16. Steps for generating zk-SNARK proofs are included in the circom/ folder.

## Resources
- [Hardhat Documentation](https://hardhat.org/docs)
- [Circom Documentation](https://docs.circom.io/)
- [Zircuit Documentation](https://docs.zircuit.com/)
