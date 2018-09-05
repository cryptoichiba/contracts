pragma solidity ^0.4.18;

/*
    Financie Ticket Store contract interface
*/
contract IFinancieTicketStore {
    function depositTickets(address _ticket, address _card, uint256 _amount, uint256 _price) public;
    function buyTicket(address _ticket) public;
}