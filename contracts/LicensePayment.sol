pragma solidity >=0.4.21 <0.7.0;

import './PhotoManager.sol';

contract LicensePayment {
    uint public priceInWei;
    uint public paidWei;
    bytes32 public imageHash;
    uint public index;
    
    PhotoManager parentContract;
    
    constructor(PhotoManager _parentContract, uint _priceInWei, bytes32 _imageHash, uint _index) public {
        parentContract = _parentContract;
        priceInWei = _priceInWei;
        imageHash = _imageHash;
        index = _index;
    }
    
    function() external payable {
        require(msg.value == priceInWei, "Partial payments is not supported");
        require(paidWei == 0, "License already paid");
        paidWei += msg.value;
        parentContract.triggerPayment.value(msg.value)(imageHash, index);
    }
}