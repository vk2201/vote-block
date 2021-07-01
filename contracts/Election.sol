//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.3;
import "hardhat/console.sol";

contract Election {
address owner;

constructor(address _owner){
    owner = _owner;
}

struct candidate 
{
    uint id;
    string name;
    uint voteCount; 
}

modifier onlybyEci (address _account)
{
    require(
        msg.sender == _account,
        "Not authorized"
    );
    _;
}

mapping (uint => candidate) public candidateList ;

function addCandidate(uint _id , string memory _name) public onlybyEci(owner) 
{
    candidateList[_id] = candidate(_id,_name,0);
}

//voters

struct voter 
{
    string voterid;
    bool voted;
    bool isvoter;
    string faceHash;
}

modifier verifyVoter(string memory _voterId , string memory _faceHash) {
    require(voterList[_voterId].isvoter == true,"Enter valid voter Id");
    require((keccak256(abi.encodePacked((_faceHash))) == keccak256(abi.encodePacked((voterList[_voterId].faceHash )))),"Facial Verificatiion Failed");
    require(voterList[_voterId].voted == false,"Already Voted"); 
    _;
}

modifier validVoter(string memory _voterId , string memory _faceHash)
{
    //bytes memory voterId = bytes(_voterId);
    require(bytes(_voterId).length > 0 , "valid voter Id needed");
    require(bytes(_faceHash).length > 0 , "face code required");
    require( voterList[_voterId].isvoter == false , "Voter Id already registered");
    _;
}
//mapping (string => string) public voterHash ;
mapping (string => voter) public voterList ;

function addVoter(string memory _voterid , string memory _faceHash ) public onlybyEci(owner) validVoter(_voterid , _faceHash)
{
 voterList[_voterid] = voter( _voterid , false  , true , _faceHash);   
}

function vote(string memory _voterId , uint candidateId , string memory _faceHash) public verifyVoter(_voterId , _faceHash) 
{
    voterList[_voterId].voted = true;
    candidateList[candidateId].voteCount += 1; 
}

}