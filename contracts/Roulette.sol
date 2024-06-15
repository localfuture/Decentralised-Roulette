// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Roulette is ERC20 {
    uint256 public SpinWheelResult;

    constructor() ERC20("Roulette", "RLT") {}

    function setSpinWheelResult(uint256 key) public {}

    function buyTokens() public {}

    function placeBetEven(uint256 betAmount) public {}

    function placeBetOdd(uint256 betAmount) public {}

    function placeBetOnNumber(uint256 betAmount, uint256 number) public {}

    function spinWheel() public {}

    function sellTokens(uint256 tokenAmount) public {}

    function transferWinnings() public {}

    function checkBalance() public view returns (uint256) {}

    function checkWinningNumber() public view returns (uint256) {}

    function checkBetsOnEven()
        public
        view
        returns (address[] memory, uint256[] memory)
    {}

    function checkBetsOnOdd()
        public
        view
        returns (address[] memory, uint256[] memory)
    {}

    function checkBetsOnDigits()
        public
        view
        returns (
            address[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {}
}
