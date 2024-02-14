pragma solidity 0.4.25;

contract VoteChain {

    enum StateType {Setup, Voting, Result}

    StateType public State;

    // Model a Candidate
    struct Candidate {
        int id;
        string name;
        string partyName;   //party name
        int voteCount;
    }

    address public EC;
    address public Voter;
    // This is to store accounts that have voted
    mapping(address => bool) public voters;
    // Store Candidates
    // Fetch Candidate
    mapping(int => Candidate) public candidates;
    // Store Candidates Count
    int public CandidatesCount;
    string public winner;
    string public cname;
    string public pname;
    int public candidateId;
    string public Title;

    constructor (string title) public {
        Title = title;
        CandidatesCount = -1;
        AddCandidate("NOTA","NA");
        State = StateType.Setup;
    }

    function vote (int candidateId) public {
        // require that they haven't voted before
        require(!voters[msg.sender], "You can only vote once!");

        // require a valid candidate
        require(candidateId > 0 && candidateId <= CandidatesCount, "Candidate not in list");

        // record that voter has voted
        voters[msg.sender] = true;

        // update candidate vote Count
        candidates[candidateId].voteCount ++;

        // trigger voted event
//        emit votedEvent(_candidateId);
        State = StateType.Voting;
    }

    function AddCandidate (string cname, string pname) public {
        CandidatesCount ++;
        candidates[CandidatesCount] = Candidate(CandidatesCount, cname, pname, 0);
    }

    function resultCalc () public {
        int mx = 0;
        for (int i = 0; i <= CandidatesCount; i++){
            if (candidates[i].voteCount > mx){
                winner = candidates[i].name;
                mx = candidates[i].voteCount;
            }
        }
        State = StateType.Result;
    }

    function AllowVoting () public {
        State = StateType.Voting;
    }
}