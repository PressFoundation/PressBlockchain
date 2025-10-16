// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract NFTLoanManager {
    struct Loan {
        address borrower;
        address collection;
        uint256 tokenId;
        uint256 due;
        bool returned;
    }

    event LoanRequested(uint256 id, address borrower, address collection, uint256 tokenId, uint256 due);
    event LoanReturned(uint256 id);

    uint256 public nextId;
    mapping(uint256 => Loan) public loans;

    function requestLoan(address collection, uint256 tokenId, uint256 duration) external returns (uint256 id) {
        IERC721(collection).transferFrom(msg.sender, address(this), tokenId);
        id = ++nextId;
        loans[id] = Loan(msg.sender, collection, tokenId, block.timestamp + duration, false);
        emit LoanRequested(id, msg.sender, collection, tokenId, block.timestamp + duration);
    }

    function returnNFT(uint256 id) external {
        Loan storage l = loans[id];
        require(msg.sender == l.borrower, "not borrower");
        require(!l.returned, "already");
        l.returned = true;
        IERC721(l.collection).transferFrom(address(this), l.borrower, l.tokenId);
        emit LoanReturned(id);
    }
}
