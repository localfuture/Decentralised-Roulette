// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract Roulette is ERC20, Ownable {
    using Math for uint256;

    uint256 spinWheelResult;
    bool spinWheelChecker = false;

    struct Bet {
        address player;
        uint amount;
    }

    enum BetType { None, Even, Odd, Number }

    mapping(uint => Bet)betOnEven;
    uint betOnEvenId;

    mapping(uint => Bet)betOnOdd;
    uint betOnOddId;

    mapping(uint => Bet)betOnDigit;
    uint betOnDigitId;

    // Events
    event TokensBought(address indexed player, uint256 amount);
    event BetPlaced(address indexed player, BetType, uint256 amount);
    event SpinResult(uint256 number);
    event TokensSold(address indexed player, uint256 amount);
    event WinningsTransferred(address indexed player, uint256 amount);

    constructor() ERC20("Roulette", "RLT") Ownable(msg.sender) {}

    //================================================================
    //                      Player Function
    //================================================================

    /**
     * @dev This function allows players to buy the ERC20 tokens.
     * This function mints the token to the callers address.
     * Players send Ether to the contract and receive an equivalent amount of tokens in return.
     */
    function buyTokens() public payable {
        require(msg.value > 0, "Ether value must be greater than 0");
        (,uint ethValue) = msg.value.tryDiv(1 ether); 
        (,uint amount) = ethValue.tryMul(1000); // 1 Ether = 1000 tokens
        _mint(msg.sender, amount);
        emit TokensBought(msg.sender, amount);
    }

    /**
     * @dev This function allows players to place bets on the roulette landing 
     * on an even number and the amount of tokens bet are burned by the contract.
     * @param betAmount bet amount
     */
    function placeBetEven(uint256 betAmount) public {
        require(balanceOf(msg.sender) >= betAmount, "Insufficient");
        _transfer(msg.sender, address(this), betAmount);
        betOnEven[betOnEvenId].player = msg.sender;
        betOnEven[betOnEvenId].amount = betAmount;
        betOnEvenId++;
        emit BetPlaced(msg.sender, BetType.Even, betAmount);
    }

    /**
     * @dev This function allows players to place bets on the roulette landing 
     * on an odd number and the amount of tokens bet are burned by the contract.
     * @param betAmount bet amount
     */
    function placeBetOdd(uint256 betAmount) public {
        require(balanceOf(msg.sender) >= betAmount, "Insufficient");
        _transfer(msg.sender, address(this), betAmount);
        betOnOdd[betOnOddId].player = msg.sender;
        betOnOdd[betOnOddId].amount = betAmount;
        betOnOddId++;
        emit BetPlaced(msg.sender, BetType.Odd, betAmount);
    }

    /**
     * @dev This function allows players to place bets on the roulette landing 
     * on a specific number and the amount of tokens bet are burned by the contract. 
     * The number should be within the range of 0 to 36 inclusive.
     * @param betAmount bet amount
     * @param number number
     */
    function placeBetOnNumber(uint256 betAmount, uint256 number) public {
        require(balanceOf(msg.sender) >= betAmount, "Insufficient");
        require(number <= 36, "Below 37");
        require(betOnDigit[number].player == address(0), "Already betted");
        _transfer(msg.sender, address(this), betAmount);
        betOnDigit[number].player = msg.sender;
        betOnDigit[number].amount = betAmount;
        betOnDigitId++;
        emit BetPlaced(msg.sender, BetType.Number, number);
    }

    /**
     * @dev This function allows players to sell their tokens and receive Ether in return. 
     * The tokens sold are burned by the contract.The exchange rate of tokens to Ether 
     * is the same as when buying tokens.
     * @param tokenAmount token amount
     */
    function sellTokens(uint256 tokenAmount) public {
        require(tokenAmount > 0, "Token amount");
        require(balanceOf(msg.sender) >= tokenAmount, "No token");
        _burn(msg.sender, tokenAmount);
        (, uint eth) = tokenAmount.tryDiv(1000);
        payable(msg.sender).transfer(eth);
        emit TokensSold(msg.sender, tokenAmount);
    }

    //================================================================
    //                      Owner Function
    //================================================================

    /**
     * @dev This function simulates the spinning of the roulette wheel 
     * and determines the winning bet. It should generate a random number 
     * between 0 and 36 inclusive, and it sets the variable SpinWheelResultwith 
     * the generated random number.This function can be called only by the owner.
     */
    function spinWheel() public onlyOwner {
        // TODO: Rework using Chainlink VRF
        bytes32 blockHash = blockhash(block.number - 1); // Get previous block hash
        spinWheelResult = uint256(blockHash) % 37; // random number between 0 to 36 inclusive
        spinWheelChecker = true;
        emit SpinResult(spinWheelResult);
    }

    /**
     * @dev This function can be called only by the owner and only after spinWheel 
     * function has been called. This function mint and transfers the winning amount 
     * of tokens according to the generated random number and the bets.
     */
    function transferWinnings() public onlyOwner {
        require(spinWheelChecker, "Spin wheel");
        
        Bet memory winnerDetail = betOnDigit[spinWheelResult];

        if (winnerDetail.player != address(0)) {
            (, uint bet) = winnerDetail.amount.tryMul(1800);
            (, uint betOwn) = bet.tryDiv(100);
            (, uint finl) = betOwn.tryAdd(winnerDetail.amount);
            _mint(winnerDetail.player, finl);
            emit WinningsTransferred(winnerDetail.player, betOwn);
        }

        if ( spinWheelResult % 2 == 0) {
            for(uint i = 0; i < betOnEvenId; i++) {
                (, uint bet) = betOnEven[i].amount.tryMul(80);
                (, uint betOwn) = bet.tryDiv(100);
                (, uint finl) = betOwn.tryAdd(betOnEven[i].amount);
                _mint(betOnEven[i].player, finl);
            }
        } else {
            for(uint i = 0; i < betOnOddId; i++) {
                (, uint bet) = betOnOdd[i].amount.tryMul(80);
                (, uint betOwn) = bet.tryDiv(100);
                (, uint finl) = betOwn.tryAdd(betOnOdd[i].amount);
                _mint(betOnOdd[i].player, finl);
            }
        }
    }

    /**
     * @dev This function allows to manually set the result of the spin wheel 
     * for testing purposes to ensure the integrity and functionality of the contract. 
     * The function takes a single parameter, which is the desired result of the spin wheel. 
     * The function then sets the SpinWheelResult variable with the passed parameter.
     */
    function setSpinWheelResult(uint256 key) public onlyOwner {
        spinWheelResult = key;
        spinWheelChecker = true;
    }

    //================================================================
    //                      View Function
    //================================================================

    /**
     * @dev This function returns the balance of ERC20 tokens for the player who calls this function.
     * @return The balance of ERC20 tokens for the player who calls this function
     */
    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    /**
     * @dev This function returns the winning number after the roulette wheel has been spun.
     * @return The winning number after the roulette wheel has been
     */
    function checkWinningNumber() public view returns (uint256) {
        return spinWheelResult;
    }

    /**
     * @dev This function returns the array of address that have bet on the Even result of spin 
     * and amount array which shows how much that address has bet in the current round of spin.
     * @return Array of address that have bet on the Even result of spin
     * @return Array of amount that have bet on the Even result of spin
     */
    function checkBetsOnEven() public view returns (address[] memory, uint256[] memory) {
        address[] memory players = new address[](betOnEvenId);
        uint[] memory amounts = new uint[](betOnEvenId);

        for(uint i = 0; i < betOnEvenId; i++) {
            players[i] = betOnEven[i].player;
            amounts[i] = betOnEven[i].amount;
        }

        return (players, amounts);
    }

    /**
     * @dev This function returns the list of address that have bet on the 
     * Odd result of spin and amount array which shows how much that address 
     * has bet in the current round of spin.
     * @return The list of address that have bet on the Odd Results
     * @return The list of amount that have bet on the Odd Results
     */
    function checkBetsOnOdd() public view returns (address[] memory, uint256[] memory) {
        address[] memory players = new address[](betOnOddId);
        uint[] memory amounts = new uint[](betOnOddId);

        for(uint i = 0; i < betOnOddId; i++) {
            players[i] = betOnOdd[i].player;
            amounts[i] = betOnOdd[i].amount;
        }

        return (players, amounts);
    }

    /**
     * @dev This function returns the list of address that have bet on the Digits
     * @return The Array of address that have bet on digits
     * @return The Array of bet numbers
     * @return The Array of bet amounts
     */
    function checkBetsOnDigits() public view returns (address[] memory, uint256[] memory, uint256[] memory) {
        address[] memory players = new address[](betOnDigitId);
        uint[] memory digits = new uint[](betOnDigitId);
        uint[] memory amounts = new uint[](betOnDigitId);
        uint count = 0;

        for(uint i = 0; i < 37; i++) {
            if (betOnDigit[i].player != address(0)) {
                players[count] = betOnDigit[i].player;
                digits[count] = i;
                amounts[count] = betOnDigit[i].amount;
                count++;
            }
        }

        return (players, digits, amounts);
    }
}
