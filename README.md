# Hardhat Project

This project was generated using [Hardhat](https://hardhat.org/).

It includes a sample project to help you get started with compiling, testing, and deploying your smart contracts.

## Available Tasks

- `npx hardhat compile` – Compiles the smart contracts.
- `npx hardhat test` – Runs the tests.
- `npx hardhat node` – Starts a local Ethereum node for development.
- `npx hardhat clean` – Removes the cache and artifacts.
- `npx hardhat run <script>` – Executes a script with the Hardhat Runtime Environment.
- `npx hardhat console` – Opens an interactive JavaScript console with the Hardhat environment.
- `npx hardhat help` – Displays the help message with a list of available tasks.

For more information, please refer to the [Hardhat Documentation](https://hardhat.org/getting-started/).



### bash history
```shell
$ touch ~/.zshrc
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
$ source /Users/anzhela/.zshrc
$ nvm install 22
$ nvm use 22
$ nvm alias default 22
$ npm install npm --global
$ clear
$ node --version
$ npm --version
$ npm init --yes
$ npm install hardhat@latest
$ npm install --global hardhat-shorthand
$ npm install dotenv
$ npx hardhat
$ npx hardhat help
$ npx hardhat test
$ hh compile
$ hh test
$ hh run scripts/deploy.ts
$ hh run scripts/deploy.ts --network sepolia
> ERC20 deployed to  0x94Eb7eeEA5Ccc7020DCF7B36415f51e8DA9c5DB1
$ hh verify --network sepolia 0x94Eb7eeEA5Ccc7020DCF7B36415f51e8DA9c5DB1 Name SYM 18
> [INFO] Sourcify Verification Skipped: Sourcify verification is currently disabled. To enable it, add the following entry to your > > > Hardhat configuration:
> sourcify: {
>   enabled: true
> }
> Or set 'enabled' to false to hide this message.
> For more information, visit https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify#verifying-on-sourcify
> Successfully submitted source code for contract
> contracts/ERC20.sol:ERC20 at 0x94Eb7eeEA5Ccc7020DCF7B36415f51e8DA9c5DB1
> for verification on the block explorer. Waiting for verification result...
> Successfully verified contract ERC20 on the block explorer.
> https://sepolia.etherscan.io/address/0x94Eb7eeEA5Ccc7020DCF7B36415f51e8DA9c5DB1#code
$ npm install @nomicfoundation/hardhat-foundry
$ hh init-foundry
$ forge test -vv
$ hh test
```

