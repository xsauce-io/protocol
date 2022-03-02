// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

interface IXsauceOwnable {
    function owner() public view virtual;

    function addAdmin(address newAdmin_) public virtual;

    function removeAdmin(address oldAdmin_) public virtual;

    function banAdmin(address bannedAdmin_) public virtual;

    function renounceOwnership() public virtual;

    function transferOwnership(address newOwner) public virtual;
}