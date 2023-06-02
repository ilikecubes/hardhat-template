// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

// openzeppelin
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

contract ShareParticipants {
    using EnumerableMap for EnumerableMap.AddressToUintMap;

    mapping(address => uint256) private _sharesMap;
    uint256 private _totalShares;

    mapping(address => bool) private _participantsMap;
    address[] private _participants;

    error ERROR__NOT_A_PARTICIPANT(address participant);
    error ERROR__INSUFFICIENT_SHARES_FOR_PARTICIPANT(
        address participant,
        uint256 shares,
        uint256 requiredShares
    );

    event EVENT__ADDED_SHARES(
        address participant,
        uint256 sharesBefore,
        uint256 sharesAfter,
        uint256 addedShares
    );
    event EVENT__REMOVED_SHARES(
        address participant,
        uint256 sharesBefore,
        uint256 sharesAfter,
        uint256 removedShares
    );

    function totalShares() public view returns (uint256) {
        return _totalShares;
    }

    function sharesOf(address participant_) public view returns (uint256) {
        return _sharesMap[participant_];
    }

    function isParticipant(address participant_) public view returns (bool) {
        return _participantsMap[participant_];
    }

    function _addShares(address participant_, uint256 shares_) internal {
        if (!_participantsMap[participant_]) {
            _participants.push(participant_);
            _participantsMap[participant_] = true;
        }
        uint256 sharesBefore = _sharesMap[participant_];
        _sharesMap[participant_] += shares_;
        _totalShares += shares_;
        uint256 sharesAfter = _sharesMap[participant_];
        emit EVENT__ADDED_SHARES(
            participant_,
            sharesBefore,
            sharesAfter,
            shares_
        );
    }

    function _removeShares(address participant_, uint256 shares_) internal {
        if (!_participantsMap[participant_]) {
            revert ERROR__NOT_A_PARTICIPANT(participant_);
        }
        uint256 sharesBefore = _sharesMap[participant_];
        if (sharesBefore < shares_) {
            revert ERROR__INSUFFICIENT_SHARES_FOR_PARTICIPANT(
                participant_,
                sharesBefore,
                shares_
            );
        }
        _sharesMap[participant_] -= shares_;
        _totalShares -= shares_;
        uint256 sharesAfter = _sharesMap[participant_];
        emit EVENT__REMOVED_SHARES(
            participant_,
            sharesBefore,
            sharesAfter,
            shares_
        );
    }
}
