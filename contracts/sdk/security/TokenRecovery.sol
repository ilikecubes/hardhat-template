// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

// openzeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// core
import "../core/Core.sol";

contract TokenRecovery is Core {
    mapping(address => bool) private _tokenBlacklist;

    error ERROR__TOKEN_IS_BLACKLISTED(address token);
    error ERROR__TOKEN_ALREADY_BLACKLISTED(address token);
    error ERROR__TOKEN_NOT_BLACKLISTED(address token);
    error ERROR__INSUFFICIENT_TOKEN_BALANCE(
        address token,
        uint256 balance,
        uint256 requiredBalance
    );

    event EVENT__ADDED_TOKEN_TO_BLACKLIST(address token);
    event EVENT__REMOVED_TOKEN_FROM_BLACKLIST(address token);
    event EVENT__TOKEN_RECOVERED(
        address token,
        address receiver,
        uint256 amount
    );

    function _isBlacklistToken(address token_) internal view returns (bool) {
        return _tokenBlacklist[token_];
    }

    function _addBlacklistToken(address token_) internal {
        if (_isBlacklistToken(token_)) {
            revert ERROR__TOKEN_ALREADY_BLACKLISTED(token_);
        }
        _tokenBlacklist[token_] = true;
        emit EVENT__ADDED_TOKEN_TO_BLACKLIST(token_);
    }

    function _removeBlacklistToken(address token_) internal {
        if (!_isBlacklistToken(token_)) {
            revert ERROR__TOKEN_NOT_BLACKLISTED(token_);
        }
        _tokenBlacklist[token_] = false;
        emit EVENT__REMOVED_TOKEN_FROM_BLACKLIST(token_);
    }

    function _recoverToken(address token_, address receiver_) internal {
        if (_isBlacklistToken(token_)) {
            revert ERROR__TOKEN_IS_BLACKLISTED(token_);
        }
        IERC20 token = IERC20(token_);
        uint256 balance = token.balanceOf(_this());
        if (balance < 1) {
            revert ERROR__INSUFFICIENT_TOKEN_BALANCE(token_, balance, 1);
        }
        token.transfer(receiver_, balance);
        emit EVENT__TOKEN_RECOVERED(token_, receiver_, balance);
    }

    function _recoverToken(address token_) internal {
        _recoverToken(token_, _this());
    }
}
