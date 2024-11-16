// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./verifier.sol";

contract CuriosChallenge is Ownable {
    Groth16Verifier public verifier;

    struct Challenge {
        address creator;
        uint index;
        string name;
        string hint;
        bytes32 merkleRoot;
        uint maxWinners;
        string metadata;
        bool valid;
        uint prizePool;
        mapping(address => bool) claimed;
    }

    mapping(address => Challenge[]) public challenges;

    event ChallengeCreated(address indexed creator, uint indexed challengeIndex);
    event PrizeClaimed(address indexed claimer, uint indexed challengeIndex, uint prize);
    event ChallengeInvalidated(address indexed creator, uint indexed challengeIndex);

    constructor(address verifierAddress, address initialOwner) Ownable(initialOwner) {
        verifier = Groth16Verifier(verifierAddress);
    }

    function createChallenge(
        string memory _name,
        string memory _hint,
        uint _maxWinners,
        bytes32 _merkleRoot,
        string memory _metadata
    ) public payable {
        require(msg.value > 0, "Prize pool must be greater than 0");

        uint challengeIndex = challenges[msg.sender].length;

        Challenge storage newChallenge = challenges[msg.sender].push();
        newChallenge.creator = msg.sender;
        newChallenge.index = challengeIndex;
        newChallenge.name = _name;
        newChallenge.hint = _hint;
        newChallenge.merkleRoot = _merkleRoot;
        newChallenge.maxWinners = _maxWinners;
        newChallenge.metadata = _metadata;
        newChallenge.valid = true;
        newChallenge.prizePool = msg.value;

        emit ChallengeCreated(msg.sender, challengeIndex);
    }

    function claimPrize(
        address _creator,
        uint _challengeIndex,
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[1] memory publicSignals
    ) public {
        Challenge storage challenge = challenges[_creator][_challengeIndex];
        require(challenge.valid, "Challenge is not valid");
        require(!challenge.claimed[msg.sender], "Prize already claimed");
        require(challenge.prizePool > 0, "No prize available");

        require(verifier.verifyProof(a, b, c, publicSignals), "Invalid ZK proof");

        challenge.claimed[msg.sender] = true;

        uint prize = challenge.prizePool / challenge.maxWinners;
        challenge.prizePool -= prize;
        payable(msg.sender).transfer(prize);

        emit PrizeClaimed(msg.sender, _challengeIndex, prize);
    }

    function getChallenge(address _creator, uint _challengeIndex)
        public
        view
        returns (
            address creator,
            uint index,
            string memory name,
            string memory hint,
            bytes32 merkleRoot,
            uint maxWinners,
            string memory metadata,
            bool valid,
            uint prizePool
        )
    {
        Challenge storage challenge = challenges[_creator][_challengeIndex];
        return (
            challenge.creator,
            challenge.index,
            challenge.name,
            challenge.hint,
            challenge.merkleRoot,
            challenge.maxWinners,
            challenge.metadata,
            challenge.valid,
            challenge.prizePool
        );
    }

    function invalidateChallenge(address _creator, uint _challengeIndex) public {
        Challenge storage challenge = challenges[_creator][_challengeIndex];
        require(msg.sender == challenge.creator || msg.sender == owner(), "Not authorized");
        require(challenge.valid, "Challenge already invalidated");

        challenge.valid = false;

        emit ChallengeInvalidated(_creator, _challengeIndex);
    }
}
