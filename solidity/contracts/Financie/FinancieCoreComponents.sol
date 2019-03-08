pragma solidity ^0.4.18;
import './IFinancieManagedContracts.sol';
import '../token/interfaces/IERC20Token.sol';
import '../utility/Owned.sol';

contract FinancieCoreComponents is Owned {

    IFinancieManagedContracts public managedContracts;

    IERC20Token public platformToken;
    IERC20Token public currencyToken;
    address tradeOperator;
    address fundOperator;

    constructor(
        address _managedContracts,
        address _platformToken,
        address _currencyToken
    ) public {
        managedContracts = IFinancieManagedContracts(_managedContracts);
        platformToken = IERC20Token(_platformToken);
        currencyToken = IERC20Token(_currencyToken);
    }

    modifier validTargetContract(address _contract) {
        require(managedContracts.validTargetContract(_contract));
        _;
    }

    modifier validOperator(address _sender) {
        require(_sender == owner ||
          _sender == tradeOperator ||
          _sender == fundOperator ||
          managedContracts.validTargetContract(_sender));
        _;
    }

    /**
    * work around for avoiding 'stack too deep' issue
    */
    function isValidOperator(address _sender)
        internal
        validOperator(_sender)
    {
    }

    function setOperators(address _tradeOperator, address _fundOperator)
        public
        ownerOnly
    {
        tradeOperator = _tradeOperator;
        fundOperator = _fundOperator;
    }

}
