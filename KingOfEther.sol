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

        currentPrice = msg.value;
        currentKing.transfer(msg.value - currentPrice);
        currentKing = msg.sender;
        kingNames[msg.sender] = name;
        return true;
    }

    function getCurrentKing() public view returns (string)
    {
        return kingNames[currentKing];
    }
}