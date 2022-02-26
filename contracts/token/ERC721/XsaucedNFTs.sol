// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract XsaucedNFTs is AccessControl, ERC721Enumerable, ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter _NFTTracker;
    bytes32 private XSAUCED_ADMIN;

    mapping(uint256 => TokenMetadata) private XsaucedTokens;

    struct TokenMetadata {
        uint256 id;
        string uri;
    }

    event Mint(uint256 id);
    event Burn(uint256 id);

    constructor(
        string memory roleHash, // WKex2z4WE3en9vgRbvZy6T6EwSDZrp - hash:
        string memory name, // Xsauced Invite NFT Marketplace
        string memory abr, // XSAUCDNFT
        address[] memory admins
    ) ERC721(name, abr) {
        XSAUCED_ADMIN = keccak256(abi.encodePacked(roleHash));
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(XSAUCED_ADMIN, msg.sender);
        setupAdmins(admins, XSAUCED_ADMIN);
    }

    function setupAdmins(address[] memory admins, bytes32 adminHash) private returns (bool[] memory) {
     bool[] memory success = new bool[](admins.length);
        for (uint256 i = 0; i < admins.length; i++) {
            success[i] = _setupRole(adminHash, admins[i]);
        }
        return success;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getAllOnSale()
        public
        view
        virtual
        returns (TokenMetadata[] memory)
    {
        TokenMetadata[] memory tokensOnSale = new TokenMetadata[](
            totalSupply()
        );
        uint256 j = 0;
        for (uint256 i = 0; i < totalSupply(); i++) {
            if (XsaucedTokens[tokenByIndex(i)].sale == true) {
                tokensOnSale[j] = XsaucedTokens[tokenByIndex(i)];
                j++;
            }
        }
        return tokensOnSale;
    }

    function getOwnedTokens(address user)
        public
        view
        returns (TokenMetadata[] memory)
    {
        TokenMetadata[] memory owned = new TokenMetadata[](balanceOf(user));
        for (uint256 i = 0; i < balanceOf(user); i++) {
            owned[i] = XsaucedTokens[tokenOfOwnerByIndex(user, i)];
        }
        return owned;
    }


    /**
     * @dev sets token meta
     * @param _tokenId uint256 token ID (token number)
     * @param _meta TokenMetadata
     *
     * Requirements:
     * `tokenId` must exist
     * `owner` must the msg.owner
     */
    function _setTokenMetadata(uint256 _tokenId, TokenMetadata memory _meta)
        private
    {
        require(_exists(_tokenId), "Token Does Not Exist!");
        require(
            hasRole(XSAUCED_ADMIN, msg.sender),
            "You do not have permission to set NFT metadata!"
        );
        XsaucedTokens[_tokenId] = _meta;
    }

    function getTokenMetadata(uint256 _tokenId)
        public
        view
        returns (TokenMetadata memory)
    {
        require(_exists(_tokenId), "Token Does Not Exist!");
        return XsaucedTokens[_tokenId];
    }

    function mintCollectable(
        address _owner,
        string memory _tokenURI,
        string memory _name,
        uint256 _price,
        bool _sale
    ) public returns (uint256) {
        require(
            hasRole(XSAUCED_ADMIN, msg.sender),
            "You do not have permission to mint XsaucedTokens!"
        );
        require(_price > 0, "NFT Price Cannot Be 0!");
        _NFTTracker.increment();
        uint256 newItemId = _NFTTracker.current();
        _mint(_owner, newItemId);
        TokenMetadata memory meta = TokenMetadata(
            newItemId,
            _price,
            address(0),
            _name,
            _tokenURI,
            _sale
        );
        _setTokenMetadata(newItemId, meta);
        if (msg.sender != owner()) {
            safeTransferFrom(msg.sender, owner(), newItemId);
        }
        emit Mint(newItemId);
        return newItemId;
    }

    function burnCollectable(uint256 _tokenId) external {
        require(_exists(_tokenId), "Token Does Not Exist!");
        require(
            hasRole(XSAUCED_ADMIN, msg.sender),
            "You do not have permission to burn XsaucedTokens!"
        );
        require(
            XsaucedTokens[_tokenId].currentBidder == address(0),
            "Can Not Burn During Active Bidding!"
        );
        _burn(_tokenId);
        emit Burn(_tokenId);
    }
}
