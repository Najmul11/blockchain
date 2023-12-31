// SPDX-License-Identifier: GPL-3.0


pragma solidity ^0.8.22;

contract ZombieFactory {

    // declare our event here
    event NewZombie(uint zombieId,string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner; // which zombie belongs to whom
    mapping (address => uint) ownerZombieCount; // how many zombie an ownwe has

    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna));
     

        emit NewZombie(zombies.length-1, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {

        //only trigger the function when executoner has no zombie
        require(ownerZombieCount[msg.sender] == 0);

        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

     function getAllZombies() public view returns (Zombie[] memory) {
        return zombies;
    }

}