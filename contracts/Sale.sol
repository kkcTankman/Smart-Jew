pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract JewSale is Ownable {
    mapping(address => bool) public acceptedTokens;
    mapping(address => uint256) public pricePerTokens;
    // 15 cents till 1 million saved
    // 20 cents till 2 million saved
    // 25 cents till 3 million saved
    // 30 cents till 4 million saved
    // 35 cents till 5 million saved
    // 40 cents till 6 million saved
    address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public marketingWallet;
    address public JewAddress;

    constructor(address _jewAddress) {
        acceptedTokens[USDT] = true;
        acceptedTokens[USDC] = true;
        pricePerTokens[USDT] = (2 * 10 ** 18) / 10 ** 6;
        pricePerTokens[USDC] = (2 * 10 ** 18) / 10 ** 6;
        marketingWallet = 0xe3FDc39e56578A24f24096dc9D56ae349664E921;
        JewAddress = _jewAddress;
    }

    function changeMarketingWallet(address _newWallet) external onlyOwner {
        marketingWallet = _newWallet;
    }

    function changeJewAddress(address _newWallet) external onlyOwner {
        JewAddress = _newWallet;
    }

    function setAcceptedTokens(
        address _addr,
        bool _accept,
        uint256 _price
    ) external onlyOwner {
        acceptedTokens[_addr] = _accept;
        pricePerTokens[_addr] = _price; // how much to be accepted - e.g. 0.5$ -> 2 * 10 ** 18 / 10 **6
    }

    function getJewcoinPrice() public view returns (uint256) {
        return ((1 / pricePerTokens[USDT]) * 10 ** 18) / 10 ** 6;
    }

    function calcAmountToBeReceived(
        address _tokenAddress,
        uint256 _amount
    ) public view returns (uint256) {
        if (
            acceptedTokens[_tokenAddress] == false ||
            pricePerTokens[_tokenAddress] == 0
        ) return 0;
        return _amount * pricePerTokens[_tokenAddress];
    }

    function buyTokenByStable(
        address _tokenAddr,
        uint256 _tokenAmount
    ) external {
        require(acceptedTokens[_tokenAddr] == true, "Token not accepted");
        require(pricePerTokens[_tokenAddr] != 0, "Token not accepted");
        ERC20(_tokenAddr).transferFrom(
            msg.sender,
            marketingWallet,
            _tokenAmount
        );
        ERC20(JewAddress).transferFrom(
            marketingWallet,
            msg.sender,
            calcAmountToBeReceived(_tokenAddr, _tokenAmount)
        );
    }

    function buyTokenByETH(
        address _to,
        uint256 _amount,
        uint256 _tokenAmount
    ) external payable {
        require(msg.value == _tokenAmount, "Invalid ETH amount");

        payable(_to).transfer(_amount);
        ERC20(JewAddress).transferFrom(
            marketingWallet,
            msg.sender,
            _tokenAmount
        );
    }
}
