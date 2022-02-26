interface IXsauceOwnable {
    function owner() public view virtual;

    function managers() external view;

    function renounceOwnership() public virtual onlyOwner;

    function transferOwnership(address newOwner) public virtual onlyOwner;

    function pullManagement() external;
}