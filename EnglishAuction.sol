//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;


interface IERC721{
    function transferFrom(
        address from,
        address to,
        uint nftId) external;
    }
contract EnglishAuction{
    IERC721 public immutable nft;
    uint public immutable nftId;
    address public payable immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;
    //event Bid(address)

    constructor(
        address _nft;
        uint _nftId;
        uint _startingBid
    ){
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }
    function start() external{
        require(msg.sender == seller, "not seller");
        require(!started, "started");
        started = true;
        endAt = uint32(block.timestamp + 120);
        nft.transferFrom(seller, address(this), nftId);
    }
    function bid() external payable{
        require(started, "not started");
        require(block.timestamp < endAt, "endede");
        require(msg.value > highestBid, "Insufficient fund");
        if (highestBidder != address(0)){
        highestBid = msg.value;
        highestBidder = msg.sender;
        }
        bids[highestBidder] += highestBidder;
        }
    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;// to guard against a re-entrance attack;
        payable(msg.sender).transfer(bal);
    }
    function end() external{
        require(started, "not started");
        require(!endedm "ended");
        require (block.timestamp >= endAt, "not ended");
        ended = true;
        if(highestBidder != address(0)){
            nft.transferFrom(address(this), highestBidder, nftId):
        }else{
            nft.transferFrom(address(this), seller, nftId);
        }
    }
}
