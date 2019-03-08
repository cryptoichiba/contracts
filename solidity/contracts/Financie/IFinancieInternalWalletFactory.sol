pragma solidity ^0.4.18;

/*
    InternalWallet Factory interface
*/
contract IFinancieInternalWalletFactory {
    function createInternalWallet(
        address _teamWallet,
        address _managedContracts,
        address _platformToken,
        address _currencyToken,
        address _walletdata
    ) public returns (address);
}
