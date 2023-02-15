pragma solidity ^0.8.0;

contract ReverseDutchAuction {
    address payable public seller;
    uint public initialPrice;
    uint public biddingDuration;
    uint public minimumPrice;
    uint public currentPrice;
    bool public auctionEnded;
    mapping(address => uint) public bids;
    
    event BidPlaced(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    
    constructor(uint _initialPrice, uint _biddingDuration, uint _minimumPrice) {
        seller = payable(msg.sender);
        initialPrice = _initialPrice;
        biddingDuration = _biddingDuration;
        minimumPrice = _minimumPrice;
        currentPrice = _initialPrice;
        auctionEnded = false;
    }
    
    function placeBid() public payable {
        require(!auctionEnded);
        require(block.timestamp < biddingDuration + block.timestamp);
        require(msg.value > bids[msg.sender]);
        require(msg.value >= currentPrice);
        
        bids[msg.sender] = msg.value;
        currentPrice = msg.value;
        emit BidPlaced(msg.sender, msg.value);
    }
    
    function endAuction() public {
        require(!auctionEnded);
        require(block.timestamp >= biddingDuration + block.timestamp);
        
        auctionEnded = true;
        if(currentPrice < minimumPrice){
            seller.transfer(address(this).balance);
            return;
        }
        seller.transfer(currentPrice);
        emit AuctionEnded(msg.sender, currentPrice);
    }
}
