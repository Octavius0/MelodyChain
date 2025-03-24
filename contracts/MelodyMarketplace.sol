// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./MelodyNFT.sol";

contract MelodyMarketplace is ReentrancyGuard {
    using Counters for Counters.Counter;

    MelodyNFT public melodyNFT;

    Counters.Counter private _saleIdCounter;

    uint256 public marketplaceFee = 250; // 2.5% in basis points
    address payable public feeRecipient;

    struct Sale {
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Sale) public sales; // saleId => Sale
    mapping(uint256 => uint256) public tokenToSale; // tokenId => saleId

    event TrackListed(
        uint256 indexed saleId,
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price
    );

    event TrackSold(
        uint256 indexed saleId,
        uint256 indexed tokenId,
        address indexed seller,
        address indexed buyer,
        uint256 price
    );

    event SaleCancelled(
        uint256 indexed saleId,
        uint256 indexed tokenId,
        address indexed seller
    );

    constructor(address _melodyNFT, address payable _feeRecipient) {
        melodyNFT = MelodyNFT(_melodyNFT);
        feeRecipient = _feeRecipient;
    }

    function listTrack(uint256 _tokenId, uint256 _price) external nonReentrant {
        require(melodyNFT.ownerOf(_tokenId) == msg.sender, "Not owner");
        require(_price > 0, "Price must be greater than 0");
        require(tokenToSale[_tokenId] == 0, "Already listed");

        // Transfer NFT to marketplace
        melodyNFT.transferFrom(msg.sender, address(this), _tokenId);

        uint256 saleId = _saleIdCounter.current();
        _saleIdCounter.increment();

        sales[saleId] = Sale({
            tokenId: _tokenId,
            seller: payable(msg.sender),
            price: _price,
            active: true
        });

        tokenToSale[_tokenId] = saleId;

        emit TrackListed(saleId, _tokenId, msg.sender, _price);
    }

    function buyTrack(uint256 _saleId) external payable nonReentrant {
        Sale storage sale = sales[_saleId];
        require(sale.active, "Sale not active");
        require(msg.value >= sale.price, "Insufficient payment");

        sale.active = false;
        tokenToSale[sale.tokenId] = 0;

        uint256 fee = (sale.price * marketplaceFee) / 10000;
        uint256 sellerAmount = sale.price - fee;

        // Get track info for royalty calculation
        MelodyNFT.MusicTrack memory track = melodyNFT.getTrack(sale.tokenId);
        uint256 royalty = (sale.price * track.royaltyPercentage) / 10000;

        // Adjust amounts if there's a royalty
        if (track.creator != sale.seller && royalty > 0) {
            sellerAmount -= royalty;
            track.creator.transfer(royalty);
        }

        // Transfer payments
        feeRecipient.transfer(fee);
        sale.seller.transfer(sellerAmount);

        // Transfer NFT to buyer
        melodyNFT.transferFrom(address(this), msg.sender, sale.tokenId);

        // Refund excess payment
        if (msg.value > sale.price) {
            payable(msg.sender).transfer(msg.value - sale.price);
        }

        emit TrackSold(_saleId, sale.tokenId, sale.seller, msg.sender, sale.price);
    }

    function cancelSale(uint256 _saleId) external nonReentrant {
        Sale storage sale = sales[_saleId];
        require(sale.seller == msg.sender, "Not seller");
        require(sale.active, "Sale not active");

        sale.active = false;
        tokenToSale[sale.tokenId] = 0;

        // Return NFT to seller
        melodyNFT.transferFrom(address(this), sale.seller, sale.tokenId);

        emit SaleCancelled(_saleId, sale.tokenId, msg.sender);
    }

    function getSale(uint256 _saleId) external view returns (Sale memory) {
        return sales[_saleId];
    }

    function getActiveSales() external view returns (uint256[] memory) {
        uint256 totalSales = _saleIdCounter.current();
        uint256 activeSalesCount = 0;

        // Count active sales
        for (uint256 i = 0; i < totalSales; i++) {
            if (sales[i].active) {
                activeSalesCount++;
            }
        }

        // Create array of active sale IDs
        uint256[] memory activeSales = new uint256[](activeSalesCount);
        uint256 index = 0;

        for (uint256 i = 0; i < totalSales; i++) {
            if (sales[i].active) {
                activeSales[index] = i;
                index++;
            }
        }

        return activeSales;
    }

    function updateMarketplaceFee(uint256 _newFee) external {
        require(msg.sender == feeRecipient, "Only fee recipient");
        require(_newFee <= 1000, "Fee too high"); // max 10%
        marketplaceFee = _newFee;
    }
}