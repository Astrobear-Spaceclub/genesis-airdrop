// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "../lib/solmate/src/tokens/ERC721.sol";

// @title Contract for Astrobear Spaceclub - Genesis Airdrop
// @author Kevin Mauel | What The Commit <https://what-the-commit.com>
contract AstrobearSpaceClubGenesis is ERC721 {
    error NotOwner();

    string public baseUri;
    address public owner;

    constructor(string memory _name, string memory _symbol, string memory _baseUri) ERC721(_name, _symbol) {
        baseUri = _baseUri;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();

        _;
    }

    function setOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function tokenURI(uint256) public view virtual override returns (string memory) {
        return baseUri;
    }

    function mint(address[] memory addresses, uint256[] memory tokenIds) external onlyOwner {
        unchecked {
            for (uint i=0; i<addresses.length; i++) {
                _mint(addresses[i], tokenIds[i]);
            }
        }
    }
}
