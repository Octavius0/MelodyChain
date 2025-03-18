// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MelodyNFT is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct MusicTrack {
        string title;
        string artist;
        string genre;
        uint256 duration; // in seconds
        uint256 price;
        uint256 royaltyPercentage; // basis points (1000 = 10%)
        address payable creator;
        bool forSale;
    }

    mapping(uint256 => MusicTrack) public musicTracks;
    mapping(address => uint256[]) public creatorTracks;

    event TrackMinted(
        uint256 indexed tokenId,
        address indexed creator,
        string title,
        uint256 price
    );

    event TrackSold(
        uint256 indexed tokenId,
        address indexed seller,
        address indexed buyer,
        uint256 price
    );

    constructor() ERC721("MelodyChain", "MELODY") {}

    function mintTrack(
        string memory _tokenURI,
        string memory _title,
        string memory _artist,
        string memory _genre,
        uint256 _duration,
        uint256 _price,
        uint256 _royaltyPercentage
    ) public returns (uint256) {
        require(_royaltyPercentage <= 5000, "Royalty too high"); // max 50%

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        musicTracks[tokenId] = MusicTrack({
            title: _title,
            artist: _artist,
            genre: _genre,
            duration: _duration,
            price: _price,
            royaltyPercentage: _royaltyPercentage,
            creator: payable(msg.sender),
            forSale: true
        });

        creatorTracks[msg.sender].push(tokenId);

        emit TrackMinted(tokenId, msg.sender, _title, _price);

        return tokenId;
    }

    function getTrack(uint256 _tokenId) public view returns (MusicTrack memory) {
        require(_exists(_tokenId), "Track does not exist");
        return musicTracks[_tokenId];
    }

    function getCreatorTracks(address _creator) public view returns (uint256[] memory) {
        return creatorTracks[_creator];
    }

    // Override required by Solidity
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}