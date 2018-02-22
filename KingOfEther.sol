pragma solidity ^0.4.20;

contract KingOfEther {
    address private currentKing;
    uint private currentPrice = 0;
    mapping (address => string) private kingNames;

    event OfferLog (
        address sender,
        uint value
    );

    function offerForThrone(string name) external payable returns (bool)
    {
        OfferLog(msg.sender, msg.value);
        require (currentPrice < msg.value);

        setNewKing(msg.value, msg.sender, name);
        return true;
    }

    function getCurrentKing() public view returns (string)
    {
        return kingNames[currentKing];
    }

    function getCurrentPrice() public view returns (uint)
    {
        return currentPrice;
    }

    function setNewKing(uint offering, address newKing, string newKingName) private
    {
        currentPrice = offering;
        currentKing.transfer(offering - currentPrice);
        currentKing = newKing;
        kingNames[newKing] = newKingName;
    }
}