// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

error Escrow__OperacionNoActiva();
error Signature__split_IncorrectLenght();

contract Escrow {
    enum EscrowState {
        INITIALIZED,
        REJECTED,
        DONE
    }

    struct Vendor {
        uint256 vendorId; //To Pay offchain
    }
    /* State variables */

    /* Escrow Variables */
    uint256 private immutable i_amount;
    address private immutable i_buyerAddress;
    address private s_cashBitAddress;
    string private i_message;
    uint256 private immutable i_vendorId;
    Vendor s_vendor;

    EscrowState private s_escrowState;

    event PaymentDone(uint amount, uint256 vendor_id, uint when);

    /**
     * @notice Se inicializa la custodia de los activos enviados a la tasa marcada prometida.
     *
     * @dev Debe generarse un mensaje para firmar con la wallet Off-chain
     * @dev El mensaje firmado se convierte en el código de reclamo (QR) (código es una firma que incluye los datos de la tx)
     * @param _vendorId: Dirección de la casa de cambio
     *
     */
    constructor(uint256 _vendorId) payable {
        i_vendorId = _vendorId;
        i_amount = msg.value;
        i_buyerAddress = msg.sender;
        s_escrowState = EscrowState.INITIALIZED;
        s_cashBitAddress = 0x2EEd1279b97eFD16c3AcE981D4B5c4049062F4ad; //Dirección cashBit
    }

    /**
     *  @dev Esta función debe ejecutarse desde la cartera de la exchange escaneando la firma del comprador (viajero)
     */
    function freeAssets(bytes memory _signature) external {
        i_message = getMessage();

        if (s_escrowState != EscrowState.INITIALIZED) {
            revert Escrow__OperacionNoActiva();
        }

        //Si el signer del mensaje firmado (No de orden, signer) y el buyer coinciden
        if (verifySig(i_buyerAddress, i_message, _signature)) {
            //enviar fondos a cashBit
            payable(s_cashBitAddress).transfer(address(this).balance);
            s_escrowState = EscrowState.DONE;

            emit PaymentDone(
                address(this).balance,
                i_vendorId,
                block.timestamp
            );
        }
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);
    }

    /**Helpers */

    function verifySig(
        address _signer,
        string memory _message,
        bytes memory _signature
    ) internal pure returns (bool) {
        //Hashear Mensaje,

        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recover(ethSignedMessageHash, _signature) == _signer;
    }

    function getMessageHash(
        string memory _message
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(
        bytes32 _messageHash
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    function recover(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function _split(
        bytes memory _signature
    ) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        if (_signature.length != 65) {
            revert Signature__split_IncorrectLenght();
        }

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
    }

    // Helper function to convert address to string

    // function addressToString(
    //     address _address
    // ) internal pure returns (string memory) {
    //     bytes32 _bytes = bytes32(uint256(uint160(_address)));
    //     bytes memory HEX = "0123456789abcdef";
    //     bytes memory _string = new bytes(42);
    //     _string[0] = "0";
    //     _string[1] = "x";
    //     for (uint i = 0; i < 20; i++) {
    //         _string[2 + i * 2] = HEX[uint8(_bytes[i + 12] >> 4)];
    //         _string[3 + i * 2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
    //     }
    //     return string(_string);
    // }

    /** El mensaje a firmar consistirá del monto y el contract Address */
    function getMessage() public view returns (string memory) {
        address contractAddress = address(this);
        return
            string(
                abi.encodePacked(
                    Strings.toString(i_amount),
                    Strings.toHexString(uint160(contractAddress), 20)
                )
            );
    }

    /** Admin restrictive functions */

    /** GETTERSs */

    function getAmount() public view returns (uint256) {
        return i_amount;
    }

    function getVendorId() public view returns (uint256) {
        return i_vendorId;
    }

    function getDolabitAddress() public view returns (address) {
        return s_cashBitAddress;
    }
}
