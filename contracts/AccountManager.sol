pragma solidity ^0.6.0;

import './PhotoManager.sol';

contract AccountManager {

    uint index;
    mapping(address => Photographer) listedPhotographers;

    struct Photographer {
        bool exist;
        PhotoManager photoManager;
    }

    event PhotographerListing(
        address listedPhotographer,
        address PhotoManager,
        uint index
    );

    function addPhotographer() public {
        address _photographer = msg.sender;
        // Only add when user is not already signed
        require(!listedPhotographers[_photographer].exist, "Photographer already exist");

        listedPhotographers[_photographer] = Photographer(true, new PhotoManager(_photographer));
        index++;

        emit PhotographerListing(
            _photographer,
            address(listedPhotographers[_photographer].photoManager),
            index
        );

        // return address(listedPhotographers[_photographer].photoManager);
    }

    function getIndex() public view returns(uint) {
        return index;
    }

    function getPhotoManager(address _photographer) public view returns(address) {
        return address(listedPhotographers[_photographer].photoManager);
    }
}
