// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.22;

import "./ZombieFactory.sol";


// this is an interface. we need interface to interact other blockchain contracts which is not part ot this contract

// interface is just like contract 
// function name has to be same and params should be same and whatever the function return should be same 


abstract contract KittyInterface {
  function getKitty(uint256 _id) external view virtual returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; // ca of  KittyInterface-getKitty 
    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {

    require(msg.sender == zombieToOwner[_zombieId]);

    Zombie storage myZombie = zombies[_zombieId];


    _targetDna = _targetDna % dnaModulus;

    uint newDna = (myZombie.dna + _targetDna) / 2;

    if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
      newDna = newDna - newDna % 100 + 99;
    }

    _createZombie("NoName", newDna);
   
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    
   feedAndMultiply(_zombieId, kittyDna, "kitty");
  }
}