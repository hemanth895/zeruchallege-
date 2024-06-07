// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UniswapLiquidityManager {
    address public owner;
    INonfungiblePositionManager public positionManager;

    constructor(address _positionManager) {
        owner = msg.sender;
        positionManager = INonfungiblePositionManager(_positionManager);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function provideLiquidity(
        address token0,
        address token1,
        uint24 fee,
        int24 tickLower,
        int24 tickUpper,
        uint256 amount0Desired,
        uint256 amount1Desired,
        uint256 amount0Min,
        uint256 amount1Min,
        address recipient,
        uint256 deadline
    ) external onlyOwner returns (uint256 tokenId) {
        IERC20(token0).transferFrom(msg.sender, address(this), amount0Desired);
        IERC20(token1).transferFrom(msg.sender, address(this), amount1Desired);

        IERC20(token0).approve(address(positionManager), amount0Desired);
        IERC20(token1).approve(address(positionManager), amount1Desired);

        INonfungiblePositionManager.MintParams memory params = INonfungiblePositionManager.MintParams({
            token0: token0,
            token1: token1,
            fee: fee,
            tickLower: tickLower,
            tickUpper: tickUpper,
            amount0Desired: amount0Desired,
            amount1Desired: amount1Desired,
            amount0Min: amount0Min,
            amount1Min: amount1Min,
            recipient: recipient,
            deadline: deadline
        });

        (tokenId,,,) = positionManager.mint(params);
    }

    function getFees(uint256 tokenId) external view returns (uint256 amount0, uint256 amount1) {
        bytes memory data = abi.encodeWithSelector(positionManager.collect.selector, tokenId, address(this), type(uint128).max, type(uint128).max);

        (bool success, bytes memory returnData) = address(positionManager).staticcall(data);
        require(success, "Static call failed");

        (amount0, amount1) = abi.decode(returnData, (uint256, uint256));
    }
}
