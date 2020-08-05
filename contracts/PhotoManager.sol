pragma solidity >=0.4.21 <0.7.0;

import './Ownable.sol';
import './LicensePayment.sol';

contract PhotoManager is Ownable{

    struct Photo {
        bytes32 imageHash;
        uint priceInWei;
        uint index;
        mapping(uint => License) licenses;
    }

    struct License {
        LicensePayment licensePayment;
        bool paid;
        address client;
    }

   mapping(bytes32 => Photo) photos;

    event LicensingProcess(
        bytes32 imageHash,
        uint licenseIndex,
        address clientAddress,
        bool paid,
        address paymentAddress
    );

    // development purpose event
    event Key(bytes32 imageHash);

    constructor(address _photographer) public onlyOwner {
        transferOwnership(_photographer);
    }

    // Create Photo
    function createPhoto(string memory dummyImage, uint _priceInWei) public onlyOwner {
        bytes32 key = keccak256(bytes(dummyImage));
        photos[key].imageHash = key;
        photos[key].priceInWei = _priceInWei;
        emit Key(key);
    }

    // Order Request for License
    function orderLicense(bytes32 _imageHash) public {
        photos[_imageHash].licenses[photos[_imageHash].index] = License(
            new LicensePayment(this, photos[_imageHash].priceInWei, _imageHash, photos[_imageHash].index),
            false,
            msg.sender
        );

        emit LicensingProcess(
            photos[_imageHash].imageHash,
            photos[_imageHash].index,
            msg.sender,
            photos[_imageHash].licenses[photos[_imageHash].index].paid,
            address(photos[_imageHash].licenses[photos[_imageHash].index].licensePayment)
        );
        photos[_imageHash].index++;
    }

    // Complete Payment and approve licenses
    function triggerPayment(bytes32 _imageHash, uint _index) public payable {
        require(msg.sender == address(photos[_imageHash].licenses[_index].licensePayment), "License can only updated by payment contract");
        require(!photos[_imageHash].licenses[_index].paid, "License already paid");
        photos[_imageHash].licenses[_index].paid = true;

        emit LicensingProcess(
            photos[_imageHash].imageHash,
            _index,
            photos[_imageHash].licenses[_index].client,
            photos[_imageHash].licenses[_index].paid,
            address(photos[_imageHash].licenses[_index].licensePayment)
        );
    }

    // Withdrawing money from contract to photograper account
    function withdrawMoney() public payable onlyOwner {
        address payable to = msg.sender;
        to.transfer(getBalance());
    }

    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }

}