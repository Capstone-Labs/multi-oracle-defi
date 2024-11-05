// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract CapstoneUSD is ERC20 {
    AggregatorV3Interface public priceFeed;

    constructor() ERC20("CapstoneUSD", "CUSD") {
        // Mint some initial tokens for the contract's liquidity pool
        _mint(address(this), 1000000 * 10 ** 18); // 1 million CUSD tokens

        //  Chainlink price feed for ETH/USD on Sepolia testnet
        priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    // Mint function to mint new tokens (for simplicity)
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    // Function to buy CUSD tokens using ETH
    function buy() external payable {
        // Get the latest ETH/USD price from Chainlink
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // Calculate the CUSD amount to mint based on the ETH amount sent and the current price
        uint256 cusdAmount = (msg.value * uint256(price)) / (10 ** 8);
        _mint(msg.sender, cusdAmount * 10 ** 18);
    }
}