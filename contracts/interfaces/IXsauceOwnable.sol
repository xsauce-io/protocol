// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

interface IXsauceOwnable {
    function owner() external view;

    function addAdmin(address newAdmin_) external;

    function removeAdmin(address oldAdmin_) external;

    function banAdmin(address bannedAdmin_) external;

    function renounceOwnership() external;

    function transferOwnership(address newOwner) external;
}