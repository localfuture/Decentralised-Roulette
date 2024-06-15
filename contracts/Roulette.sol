// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Roulette is ERC20, Ownable {
    using SafeMath for uint256;

    uint256 spinWheelResult;

    struct Bet {
        address player;
        uint amount;
    }

    mapping(uint => Bet)betOnEven;
    uint betOnEvenId;

    mapping(uint => Bet)betOnOdd;
    uint betOnOddId;

    mapping(uint => Bet)betOnDigit;
    uint betOnDigitId;

    // Events
    event TokensBought(address indexed player, uint256 amount);
    event BetPlaced(address indexed player, string betType, uint256 amount);
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
        uint256 amount = msg.value.mul(1000); // 1 Ether = 1000 tokens
        _mint(msg.sender, amount);
        emit TokensBought(msg.sender, amount);
    }

    function placeBetEven(uint256 betAmount) public {}

    function placeBetOdd(uint256 betAmount) public {}

    function placeBetOnNumber(uint256 betAmount, uint256 number) public {}

    function sellTokens(uint256 tokenAmount) public {}

    //================================================================
    //                      Owner Function
    //================================================================

    function spinWheel() public {}

    function transferWinnings() public {}

    function setSpinWheelResult(uint256 key) public {}

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
        address[] memory amounts = new uint[](betOnEvenId);

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
        address[] memory amounts = new uint[](betOnbetOnOddIdvenId);

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

        uint counter;

        for(uint i = 0; i <= 36; i++) {
            if (betOnDigit[i].player != address(0)) {
                players[counter] = betOnDigit[counter].player;
                digits[counter] = i;
                amounts[counter] = betOnDigit[counter].amount;
                counter++;
            }
        }

        return (players, digits, amounts);
    }
}
