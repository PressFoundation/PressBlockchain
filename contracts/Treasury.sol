// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Treasury {
    event Received(address indexed from, uint256 amount);
    event Sent(address indexed to, uint256 amount);

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function send(address payable to, uint256 amount) external {
        (bool ok,) = to.call{value: amount}("");
        require(ok, "send failed");
        emit Sent(to, amount);
    }
}
