# 📜 Micro-Payment Subscription Contract

A Clarity smart contract enabling decentralized, recurring micro-payments on the Stacks blockchain. This contract allows service providers to create subscription plans, and users to subscribe using STX for periodic payments based on block height intervals.

---

## 🚀 Features

- **Subscription Plan Management**  
  Service providers can create and manage subscription plans with custom prices and billing intervals.

- **User Subscriptions**  
  Users can subscribe to available plans and authorize recurring STX payments.

- **Recurring Payments**  
  Payments are triggered at defined block intervals, enabling a basic automated billing system.

- **Transparency & Security**  
  All state changes are on-chain, auditable, and enforce access control for plan owners.

---

## 🛠️ Functions Overview

| Function              | Description                                                   |
|-----------------------|---------------------------------------------------------------|
| `create-plan`         | Create a new subscription plan with defined terms             |
| `subscribe`           | Subscribe to a selected plan                                  |
| `process-payment`     | Trigger a recurring payment (can be automated off-chain)      |
| `cancel-subscription` | Cancel a subscription at any time                             |
| `get-plan-info`       | Retrieve information about a plan                             |
| `get-subscriber-info` | Get the current subscription status for a user                |

---

## 🧪 Usage & Deployment

### Requirements
- [Stacks CLI](https://docs.stacks.co/docs/cli)
- [Clarinet](https://docs.stacks.co/docs/clarity/clarinet-cli)
- Stacks testnet wallet

### Compile & Test

```bash
clarinet check
clarinet test
