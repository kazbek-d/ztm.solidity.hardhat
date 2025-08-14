import { ethers } from "hardhat";

async function main() {
    const ERC20 = await ethers.getContractFactory("ERC20");
    const erc20 = await ERC20.deploy("Name", "SYM", 18);

    const address = await erc20.getAddress();
    console.log("ERC20 deployed to ", address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});