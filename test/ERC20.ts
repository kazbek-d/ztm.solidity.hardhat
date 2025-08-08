import { ethers } from "hardhat";
import { expect } from "chai";

describe("ERC20", function () {
    it("transfers tokens correctly", async function () {
        const [bob, alice] = await ethers.getSigners();

        const ERC20 = await ethers.getContractFactory("ERC20Mock");
        const erc20Token = (await ERC20.deploy("Name", "SYM", 18)).connect(alice);

        await erc20Token.mint(alice.address, 300);

        console.log("Alice balance before transfer is", await erc20Token.balancesOf(alice.address));
        console.log("Bob balance before transfer is", await erc20Token.balancesOf(bob.address));

        await erc20Token.transfer(bob.address, 100);

        const aliceBalance = await erc20Token.balancesOf(alice.address);
        const bobBalance = await erc20Token.balancesOf(bob.address);

        expect(aliceBalance).to.equals(200);
        expect(bobBalance).to.equals(100);
    });
});