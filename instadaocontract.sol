// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import  "hardhat/console.sol";
contract InstaDao is ERC20, Ownable {
    uint256 _totalSupply;
    uint256 _decimals;
     event ManualTransfer(address from,address to, address tokenaddress,uint256 amt);
    constructor(uint256 supply,uint256 amt,uint256 _deci,string memory name,string memory symbol, address creator) ERC20(name,symbol)  {
        // console.log(totalSupply())
        _decimals=_deci;
         _totalSupply=supply * 10 ** _decimals;
    
      _mint(creator, amt);
     
        // console.log(cap());
    }

    function _mint(address to, uint256 amount) internal override onlyOwner {
        // console.log(totalSupply())
        require(totalSupply() + amount * 10 ** _decimals <= _totalSupply,"Exceeding supply");
        super._mint(to, amount* 10 ** _decimals);
        // emit Mint(to,address(this),_totalSupply,amount);
        // DaoFactory.emitTokenCreated(address())
        // _totalSupply+=amount;
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        super._transfer(sender,recipient,amount);
        emit ManualTransfer(sender,recipient,address(this),amount);
    }
    


    
}

contract DaoFactory{
    
    // mapping(address => InstaDao) public children;
    event tokencreated(address tokenaddress,address creator,string  name, string  symbol,uint256 deci,string metadata,uint256 totalSupply,string ens);
    function create(uint256 supply,uint256 amt,uint256 deci,string memory name, string memory symbol,string memory metadata,string memory ens) public returns(address) {
        InstaDao instaDao = new InstaDao(supply,amt,deci,name,symbol, msg.sender);
        // children[msg.sender] = instaDao;
        instaDao.transferOwnership(msg.sender);
        emit tokencreated(address(instaDao),msg.sender,name,symbol,deci,metadata,supply,ens);
        return address(instaDao);
    }
    // function emitTokenCreated(address tokenAddress,address sender) public {
    //     emit tokencreated(tokenAddress,sender);
    // }
    // function getContract()
    //     public
    //     view
    //     returns (
    //         address
    //     )
    // {
    //     InstaDao instaDao = children[msg.sender];
    //     return (
    //         address(instaDao)
    //     );
    // }
}
