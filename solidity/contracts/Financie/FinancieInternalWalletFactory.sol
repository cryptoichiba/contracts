pragma solidity ^0.4.18;
import './FinancieInternalWallet.sol';
import './IFinancieInternalWalletFactory.sol';

contract FinancieInternalWalletFactory is IFinancieInternalWalletFactory {

    event NewWallet(address indexed _walletAddress, address indexed _owner);
    /**
        @dev constructor
    */
    constructor() public{}

    function createInternalWallet(
        address _teamWallet,
        address _managedContracts,
        address _platformToken,
        address _currencyToken,
        address _walletdata
    ) public returns(address) {
        FinancieInternalWallet intwallet = new FinancieInternalWallet(
            _teamWallet,
            _managedContracts,
            _platformToken,
            _currencyToken
        );

        intwallet.transferOwnership(msg.sender);

        address _walletAddress = address(intwallet);
        emit NewWallet(_walletAddress, msg.sender);

        return _walletAddress;
    }
}
