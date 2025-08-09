import { ethers } from "hardhat";
import { expect } from "chai";

describe("ERC20", function () {
    it("transfers tokens correctly", async function () {
        const [alice, bob] = await ethers.getSigners();

        const ERC20 = await ethers.getContractFactory("ERC20Mock");
        const erc20Token = (await ERC20.deploy("Name", "SYM", 18));

        await erc20Token.mint(alice.address, 300);

        let aliceBalance = await erc20Token.balancesOf(alice.address);
        let bobBalance = await erc20Token.balancesOf(bob.address);

        console.log("Alice balance before transfer is", aliceBalance);
        console.log("Bob balance before transfer is", bobBalance);

        await erc20Token.transfer(bob.address, 100);
        aliceBalance = await erc20Token.balancesOf(alice.address);
        bobBalance = await erc20Token.balancesOf(bob.address);
        expect(aliceBalance).to.equals(200);
        expect(bobBalance).to.equals(100);

        await erc20Token.connect(bob).transfer(alice.address, 50);
        aliceBalance = await erc20Token.balancesOf(alice.address);
        bobBalance = await erc20Token.balancesOf(bob.address);
        expect(aliceBalance).to.equals(250);
        expect(bobBalance).to.equals(50);
    });
});