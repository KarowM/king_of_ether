pragma solidity ^0.4.20;

contract KingOfEther {
    address private king;
    string private kingName;
    uint private kingPrice = 0;
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
            if (hasRoundEnded())
            {
                setNewKing();
                startNewRound();
            }
            else
            {
                pendingRefunds[highestBidder] += highestBid;
            }
            setNewHighestBidder(msg.sender, msg.value, name);
        }
    }

    function getKing() public view returns (string)
    {
        return kingName;
    }

    function getKingPrice() public view returns (uint)
    {
        return kingPrice;
    }

    function hasRoundEnded() public returns (bool)
    {
        if (now > roundEnd)
        {
            setNewKing();
            return true;
        }
        return false;
    }

    function getHighestBidder() public view returns (uint)
    {
        return highestBid;
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

    function startNewRound() private
    {
        roundEnd = now + roundDuration;
    }

    function setNewKing() private
    {
        pendingRefunds[king] += (highestBid - kingPrice);
        king = highestBidder;
        kingName = kingNames[highestBidder];
        kingPrice = highestBid;
    }

    function setNewHighestBidder(address bidder, uint bid, string bidderKingName) private
    {
        highestBidder = bidder;
        highestBid = bid;
        kingNames[bidder] = bidderKingName;
    }
}