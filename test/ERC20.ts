import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("ERC20", function () {
    async function deployAndMockERC20() {
        const [alice, bob] = await ethers.getSigners();

        const ERC20 = await ethers.getContractFactory("ERC20Mock");
        const erc20Token = await ERC20.deploy("Name", "SYM", 18);

        await erc20Token.mint(alice.address, 300);

        return { alice, bob, erc20Token }
    }

    it("transfers tokens correctly", async function () {
        const { alice, bob, erc20Token } = await loadFixture(deployAndMockERC20);

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

    it("should revert if sender insuffisient balance", async function () {
        const { bob, erc20Token } = await loadFixture(deployAndMockERC20);

        await expect(erc20Token.transfer(bob.address, 400)).to.be.reverted;
        await expect(erc20Token.transfer(bob.address, 400)).to.be.revertedWith("ERC20: Insufficient sender balance");
    })

    it("should emit Transfer event on transfers", async function () {
        const { alice, bob, erc20Token } = await loadFixture(deployAndMockERC20);

        await expect(erc20Token.transfer(bob.address, 200))
            .to.emit(erc20Token, "Transfer")
            .withArgs(alice.address, bob.address, 200);
    })



});