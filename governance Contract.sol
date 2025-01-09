SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DexifyGovernance {
    address public admin;
    mapping(address => bool) public voters;
    uint256 public proposalCount;

    struct Proposal {
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;

    event NewProposal(uint256 proposalId, string description);
    event Voted(uint256 proposalId, bool support, address voter);
    event Executed(uint256 proposalId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    modifier onlyVoter() {
        require(voters[msg.sender], "Not a voter");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addVoter(address _voter) external onlyAdmin {
        voters[_voter] = true;
    }

    function createProposal(string memory description) external onlyVoter {
        proposals[proposalCount] = Proposal(description, 0, 0, false);
        emit NewProposal(proposalCount, description);
        proposalCount++;
    }

    function vote(uint256 proposalId, bool support) external onlyVoter {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");

        if (support) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }

        emit Voted(proposalId, support, msg.sender);
    }

    function executeProposal(uint256 proposalId) external onlyAdmin {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Already executed");
        require(proposal.votesFor > proposal.votesAgainst, "Proposal not passed");

        proposal.executed = true;
        emit Executed(proposalId);
    }
}
