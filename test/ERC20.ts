import { ethers } from "hardhat";

describe("ERC20", function () {
    it("transfers tokens correctly", async function () {
        const [bob, alice] = await ethers.getSigners();

        const ERC20 = await ethers.getContractFactory("ERC20");
        const erc20Token = await ERC20.deploy("Name", "SYM", 18);

        await erc20Token.transfer(bob.address, 100);
    });
});