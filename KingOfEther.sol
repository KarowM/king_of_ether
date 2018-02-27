pragma solidity ^0.4.20;

contract KingOfEther {
    address private currentKing;
    string private currentKingName;
    uint private currentPrice = 0;
    mapping (address => string) private kingNames;

    uint constant roundDuration = 15 seconds;
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
        return currentKingName;
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
        currentKingName = kingNames[highestBidder];
        currentPrice = highestBid;
    }

    function setNewHighestBidder(address bidder, uint bid, string kingName) private
    {
        highestBidder = bidder;
        highestBid = bid;
        kingNames[bidder] = kingName;
    }

    function startNewRound() private
    {
        roundEnd = now + roundDuration;
    }

    function withdraw() public returns (bool)
    {
        uint refundSum = pendingRefunds[msg.sender];
        if (refundSum > 0)
        {
            pendingRefunds[msg.sender] = 0;

            if (msg.sender.send(refundSum))
            {
                pendingRefunds[msg.sender] = refundSum;
                return false;
            }
        }
        return true;
    }
}