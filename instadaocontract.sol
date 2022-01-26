// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import  "hardhat/console.sol";
contract InstaDao is ERC20, Ownable {
    uint256 _totalSupply;
    uint256 _decimals;
    address public own;
    modifier onlyOwn(address sender) {
        require(own == sender);
        _;
    }
    constructor(uint256 supply,uint256 amt,uint256 _deci, address _owner) ERC20("MyToken","MTK")  {
        // console.log(totalSupply())
        _decimals=_deci;
         _totalSupply=supply * 10 ** _decimals;
         own= _owner;
      _mint(msg.sender, amt);
     
        // console.log(cap());
    }

    function _mint(address to, uint256 amount) internal override onlyOwn(msg.sender) {
        // console.log(totalSupply())
        require(totalSupply() + amount * 10 ** _decimals <= _totalSupply,"Exceeding supply");
        super._mint(to, amount * 10 ** _decimals );
        // _totalSupply+=amount;
    }
    
    function mint(address to, uint256 amount) public onlyOwn(msg.sender) {
        _mint(to, amount);
    }

    function getTotalSupply() public view returns(uint256){
        return _totalSupply;
    }
}

contract DaoFactory{
    
    mapping(address => InstaDao) public children;
    event tokencreated(address tokenaddress,address creator);
    function create(uint256 supply,uint256 amt,uint256 deci) public {
        InstaDao instaDao = new InstaDao(supply,amt,deci,msg.sender);
        children[msg.sender] = instaDao;
        emit tokencreated(address(instaDao),msg.sender);
    }

    function getContract()
        public
        view
        returns (
            address
        )
    {
        InstaDao instaDao = children[msg.sender];
        return (
            address(instaDao)
        );
    }
}
