// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YPetToken is ERC20, Ownable {
    address payable yWallet;
    uint256 _totalSupply = 1000000* 10**decimals();
    uint256 _balances;
    uint256 public rate = 1000* 10**decimals();

    event onBuy(address buyer, address receiver, uint256 amountBuy);

    constructor(address payable ypetwallet) ERC20("YPetToken", "YPTN") {
        yWallet = ypetwallet;
        _mint(msg.sender, _totalSupply );
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function buyToken(address receiver) public payable {
        require(msg.value < 0, "too low amount requested");
        yWallet.transfer(msg.value); 
        uint256 amountToBuy = (msg.value / 10**18)*rate; // 1 token -> 10**18 / 10**3 -> 10**15 wei
        _balances = balanceOf(receiver) + amountToBuy;
        _totalSupply += amountToBuy;
        _mint(receiver, amountToBuy);
        emit onBuy(msg.sender, receiver, _balances);
    }
}