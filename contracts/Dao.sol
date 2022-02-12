//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Dao{
    //Dao owner
    address owner;

    //registration fee
    uint256 registrationFee = 100000000000000 wei;

    struct Member{
        uint256 balance;
        string username;
        string imageUrl;
        mapping(string => bool) votes;
    }

    //track members;
    mapping(address => Member) public members;

    //proposal 
    struct Proposal{
        address author;
        bool isClosed;
        uint256 totalVotes;
        uint256 endDate;
        mapping(string => bool) options;
    }

    //list propsals;
    mapping(string => Proposal) public proposals;

    //create proposal event
    event ProposalCreated(
        address indexed _author,
        string indexed _proposal,
        string proposal,
        string author,
        string[] options,
        uint256 timestamp
    );

    //cast vote event
    event VoteCasted(
        address indexed _sender,
        string indexed _voteOption,
        string indexed _proposal,
        uint256 lastVoteCount,
        uint256 newVoteCount,
        string author,
        string imageUrl,
        string voteOption,
        uint256 timestamp
    );

    constructor(){
        owner = msg.sender;
    }

    //register members;
    function registerMember(string memory username, string memory imageUrl) public payable {
        require(msg.value == registrationFee, "Registration fee is 0.0001 ether");
        //get a pointer for new member "object"
        Member storage m =  members[msg.sender];
        m.balance = msg.value;
        m.username = username;
        m.imageUrl = imageUrl;
    }

    //create proposal
    function createProposal(string memory _title, string[] memory voteOptions, uint256 endDate) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        //get a pointer for a new proposal "object"
        Proposal storage p = proposals[_title];
        p.author = msg.sender;

        if(endDate > 0){
            p.endDate = endDate;
        }

        for(uint len = 0; len < voteOptions.length; len++){
            p.options[voteOptions[len]] = true;
        }
        
        emit ProposalCreated(msg.sender , _title, _title, members[msg.sender].username,   voteOptions, block.timestamp);
    }

    //mark proposal open
    function markProposalOpen(string memory _title) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        require(proposals[_title].author == msg.sender, "You are not authorized to take this action");

        proposals[_title].isClosed = false;
    }

    //mark proposal closed
    function markProposalClosed(string memory _title) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        require(proposals[_title].author == msg.sender, "You are not authorized to take this action");

        proposals[_title].isClosed = true;
    }

    //cast votes;
    function vote(string memory _proposal, string memory _voteOption ) external {
        require(members[msg.sender].balance == registrationFee, "You are not authorized to take this action");
        require(!proposals[_proposal].isClosed, "Proposal not available for voting" );
        require(proposals[_proposal].options[_voteOption], "Vote option is not available" );
        require(members[msg.sender].votes[_proposal] == false , "You vote has been cast already");

        uint256 votes = proposals[_proposal].totalVotes;
        members[msg.sender].votes[_proposal] = true;
        proposals[_proposal].totalVotes = votes + 1;

        //log vote cast
        emit VoteCasted(msg.sender , _voteOption, _proposal, votes, votes+1, members[msg.sender].username, members[msg.sender].imageUrl,_voteOption, block.timestamp);
    }

    //get proposal attributes;
    function getProposalAttributes(string memory _proposal) external view returns (uint256, bool) {
        return (proposals[_proposal].totalVotes, proposals[_proposal].isClosed);
    }

    //check registration
    function checkRegistered(address _address) external view returns (bool){
        return members[_address].balance == registrationFee ;
    }


    //get organization balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
}