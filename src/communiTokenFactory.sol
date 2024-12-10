// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@communiToken/communiTokenImplementation.sol";

/**
 * @title CommuniTokenFactory
 * @dev 工厂合约，用于创建和管理CommuniToken实例
 */
contract CommuniTokenFactory is Ownable {
    using Clones for address;

    address public implementationContract;
    address[] public deployedTokens;

    event TokenDeployed(address indexed tokenAddress, address indexed ownerAddress, string name, string symbol);

    constructor(address _implementationContract) Ownable(_msgSender()){
        implementationContract = _implementationContract;
    }

    function deployToken(
        string memory name,
        string memory symbol,
        uint256 maxDailyMint,
        uint256 maxPerAccount,
        uint256 totalSupplyCap,
        uint256 reservePer,
        address reserveAddr,
        address owner_addr
    ) external onlyOwner returns (address) {
        address clone = implementationContract.clone();
        CommuniTokenImplementation(clone).initialize(name, symbol, maxDailyMint, maxPerAccount, totalSupplyCap,reservePer,reserveAddr,owner_addr);

        //CommuniTokenImplementation(clone).transferOwnership(_msgSender());

        deployedTokens.push(clone);
        emit TokenDeployed(clone, owner_addr, name, symbol);

        return clone;
    }

    function getDeployedTokens() external view returns (address[] memory) {
        return deployedTokens;
    }
}