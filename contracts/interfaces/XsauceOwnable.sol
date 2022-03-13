// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/utils/Context.sol";
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract XsauceOwnable is Context {
    address private _owner;
    mapping(address => uint) private _admins;
    mapping(address => uint) private _managers;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    event AdminAdded(address indexed newAdmin);
    event AdminRemoved(address indexed oldAdmin);
    
    event ManagerAdded(address indexed newManager);
    event ManagerRemoved(address indexed oldManager);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        _admins[msgSender] = 1;
        _managers[msgSender] = 1;
        emit OwnershipTransferred(address(0), msgSender);
        emit AdminAdded(msgSender);
        emit ManagerAdded(msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

     /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "XsauceOwnable: caller is not the owner");
        _;
    }

    /**
     * @dev Throws if called by any account other than the admins.
     */
    modifier onlyAdmins() {
        require(_admins[_msgSender()] == 1, "XsauceOwnable: caller is not an admin");
        _;
    }

     function addAdmin(address newAdmin_) public virtual onlyOwner {
        require(_admins[newAdmin_] == 0, "XsauceOwnable: admin already added");
        emit AdminAdded(newAdmin_);
        _admins[newAdmin_] = 1;
        _managers[newAdmin_] = 1;
    }

    function removeAdmin(address oldAdmin_) public virtual onlyAdmins {
        require(_admins[oldAdmin_] != 0, "XsauceOwnable: admin already removed");
        emit AdminRemoved(oldAdmin_);
        delete _admins[oldAdmin_];
        delete _managers[oldAdmin_];
    }

    /**
     * @dev Throws if called by any account other than the managers.
     */
    modifier onlyManagers() {
        require(_managers[_msgSender()] == 1, "XsauceOwnable: caller is not a manager");
        _;
    }

    function addManager(address newManager_) public virtual onlyAdmins {
        require(_managers[newManager_] == 0, "XsauceOwnable: new manager already exists");
        emit ManagerAdded(newManager_);
        _managers[newManager_] = 1;
    }

    function removeManager(address oldManager_) public virtual onlyAdmins {
        require(_managers[oldManager_] != 0, "Management: manager does not exist");
        emit ManagerRemoved(oldManager_);
        delete _managers[oldManager_];
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyAdmins {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
