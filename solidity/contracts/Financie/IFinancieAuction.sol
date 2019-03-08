pragma solidity ^0.4.17;

contract IFinancieAuction {
    function bidToken(address _bidder, uint256 _amount) public returns (uint256, uint256, uint256);
    function estimateClaimTokens(address receiver_address) public view returns (uint256);
    function proxyClaimTokens(address receiver_address) public returns (bool);
    function canClaimTokens(address receiver_address) public view returns (bool);
    function auctionFinished() public view returns (bool);
    function missingFundsToEndAuction() constant public returns (uint);
    function price() public constant returns (uint);
    function finalPrice() public constant returns (uint);
    function tokenMultiplier() public constant returns (uint);
    function bidsAmount(address _bidder) public constant returns (uint);
    function targetToken() public view returns (address);
}
