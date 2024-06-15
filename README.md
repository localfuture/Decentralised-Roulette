# Decentralized Roulette Smart Contract

Decentralized Roulette is a blockchain-based version of the classic casino game roulette, designed to ensure fairness and transparency using Ethereum smart contracts. Players can bet on Even, Odd, or specific numbers, and winnings are distributed automatically based on the spin result.

## Features

- **Betting Options**: Players can bet on Even, Odd, or exact numbers (0-36).
- **Token System**: Tokens are used for betting, where 1 Ether equals 1000 ERC20 tokens.
- **Winning Payouts**: 
  - Betting on Even/Odd returns 180% of the bet amount on correct prediction.
  - Betting on a specific number returns 1900% of the bet amount on correct prediction.
- **Transparency**: All betting and spin results are publicly accessible on the blockchain.
- **Owner Controls**: Only the owner can initiate spins and manage results, ensuring no manipulation.

## Functions

### Player Functions

- `buyTokens() payable`: Allows players to purchase ERC20 tokens by sending Ether to the contract.
- `placeBetEven(uint betAmount)`: Allows players to bet tokens on the roulette landing on an even number.
- `placeBetOdd(uint betAmount)`: Allows players to bet tokens on the roulette landing on an odd number.
- `placeBetOnNumber(uint betAmount, uint number)`: Allows players to bet tokens on a specific number (0-36).
- `sellTokens(uint tokenAmount)`: Allows players to sell their tokens back to the contract in exchange for Ether.
- `checkBalance() returns (uint)`: Returns the balance of ERC20 tokens for the caller.

### Owner Functions

- `spinWheel()`: Simulates the spinning of the roulette wheel, generates a random number (0-36), and sets the spin result.
- `transferWinnings()`: Mints and transfers tokens to players who won bets based on the spin result.
- `setSpinWheelResult(uint key)`: Allows the owner to manually set the spin result for testing purposes.

### Query Functions

- `checkWinningNumber() returns (uint)`: Returns the winning number after the roulette wheel has been spun.
- `checkBetsOnEven() returns (address[], uint[])`: Returns addresses and bet amounts of players who bet on Even.
- `checkBetsOnOdd() returns (address[], uint[])`: Returns addresses and bet amounts of players who bet on Odd.
- `checkBetsOnDigit() returns (address[], uint[], uint[])`: Returns addresses, numbers, and bet amounts of players who bet on specific numbers.

## Usage

1. **Deploying the Contract**: Deploy the smart contract to an Ethereum blockchain (e.g., Rinkeby, Mainnet).
2. **Interacting with the Contract**: Use a web3-enabled wallet or a tool like Remix IDE to interact with the functions exposed by the contract.
3. **Buying Tokens**: Players buy tokens by sending Ether to the contract.
4. **Placing Bets**: Players can place bets on Even, Odd, or specific numbers using their tokens.
5. **Spinning the Wheel**: Only the owner can spin the wheel, which generates a random number.
6. **Winning and Payouts**: After spinning, the contract automatically calculates winnings and distributes tokens accordingly.
7. **Selling Tokens**: Players can sell their tokens back to the contract in exchange for Ether.

## Security and Considerations

- **Randomness**: Ensure the randomness of the spin results using a secure method.
- **Gas Fees**: Consider gas costs when interacting with the contract, especially during betting and payout phases.
- **Testing**: Thoroughly test the contract functionality and edge cases before deploying to ensure security and correctness.

## License

This smart contract is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.

