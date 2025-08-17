// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test, console2, StdStyle, StdCheats} from "forge-std/Test.sol";
import {ERC20} from "../contracts/ERC20.sol";

contract BaseSetup is ERC20, Test {
    address internal alice;
    address internal bob;

    constructor() ERC20("name", "SYM", 18) {}

    function setUp() public virtual {
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        console2.log(StdStyle.blue("When Alice has 300e18 Tokens"));
        _mint(alice, 300e18);

        // TODO: check why deal is not working
        //vm.deal(alice, 300e18);
        //deal(address(this), alice, 300e18);
    }
}

contract Erc20TransferTest is BaseSetup {
    function setUp() public override {
        BaseSetup.setUp();
    }

    function testTransferTokensCorrectly() public virtual {
        vm.prank(alice);
        bool success = this.transfer(bob, 100e18);
        assertTrue(success, "Transfer should succeed");
        assertEqDecimal(this.balancesOf(alice), 200e18, decimals);
        assertEqDecimal(this.balancesOf(bob), 100e18, decimals);
    }

    function testCannotTransforMoreThenBalance() public {
        vm.prank(alice);
        vm.expectRevert("ERC20: Insufficient sender balance");
        this.transfer(bob, 400e18);
    }

    function testEmitsTransferEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Transfer(alice, bob, 100e18);

        vm.prank(alice);
        this.transfer(bob, 100e18);
    }
}
