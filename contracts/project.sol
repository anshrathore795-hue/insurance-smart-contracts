// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Insurance {
    address public owner;
    mapping(address => uint256) public insuredAmounts;
    mapping(address => bool) public isInsured;

    event Insured(address indexed user, uint256 amount);
    event ClaimProcessed(address indexed user, uint256 amount);
    event InsuranceCancelled(address indexed user);

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to purchase insurance
    function purchaseInsurance(uint256 _amount) public payable {
        require(msg.value == _amount, "Please send the exact amount for insurance");
        require(!isInsured[msg.sender], "You are already insured");

        insuredAmounts[msg.sender] = _amount;
        isInsured[msg.sender] = true;
        
        emit Insured(msg.sender, _amount);
    }

    // Function to claim insurance (for example, after a disaster)
    function claimInsurance() public {
        require(isInsured[msg.sender], "You must have insurance to claim");
        uint256 claimAmount = insuredAmounts[msg.sender];
        require(claimAmount > 0, "No insurance coverage available");

        // Reset the insured amount to 0 after claim
        insuredAmounts[msg.sender] = 0;

        payable(msg.sender).transfer(claimAmount);
        emit ClaimProcessed(msg.sender, claimAmount);
    }

    // Function to cancel insurance
    function cancelInsurance() public {
        require(isInsured[msg.sender], "You do not have insurance to cancel");

        uint256 refundAmount = insuredAmounts[msg.sender];
        insuredAmounts[msg.sender] = 0;
        isInsured[msg.sender] = false;

        payable(msg.sender).transfer(refundAmount);
        emit InsuranceCancelled(msg.sender);
    }

    // Function to get the insurance details for a user
    function getInsuranceDetails(address _user) public view returns (uint256, bool) {
        return (insuredAmounts[_user], isInsured[_user]);
    }
}

