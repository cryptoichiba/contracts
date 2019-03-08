pragma solidity ^0.4.18;
import '../utility/interfaces/IOwned.sol';

/**
* Financie Internal Bank interface
*/
contract IFinancieInternalBank is IOwned {
    function transferTokens(address _tokenAddress, address _to, uint256 _amount) public;
    function transferCurrencyTokens(address _to, uint256 _amount) public;
    function setBalanceOfToken(address _tokenAddress, uint32 _userId, uint256 _amount) public;
    function getBalanceOfToken(address _tokenAddress, uint32 _userId) public view returns(uint256);
    function setBalanceOfConsumableCurrencyToken(uint32 _userId, uint256 _amount) public;
    function getBalanceOfConsumableCurrencyToken(uint32 _userId) public view returns(uint256);
    function setBalanceOfWithdrawableCurrencyToken(uint32 _userId, uint256 _amount) public;
    function getBalanceOfWithdrawableCurrencyToken(uint32 _userId) public view returns(uint256);
    function setBalanceOfPendingRevenueCurrencyToken(uint32 _userId, uint256 _amount, uint32 _pendingRevenueType) public;
    function getBalanceOfPendingRevenueCurrencyToken(uint32 _userId, uint32 _pendingRevenueType) public view returns(uint256);
    function setHolderOfToken(address _tokenAddress, uint32 _userId, bool _flg) public;
    function getHolderOfToken(address _tokenAddress, uint32 _userId) public view returns(bool);
    function setBidsOfAuctions(address _auctionAddress, uint32 _userId, uint256 _amount) public;
    function getBidsOfAuctions(address _auctionAddress, uint32 _userId) public view returns(uint256);
    function setTotalBidsOfAuctions(address _auctionAddress, uint256 _amount) public ;
    function getTotalBidsOfAuctions(address _auctionAddress) public view returns(uint256);
    function setRecvCardsOfAuctions(address _auctionAddress, uint256 _amount) public;
    function getRecvCardsOfAuctions(address _auctionAddress) public view returns(uint256);
}
