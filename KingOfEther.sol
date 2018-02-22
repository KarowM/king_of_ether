pragma solidity ^0.4.20;

contract KingOfEther {
    address private currentKing;
    uint private currentPrice = 0;
    mapping (address => string) private kingNames;

    uint constant roundDuration = 10 seconds;
    uint private roundEnd;

    address private highestBidder;
    uint private highestBid;

    mapping (address => uint) private pendingRefunds;

    function offer(string name) external payable
    {
        require (highestBid < msg.value);
 
        if (highestBid == 0)
        {
            startNewRound();
            setNewHighestBidder(msg.sender, msg.value, name);
        }
        else
        {
            if (now < roundEnd)
            {
                pendingRefunds[highestBidder] += highestBid;
                setNewHighestBidder(msg.sender, msg.value, name);
            }
            else
            {
                setNewKing();
                startNewRound();
                setNewHighestBidder(msg.sender, msg.value, name);
            }
        }
    }

    function getCurrentKing() public view returns (string)
    {
        return kingNames[currentKing];
    }

    function getCurrentPrice() public view returns (uint)
    {
        return currentPrice;
    }

    function hasRoundEnded() public returns (bool)
    {
        if (now < roundEnd)
        {
            return false;
        }
        else
        {
            setNewKing();
            return true;
        }
    }

    function setNewKing() private
    {
        pendingRefunds[currentKing] += (highestBid - currentPrice);
        currentKing = highestBidder;
        currentPrice = highestBid;
    }

    function setNewHighestBidder(address bidderAddress, uint bid, string kingName) private
    {
        highestBidder = bidderAddress;
        highestBid = bid;
        kingNames[bidderAddress] = kingName;
    }

    function startNewRound() private
    {
        roundEnd = now + roundDuration;
    }
}