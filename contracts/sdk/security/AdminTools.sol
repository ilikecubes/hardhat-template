// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

// openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

// core
import "../core/Core.sol";

// security
import "./TokenRecovery.sol";

contract AdminTools is Ownable, Pausable, ReentrancyGuard, TokenRecovery {
    function pause() external onlyOwner nonReentrant {
        _pause();
    }

    function unpause() external onlyOwner nonReentrant {
        _unpause();
    }

    function recoverToken(
        address token_,
        address receiver_
    ) external onlyOwner nonReentrant {
        _recoverToken(token_, receiver_);
    }

    function recoverToken(address token_) external onlyOwner nonReentrant {
        _recoverToken(token_);
    }
}
