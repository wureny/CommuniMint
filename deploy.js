const ethers = require('ethers');
require('dotenv').config();

async function deployNewToken() {
    // 配置 Provider
    const provider = new ethers.JsonRpcProvider("");

    // 配置签名者
    const privateKey = "";
    const signer = new ethers.Wallet(privateKey, provider);

    // TokenFactory 合约地址和 ABI
    const factoryAddress = "0x830a8d5F180D66a41FB1d819b7334f5026670eb8";
    const factoryABI = [
        "function deployToken(string memory name, string memory symbol, uint256 maxDailyMint, uint256 maxPerAccount, uint256 totalSupplyCap, uint256 reservePer, address reserveAddr, address owner_addr) external returns (address)",
        "event TokenDeployed(address indexed tokenAddress, address indexed ownerAddress, string name, string symbol)"
    ];

    // 创建合约实例
    const factory = new ethers.Contract(factoryAddress, factoryABI, signer);

    // 设置部署参数
    const tokenParams = {
        name: "WoW",
        symbol: "WoW",
        maxDailyMint: ethers.parseEther("30000"),  // 每日最大铸造量
        maxPerAccount: ethers.parseEther("10000000"),   // 每账户最大持有量
        totalSupplyCap: ethers.parseEther("10000000"), // 总供应量上限
        reservePer: 30, // 30% 保留比例
        reserveAddr: "0xc1e4400506b6178ff92ed8a353e996a3227ed877", // 保留代币接收地址
        owner_addr: "0xc1e4400506b6178ff92ed8a353e996a3227ed877"     // 代币合约拥有者地址
    };

    try {
        console.log("Deploying new token...");

        // 调用 deployToken 函数
        const tx = await factory.deployToken(
            tokenParams.name,
            tokenParams.symbol,
            tokenParams.maxDailyMint,
            tokenParams.maxPerAccount,
            tokenParams.totalSupplyCap,
            tokenParams.reservePer,
            tokenParams.reserveAddr,
            tokenParams.owner_addr
        );

        // 等待交易确认
        console.log("Transaction hash:", tx.hash);
        const receipt = await tx.wait();

        // 从事件中获取部署的代币地址
        // 使用 queryFilter 获取事件
        const events = await factory.queryFilter(
            factory.filters.TokenDeployed(),
            receipt?.blockNumber,
            receipt?.blockNumber
        );
        const deployedTokenAddress = events[0].args[0];



        console.log("New token deployed at:", deployedTokenAddress);
        return deployedTokenAddress;

    } catch (error) {
        console.error("Error deploying token:", error);
        throw error;
    }
}

// 运行部署函数
deployNewToken()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });