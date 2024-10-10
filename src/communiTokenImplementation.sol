// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
/**
 * @title CommuniTokenImplementation
 * @dev 实现合约，包含所有逻辑
 */
contract CommuniTokenImplementation is Initializable, ERC20Upgradeable, OwnableUpgradeable {
    uint256 public constant SECONDS_PER_DAY = 86400;

    uint256 public maxDailyMint;
    uint256 public maxPerAccount;
    uint256 public totalSupplyCap;

    mapping(address => uint256) public lastMintTimestamp;
    mapping(address => uint256) public accountMintedAmount;

    uint256 public dailyMintedAmount;
    uint256 public lastResetTimestamp;

    event DailyLimitReset(uint256 timestamp);

    constructor() {
        _disableInitializers();
    }

    function initialize(
        string memory name_,
        string memory symbol_,
        uint256 _maxDailyMint,
        uint256 _maxPerAccount,
        uint256 _totalSupplyCap
    ) external initializer {
        __ERC20_init(name_, symbol_);
        __Ownable_init(_msgSender());
        maxDailyMint = _maxDailyMint;
        maxPerAccount = _maxPerAccount;
        totalSupplyCap = _totalSupplyCap;
        lastResetTimestamp = block.timestamp;
    }

    function mint(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(totalSupply() + amount <= totalSupplyCap, "Exceeds total supply cap");

        _resetDailyLimitIfNeeded();

        require(dailyMintedAmount + amount <= maxDailyMint, "Exceeds daily mint limit");
        require(accountMintedAmount[_msgSender()] + amount <= maxPerAccount, "Exceeds account mint limit");

        dailyMintedAmount += amount;
        accountMintedAmount[_msgSender()] += amount;
        lastMintTimestamp[_msgSender()] = block.timestamp;

        _mint(_msgSender(), amount);
    }

    function _resetDailyLimitIfNeeded() internal {
        if (block.timestamp >= lastResetTimestamp + SECONDS_PER_DAY) {
            dailyMintedAmount = 0;
            lastResetTimestamp = block.timestamp;
            emit DailyLimitReset(block.timestamp);
        }
    }

    function _isLuckyAddress(address account) internal view {

    }
}
