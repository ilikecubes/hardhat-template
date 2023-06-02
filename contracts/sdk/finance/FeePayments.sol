// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

// openzeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FeePayments {
    error ERROR__FEE_ALREADY_ENABLED();
    error ERROR__FEE_ALREADY_DISABLED();
    error ERROR__INVALID_FEE_VALUE(uint256 percentage, uint256 base);

    event EVENT__FEE_PERCENTAGE_SET(uint256 percentage, uint256 base);
    event EVENT__ERC20_TRANSFERRED_TO_FEERECIEPIENT(
        address token,
        address feeRecipient,
        uint256 amount
    );
    event EVENT__ERC20_TRANSFERRED_WITH_FEE(
        address token,
        address recipient,
        address feeRecipient,
        uint256 feeAmount,
        uint256 recipientAmount
    );

    address private _feeRecipient;
    bool private _feeEnabled = true;

    uint256 private _feePercentage;
    uint256 private _feePercentageBase;
    uint256 private constant _FEE_PRECISON = 10e6;

    constructor(uint256 percentage_, uint256 base_, address recipient_) {
        _setFeePercentage(percentage_, base_);
        _setFeeRecipient(recipient_);
    }

    function _setFeeRecipient(address recipient_) internal {
        _feeRecipient = recipient_;
    }

    function _enableFee() internal {
        if (_feeEnabled) {
            revert ERROR__FEE_ALREADY_ENABLED();
        }
        _feeEnabled = true;
    }

    function _disableFee() internal {
        if (!_feeEnabled) {
            revert ERROR__FEE_ALREADY_DISABLED();
        }
        _feeEnabled = false;
    }

    function _enableFeeUnchecked() internal {
        _feeEnabled = true;
    }

    function _disableFeeUnchecked() internal {
        _feeEnabled = false;
    }

    function _getFeeAmount(uint256 amount_) internal view returns (uint256) {
        return (amount_ * _feePercentage) / _feePercentageBase;
    }

    function _splitAmount(
        uint256 amount_
    ) internal view returns (uint256, uint256) {
        uint256 feeAmount = _getFeeAmount(amount_);
        uint256 remainingAmount = amount_ - feeAmount;
        return (feeAmount, remainingAmount);
    }

    function _setFeePercentage(uint256 percentage_, uint256 base_) internal {
        if (percentage_ > base_ || percentage_ <= 0) {
            revert ERROR__INVALID_FEE_VALUE(percentage_, base_);
        }
        _feePercentage = percentage_ * _FEE_PRECISON;
        _feePercentageBase = base_ * _FEE_PRECISON;
    }

    function _transferERC20ToFeeReciepient(
        IERC20 token_,
        uint256 amount_
    ) internal {
        token_.transfer(_feeRecipient, amount_);
        emit EVENT__ERC20_TRANSFERRED_TO_FEERECIEPIENT(
            address(token_),
            _feeRecipient,
            amount_
        );
    }

    function _transferERC20WithFee(
        IERC20 token_,
        address recipient_,
        uint256 amount_
    ) internal {
        (uint256 feeAmount, uint256 recipientAmount) = _splitAmount(amount_);
        token_.transfer(_feeRecipient, feeAmount);
        token_.transfer(recipient_, recipientAmount);
        emit EVENT__ERC20_TRANSFERRED_WITH_FEE(
            address(token_),
            recipient_,
            _feeRecipient,
            feeAmount,
            recipientAmount
        );
    }
}
