// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/AstrobearSpaceClubGenesis.sol";
import {Utils} from "./utils/Utils.sol";

contract AstrobearSpaceClubGenesisTest is Test {
    Utils utils;
    AstrobearSpaceClubGenesis nftContract;
    address[] airdropUsers;

    address[] addresses;
    uint256[] tokenIds;

    function setUp() public {
        nftContract = new AstrobearSpaceClubGenesis("Astrobear Space Club Genesis", "ASCG", "ipfs://");
        utils = new Utils();
        airdropUsers = utils.createUsers(200);

        uint256 nonce = 0;
        uint256 maxTokens = 3;
        uint256 tokenIdOffset = 0;

        for (uint i=0; i<airdropUsers.length; i++) {
            // generate random number between 0-10
            uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, airdropUsers[i], nonce))) % maxTokens;
            randomNumber += 1;
            nonce++;

            uint256[] memory randomNumbers = new uint256[](randomNumber);

            for(uint256 ii; ii < randomNumber; ii++){
                randomNumbers[ii] = ii + tokenIdOffset;
            }

            tokenIdOffset += randomNumber;

            for (uint iii=0; iii<randomNumbers.length; iii++) {
                addresses.push(airdropUsers[i]);
                tokenIds.push(randomNumbers[iii]);
            }
        }
    }

    function testSingleMint() public {
        uint256[] memory _tokenIds = new uint256[](1);
        _tokenIds[0] = uint256(111);
        address[] memory _addresses = new address[](1);
        _addresses[0] = address(airdropUsers[0]);

        nftContract.mint(_addresses, _tokenIds);
        assertEq(uint256(1), nftContract.balanceOf(_addresses[0]));
    }

    function testMintFromNotOwnerWallet() public {
        uint256[] memory _tokenIds = new uint256[](1);
        _tokenIds[0] = uint256(111);
        address[] memory _addresses = new address[](1);
        _addresses[0] = address(airdropUsers[0]);

        vm.prank(address(0));
        vm.expectRevert(abi.encodeWithSignature("NotOwner()"));
        nftContract.mint(_addresses, _tokenIds);
    }

    function testSetOwnerFromNotOwnerWallet() public {
        vm.prank(address(0));
        vm.expectRevert(abi.encodeWithSignature("NotOwner()"));
        nftContract.setOwner(address(0));
    }

    function testTokenUri() public {
        nftContract.tokenURI(1);
    }

    function testBatchMint() public {
        uint256 gasStart = gasleft();
        nftContract.mint(addresses, tokenIds);
        console.log("Gaslimit per mint", (gasStart - gasleft()) / tokenIds.length);
        console.log("tokens", tokenIds.length);
    }
}
