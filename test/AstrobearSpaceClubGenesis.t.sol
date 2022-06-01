// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "../lib/forge-std/src/Test.sol";
import "../src/AstrobearSpaceClubGenesis.sol";
import {Utils} from "./utils/Utils.sol";

contract AstrobearSpaceClubGenesisTest is Test {
    Utils utils;
    AstrobearSpaceClubGenesis nftContract;
    address[] airdropUsers;

    function setUp() public {
        nftContract = new AstrobearSpaceClubGenesis("Astrobear Space Club Genesis", "ASCG", "ipfs://QmbUQHnXWgSgpPke6gcQaqvp2z6yeaHzZRvza7cQ2CiViC/");
        utils = new Utils();
        airdropUsers = utils.createUsers(200);
    }

    function testSingleMint() public {
        address[] memory _addresses = new address[](1);
        _addresses[0] = address(airdropUsers[0]);

        nftContract.mint(_addresses);
        assertEq(uint256(1), nftContract.balanceOf(_addresses[0]));
    }

    function testMintFromNotOwnerWallet() public {
        address[] memory _addresses = new address[](1);
        _addresses[0] = address(airdropUsers[0]);

        vm.prank(address(0));
        vm.expectRevert(abi.encodeWithSignature("NotOwner()"));
        nftContract.mint(_addresses);
    }

    function testSetOwnerFromNotOwnerWallet() public {
        vm.prank(address(0));
        vm.expectRevert(abi.encodeWithSignature("NotOwner()"));
        nftContract.setOwner(address(0));
    }

    function testSetBaseUriFromNotOwnerWallet() public {
        vm.prank(address(0));
        vm.expectRevert(abi.encodeWithSignature("NotOwner()"));
        nftContract.setBaseUri("ipfs://QmbUQHnXWgSgpPke6gcQaqvp2z6yeaHzZRvza7cQ2CiViC/");
    }

    function testSetBaseUri() public {
        nftContract.setBaseUri("ipfs://QmbUQHnXWgSgpPke6gcQaqdddd6yeaHzZRvza7cQ2CiViC/");
        assertEq("ipfs://QmbUQHnXWgSgpPke6gcQaqdddd6yeaHzZRvza7cQ2CiViC/1", nftContract.tokenURI(1));
    }

    function testTokenUri() public {
        assertEq("ipfs://QmbUQHnXWgSgpPke6gcQaqvp2z6yeaHzZRvza7cQ2CiViC/1", nftContract.tokenURI(1));
    }

    function testBatchMint() public {
        uint256 gasStart = gasleft();
        nftContract.mint(airdropUsers);
        console.log("Gaslimit per mint", (gasStart - gasleft()) / airdropUsers.length);
        console.log("addresses", airdropUsers.length);
    }
}
