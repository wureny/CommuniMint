# Minimal Proxy Inscription Token Project

## Overview
This project implements a fair-launch inscription token using the ERC20 standard and the Minimal Proxy pattern. It aims to create a decentralized and equitable token distribution mechanism while maintaining network activity through daily minting limits.

## Key Features
1. **ERC20 Compliance**: The token follows the ERC20 standard for widespread compatibility.
2. **Minimal Proxy Pattern**: Utilizes OpenZeppelin's Clones library to deploy cost-effective proxy contracts.
3. **Fair Launch**: Open minting mechanism allowing equal participation for all users.
4. **Daily Minting Limits**: Implements a maximum daily minting cap to ensure sustained network activity.
5. **Per-Account Minting Limit**: Each account is restricted to minting a configurable number of tokens (M).
6. **Total Supply Cap**: The total token supply is limited to a configurable amount (N).
7. **Lucky Address Feature**: Incorporates a daily-changing lucky address mechanism for bonus minting.

## Technical Specifications
- Solidity Version: ^0.8.19
- Framework: Foundry
- Dependencies: OpenZeppelin Contracts (Upgradeable)

## Smart Contract Architecture
1. **Implementation Contract**: Contains the core logic for the token, including minting rules and limits.
2. **Factory Contract**: Deploys new token instances using the Minimal Proxy pattern.

## Minting Rules
- Daily minting is capped at a predefined limit.
- Each account can mint up to M tokens in total.
- The total supply of tokens is capped at N.
- Lucky addresses can mint additional tokens each day.

## Lucky Address Feature
The lucky address mechanism adds an element of gamification:
- The criteria for lucky addresses change every fixed time.
- Lucky addresses are eligible to mint additional tokens beyond the standard limit.
- The implementation ensures fairness and prevents exploitation.

## Setup and Deployment
[Include instructions for setting up the project, running tests, and deploying contracts]

## Security Considerations
[Outline security measures, potential risks, and mitigation strategies]

## License
[Specify the license under which the project is released]

## Example Token Address
WoW token: 0xdF52B86D4438b2e06930054899A66086Ce5114EC
TokenFactory: 0x830a8d5F180D66a41FB1d819b7334f5026670eb8