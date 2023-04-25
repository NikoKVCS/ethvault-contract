// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract EthVault {
    address private constant OWNER = 0x31De1d395608Af675E29c83048AAB38aF954280e;

    mapping(bytes32 => bool) private usedSignatures;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    function deposit(bytes memory message, bytes memory signature) public payable {
        require(validateSignature(message, signature), "Invalid signature");

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(bytes memory message, bytes memory signature, uint256 amount) public {
        require(validateSignature(message, signature), "Invalid signature");
        require(msg.sender == tx.origin, "Withdrawals can only be initiated by EOA");

        require(amount <= address(this).balance, "Insufficient funds");

        emit Withdrawal(msg.sender, amount);

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Withdrawal transfer failed");
    }

    function validateSignature(bytes memory message, bytes memory signature) private returns (bool) {
        bytes32 messageHash = keccak256(abi.encodePacked(message));
        require(!usedSignatures[messageHash], "Signature already used");
        usedSignatures[messageHash] = true;

        address recoveredAddress = recoverSigner(messageHash, signature);
        return recoveredAddress == OWNER;
    }

    function recoverSigner(bytes32 messageHash, bytes memory signature) private pure returns (address) {
        require(signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := and(mload(add(signature, 0x41)), 0xff)
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid signature version");

        return ecrecover(messageHash, v, r, s);
    }
}
