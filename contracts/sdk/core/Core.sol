// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

contract Core {
    function _sender() internal view returns (address) {
        return msg.sender;
    }

    function _this() internal view returns (address) {
        return address(this);
    }

    function _dead() internal pure returns (address) {
        return 0x000000000000000000000000000000000000dEaD;
    }
}
