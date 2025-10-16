// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GovernorSimple
 * @notice Minimal governance with description-only proposals and simple voting.
 */
contract GovernorSimple is Ownable {
    enum Support { Against, For, Abstain }
    enum State { Pending, Active, Defeated, Succeeded, Executed }

    struct Proposal {
        string description;
        uint256 startBlock;
        uint256 endBlock;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 abstainVotes;
        bool executed;
    }

    uint256 public votingPeriod; // blocks
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 id, address proposer, string description);
    event VoteCast(address indexed voter, uint256 proposalId, uint8 support, uint256 weight, string reason);
    event ProposalExecuted(uint256 id);

    constructor(address owner_, uint256 votingPeriodBlocks) Ownable(owner_) {
        votingPeriod = votingPeriodBlocks;
    }

    function propose(string calldata description) external returns (uint256 id) {
        id = ++proposalCount;
        proposals[id] = Proposal({
            description: description,
            startBlock: block.number,
            endBlock: block.number + votingPeriod,
            forVotes: 0,
            againstVotes: 0,
            abstainVotes: 0,
            executed: false
        });
        emit ProposalCreated(id, msg.sender, description);
    }

    function state(uint256 id) public view returns (State) {
        Proposal storage p = proposals[id];
        if (block.number < p.startBlock) return State.Pending;
        if (block.number <= p.endBlock) return State.Active;
        if (p.executed) return State.Executed;
        if (p.forVotes > p.againstVotes) return State.Succeeded;
        return State.Defeated;
    }

    function castVote(uint256 id, uint8 support) external {
        Proposal storage p = proposals[id];
        require(block.number <= p.endBlock, "voting closed");
        require(!hasVoted[id][msg.sender], "already voted");
        hasVoted[id][msg.sender] = true;
        uint256 weight = 1; // simple weight; in production tie to token voting power
        if (support == uint8(Support.For)) p.forVotes += weight;
        else if (support == uint8(Support.Against)) p.againstVotes += weight;
        else p.abstainVotes += weight;
        emit VoteCast(msg.sender, id, support, weight, "");
    }

    function execute(uint256 id) external {
        Proposal storage p = proposals[id];
        require(state(id) == State.Succeeded, "not succeeded");
        p.executed = true;
        emit ProposalExecuted(id);
    }
}
