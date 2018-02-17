pragma solidity ^0.4.18;

contract KingOfEther {
    address private currentKing;
    uint private currentPrice = 0;

    function offerForThrone() external payable returns (bool)
    {
        require(msg.value > currentPrice);
        currentKing = msg.sender;
    }

    function getCurrentKing() public view returns (address)
    {
        return currentKing;
    }
}