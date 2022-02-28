// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CoinFlip is Ownable, ReentrancyGuard {

    enum Status {
      Win,
      Lose,
      Canceled
    }
    event Withdraw(uint256 indexed amount);
    event GameResult(Status result);
    
    constructor(address _dealer) payable {
        transferOwnership(_dealer);
    }
    
    receive() external payable {
        // React to receiving ether
    }

    function transfer() external payable onlyOwner {}
    //owner can withdraw coinflip's balance
    function withdraw(uint256 _amount) external onlyOwner {
        require(_amount > 0, "Amount must be not zero");
        require(_amount <= getDealerBalance(), "Amount exceeds balance");
        transferMoney(_msgSender(), _amount);

        emit Withdraw(_amount);
    }
    //user can bet with coin front or back
    function bet(bool _isEven) external payable nonReentrant {
        require(
            msg.value > 0,
            "minimum amount needed to play the game"
        );
        if (msg.value * 2 >= getDealerBalance()){
            //contract can't process this betting
            emit GameResult(Status.Canceled);
        }else{
            //get the rand number by block number
            uint8 randNumber = generateRandomNumber(1);
            bool isEven = randNumber % 2 == 0;
            if (_isEven == isEven) {
                //user win
                transferMoney(_msgSender(), msg.value * 2);
                emit GameResult(Status.Win);
            }else{
                //user lose
                emit GameResult(Status.Lose);
            }
            
        }
        
    }

    function getDealerBalance() public view returns (uint256) {
        //return contract's balance
        return address(this).balance;
    }
    //transfer money to account
    function transferMoney(address _account, uint256 _betAmount) private {
        payable(_account).transfer(_betAmount);
    }
    //generate the random number
    function generateRandomNumber(uint256 seed) private view returns (uint8) {
        uint8 result = uint8(
            (uint256(
                keccak256(
                    abi.encodePacked(
                        tx.origin,
                        blockhash(block.number - 1),
                        block.timestamp,
                        seed
                    )
                )
            ) % 6) + 1
        );
        return result;
    }
}