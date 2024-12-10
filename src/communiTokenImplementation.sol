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

    uint256 public constant LUCKY_BONUS=3;

    uint256 public RESERVE_PERCENTAGE;

    address public RESERVE_ADDR;

    event DailyLimitReset(uint256 timestamp);
    event DailyMint(address addr,uint256 amount);
    event Reward(address to, uint256 value);

    constructor() {
        _disableInitializers();
    }

    function initialize(
        string memory name_,
        string memory symbol_,
        uint256 _maxDailyMint,
        uint256 _maxPerAccount,
        uint256 _totalSupplyCap,
        uint256 _reserve_percentage,
        address _reserve_addr,
        address _owner_addr
    ) external initializer {
        __ERC20_init(name_, symbol_);
        __Ownable_init(_owner_addr);
        maxDailyMint = _maxDailyMint;
        maxPerAccount = _maxPerAccount;
        totalSupplyCap = _totalSupplyCap;
        lastResetTimestamp = block.timestamp;
        RESERVE_PERCENTAGE=_reserve_percentage;
        RESERVE_ADDR=_reserve_addr;

        //reserve
        uint256 amount=(totalSupplyCap*_reserve_percentage)/100;
        accountMintedAmount[_reserve_addr]+=amount;
        _mint(_reserve_addr,amount);
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
        emit DailyMint(_msgSender(),amount);
    }

    function reward(address to,uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        require(accountMintedAmount[RESERVE_ADDR]-amount>=0,"No enough balance");

        transferFrom(RESERVE_ADDR,to,amount);
        accountMintedAmount[RESERVE_ADDR]-=amount;

        emit Reward(to,amount);
    }

    function _resetDailyLimitIfNeeded() internal {
        if (block.timestamp >= lastResetTimestamp + SECONDS_PER_DAY) {
            dailyMintedAmount = 0;
            lastResetTimestamp = block.timestamp;

            emit DailyLimitReset(block.timestamp);
        }
    }

    function setLucky() external onlyOwner {

    }

    function _isLuckyAddress(address account) internal view {

    }
}
