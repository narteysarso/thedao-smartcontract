//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Dao{
    //Dao owner
    address owner;

    //registration fee
    uint256 registrationFee = 1 wei;

    struct Member{
        uint256 balance;
        mapping(string => bool) votes;
    }

    //track members;
    mapping(address => Member) public members;

    //proposal 
    struct Proposal{
        address author;
        bool isActive;
        uint256 totalVotes;
        mapping(string => bool) options;
    }

    //list propsals;
    mapping(string => Proposal) public proposals;

    //create proposal event
    event proposalCreated(
        address indexed sender,
        string indexed proposal
    );

    //cast vote event
    event castVote(
        uint256 lastVoteCount,
        uint256 newVoteCount,
        address sender,
        string indexed voteOption,
        string indexed proposal
    );

    constructor(){
        owner = msg.sender;
    }

    //register members;
    function registerMember() public payable {
        require(msg.value == registrationFee, "Registration fee is 1 wei");
        //get a pointer for new member "object"
        Member storage m =  members[msg.sender];
        m.balance = msg.value;
    }

    //create proposal
    function createProposal(string memory _title, bool _isActive) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        //get a pointer for a new proposal "object"
        Proposal storage p = proposals[_title];
        p.author = msg.sender;
        p.isActive = _isActive;

        emit proposalCreated(msg.sender, _title);
    }

    function addProposalVoteOption(string memory _proposal, string memory option) external {
         require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        require(proposals[_proposal].author == msg.sender, "You are not authorized to take this action");

        proposals[_proposal].options[option] = true;
    }

    //mark proposal inactive
    function markProposalInActive(string memory _title) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        require(proposals[_title].author == msg.sender, "You are not authorized to take this action");

        proposals[_title].isActive = false;
    }

    //mark proposal active
    function markProposalActive(string memory _title) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        require(proposals[_title].author == msg.sender, "You are not authorized to take this action");

        proposals[_title].isActive = true;
    }

    //cast votes;
    function vote(string memory _proposal, string memory _voteOption ) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        require(proposals[_proposal].isActive, "Proposal not available for voting" );
        require(proposals[_proposal].options[_voteOption], "Vote option is not available" );
        require(!members[msg.sender].votes[_proposal], "You votes have been cast already");

        uint256 votes = proposals[_proposal].totalVotes;
        members[msg.sender].votes[_proposal] = true;
        proposals[_proposal].totalVotes = votes + 1;

        //log vote cast
        emit castVote(votes, votes+1, msg.sender, _voteOption, _proposal);
    }

    //get votes results;
    function getTotalVotes(string memory _proposal) external view returns (uint256) {
        require(proposals[_proposal].isActive, "Proposal not found" );
        return proposals[_proposal].totalVotes;
    }

    //log proposal events


    //get organization balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
}