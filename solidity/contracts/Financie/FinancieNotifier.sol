pragma solidity ^0.4.18;
import './IFinancieNotifier.sol';
import './FinancieCoreComponents.sol';
import '../utility/Utils.sol';

contract FinancieNotifier is IFinancieNotifier, FinancieCoreComponents, Utils {
    address latest;

    event ApproveNewCards(address indexed _card, uint _timestamp);
    event CardAuctionFinalized(address indexed _card, address indexed _auction, uint _timestamp);
    event ApproveNewBancor(address indexed _card, address indexed _bancor, uint _timestamp);

    event Log(address indexed _sender, address indexed _target, EventType indexed _eventType, address _from, address _to, uint256 _paidAmount, uint256 _receivedAmount, uint _timestamp);

    event AddOwnedCardList(address indexed _sender, address indexed _address, uint _timestamp);

    event ConvertCards(address indexed _sender, address indexed _from, address indexed _to, uint256 _amountFrom, uint256 _amountTo, uint _timestamp);
    event BidCards(address indexed _sender, address indexed _to, uint256 _amount, uint _timestamp);
    event WithdrawalCards(address indexed _sender, address indexed _to, uint256 _bids, uint256 _amount, uint _timestamp);
    event BurnCards(address indexed _sender, address indexed _card, uint256 _amount, uint _timestamp);

    event AuctionHeroRevenue(address _sender, address indexed _target, address indexed _card, uint32 indexed _receiver, uint256 _amount, uint _timestamp);
    event AuctionTeamRevenue(address _sender, address indexed _target, address indexed _card, uint256 _amount, uint _timestamp);
    event ExchangeHeroRevenue(address _sender, address indexed _target, address indexed _card, uint32 indexed _receiver, uint256 _amount, uint _timestamp);
    event ExchangeTeamRevenue(address _sender, address indexed _target, address indexed _card, uint256 _amount, uint _timestamp);

    constructor(address _managedContracts, address _platformToken, address _currencyToken)
        public
        FinancieCoreComponents(_managedContracts, _platformToken, _currencyToken)
    {
        latest = address(this);
    }

    /**
    *   @notice Set latest notifier
    */
    function setLatestNotifier(address _latest)
        public
        validOperator(msg.sender)
    {
        latest = _latest;
    }

    /**
    *   @notice returns latest notifier and update itself if expired
    */
    function latestNotifier()
        public
        returns (address)
    {
        // this contract is latest
        if ( latest == address(this) ) {
            return latest;
        }

        // up to date?
        address _latest = IFinancieNotifier(latest).latestNotifier();
        if ( latest == _latest ) {
            return latest;
        }

        // update and return
        latest = _latest;
        return latest;
    }

    /**
    *   @notice To prevent receiving ether
    */
    function() payable public {
        revert();
    }

    /**
    *
    */
    function notifyApproveNewCards(address _card)
        public
        validOperator(msg.sender)
    {
        emit ApproveNewCards(_card, now);
    }

    /**
    *
    */
    function notifyCardAuctionFinalized(address _card, address _auction)
        public
        validOperator(msg.sender)
    {
        emit CardAuctionFinalized(_card, _auction, now);
    }

    /**
    *
    */
    function notifyApproveNewBancor(address _card, address _bancor)
        public
        validOperator(msg.sender)
    {
        emit ApproveNewBancor(_card, _bancor, now);
    }

    function notifyConvertCards(
        address _sender,
        address _from,
        address _to,
        uint256 _amountFrom,
        uint256 _amountTo)
        public
        validOperator(msg.sender)
    {
        if ( _to == address(currencyToken) ) {
            emit Log(
              _sender,
              msg.sender,
              EventType.SellCards,
              _from,
              _to,
              _amountFrom,
              _amountTo,
              now);
        } else {
            emit Log(
              _sender,
              msg.sender,
              EventType.BuyCards,
              _from,
              _to,
              _amountFrom,
              _amountTo,
              now);
            emit AddOwnedCardList(_sender, _to, now);
        }
        emit ConvertCards(_sender, _from, _to, _amountFrom, _amountTo, now);
    }

    /**
    *   @notice log the bid of cards for sales contract
    */
    function notifyBidCards(address _sender, address _to, uint256 _amount)
        public
        validOperator(msg.sender)
    {
        emit Log(
          _sender,
          msg.sender,
          EventType.BidCards,
          currencyToken,
          _to,
          _amount,
          0,
          now);

        emit BidCards(_sender, _to, _amount, now);
    }

    /**
    *   @notice log the withdrawal of cards from sales contract
    */
    function notifyWithdrawalCards(address _sender, address _to, uint256 _bids, uint256 _amount)
        public
        validOperator(msg.sender)
    {
        emit AddOwnedCardList(_sender, _to, now);

        emit Log(
          _sender,
          msg.sender,
          EventType.WithdrawCards,
          0x0,
          _to,
          0,
          _amount,
          now);

        emit WithdrawalCards(_sender, _to, _bids, _amount, now);
    }

    /**
    *   @notice log the burn of cards
    */
    function notifyBurnCards(address _sender, uint256 _amount)
        public
        validOperator(msg.sender)
    {
        emit Log(
          _sender,
          msg.sender,
          EventType.BurnCards,
          msg.sender,
          0x0,
          _amount,
          0,
          now);

        emit BurnCards(msg.sender, msg.sender, _amount, now);
    }

    /**
    *   @notice log the revenue of auction
    */
    function notifyAuctionRevenue(
        address _sender,
        address _target,
        address _card,
        uint32  _hero,
        uint256 _hero_amount,
        uint256 _team_amount)
        public
        validOperator(msg.sender)
    {
        emit AuctionHeroRevenue(_sender, _target, _card, _hero, _hero_amount, now);
        emit AuctionTeamRevenue(_sender, _target, _card, _team_amount, now);
    }

    /**
    *   @notice log the revenue of exchange
    */
    function notifyExchangeRevenue(
        address _sender,
        address _target,
        address _card,
        uint32  _hero,
        uint256 _hero_amount,
        uint256 _team_amount)
        public
        validOperator(msg.sender)
    {
        emit ExchangeHeroRevenue(_sender, _target, _card, _hero, _hero_amount, now);
        emit ExchangeTeamRevenue(_sender, _target, _card, _team_amount, now);
    }

}
