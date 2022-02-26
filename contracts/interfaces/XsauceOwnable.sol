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
abstract contract Ownable is Context {
    string private _active = "active";
    string private _banned = "banned";
    address private _owner;
    mapping(address => string) private _admins;
    mapping(address => string) private _managers;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    event AdminAdded(address indexed newAdmin);
    event AdminRemoved(address indexed oldAdmin);
    event AdminBanned(address indexed bannedAdmin);
    
    event ManagerAdded(address indexed newManager);
    event ManagerRemoved(address indexed oldManager);
    event ManagerBanned(address indexed bannedManager);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        _admins[msgSender] = _active;
        _managers[msgSender] = _active;
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
     * @dev Returns mapping of current admins.
     */
    function admins() public view virtual returns (mapping(address => string)){
        return _admins;
    }

    /**
     * @dev Throws if called by any account other than the admins.
     */
    modifier onlyAdmins() {
        mapping(address => string) admins = admins();
        require(admins[_msgSender()] != 0, "XsauceOwnable: caller is not an admin");
        require(admins[_msgSender()] != _banned, "XsauceOwnable: caller is banned")
        _;
    }

     function addAdmin(address newAdmin_) public virtual onlyAdmins {
        require(_admins[newAdmin_] == 0, "XsauceOwnable: admin already added");
        require(_admins[newAdmin_] != _banned, "XsauceOwnable: banned admin");
        emit AdminAdded(newAdmin_);
        _admins[newAdmin_] = _active;
    }

    function removeAdmin(address oldAdmin_) public virtual onlyAdmins {
        require(_admins[newAdmin_] != 0, "XsauceOwnable: admin already removed");
        emit AdminRemoved(oldAdmin_);
        delete _admins[oldAdmin_];
    }

    function banAdmin(address bannedAdmin_) public virtual onlyAdmins {
        require(_admins[bannedAdmin_] != 0, "XsauceOwnable: admin does not exist");
        require(_admins[bannedAdmin_] != _banned, "XsauceOwnable: admin already banned");
        emit AdminBanned(bannedAdmin_);
        _admins[bannedAdmin_] = _banned;
    }
    
    /**
     * @dev Throws if called by any account other than the admins.
     */
    function managers() public view virtual returns (mapping(address => string)){
        return _managers;
    }

    /**
     * @dev Throws if called by any account other than the managers.
     */
    modifier onlyManagers() {
        mapping(address => string) managers = managers();
        require(managers[_msgSender()] != 0, "XsauceOwnable: caller is not a manager");
        require(managers[_msgSender()] != _banned, "XsauceOwnable: caller is banned")
        _;
    }

    function addManager(address newManager_) public virtual onlyAdmins {
        require(_managers[newManager_] == 0, "XsauceOwnable: new manager already exists");
        require(_managers[newManager] != _banned, "XsauceOwnable: new manager is banned");
        emit ManagerAdded(newManager_);
        _managers[newManager_] = _active;
    }

    function removeManager(address oldManager_) public virtual onlyManagers {
        require(_managers[oldManager_] != 0, "Management: manager does not exist");
        emit ManagerRemoved(oldManager_);
        delete _managers[oldManager_];
    }

    function banManager(address bannedManager_) public virtual onlyAdmins {
        require(_managers[bannedManager_] != 0, "XsauceOwnable: manager does not exist");
        require(_managers[bannedManager_] != _banned, "XsauceOwnable: manager already banned");
        emit ManagerBanned(bannedManager_);
        _managers[bannedManager_] = _banned;
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
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
