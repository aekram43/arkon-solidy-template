// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20WrapperUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "hardhat/console.sol";

contract SKONUpgradeable is
    Initializable,
    ERC20Upgradeable,
    ERC20WrapperUpgradeable,
    PausableUpgradeable,
    ERC20BurnableUpgradeable,
    OwnableUpgradeable
{
    using SafeMathUpgradeable for uint256;

    uint256 public depositFee;
    uint256 public withdrawFee;
    address public feeCollector;
    address private candidateOwner;

    uint256 private constant FEE_DENOMINATOR = 10**10;

    event NewCandidateOwner(address candidateOwner);
    event NewFeeCollector(address feeCollector);
    event DepositFor(
        address account,
        uint256 amount,
        uint256 amountAfterFee,
        uint256 fee
    );
    event WithdrawTo(
        address account,
        uint256 amount,
        uint256 amountAfterFee,
        uint256 fee
    );

    function initialize(
        address _underlying,
        uint256 _depositFee,
        uint256 _withdrawFee,
        address _feeCollector
    ) public initializer {
        __ERC20_init("Arkon Stablecoin Token", "$KON");
        __ERC20Wrapper_init(IERC20Upgradeable(_underlying));
        __ERC20Burnable_init();
        __Pausable_init();
        __Ownable_init();

        require(_underlying != address(0), "_feeCollector must != zero addr");
        require(_underlying != address(0), "_feeCollector must != zero addr");
        depositFee = _depositFee;
        withdrawFee = _withdrawFee;
        feeCollector = _feeCollector;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    function calculateDepositFee(uint256 amount)
        external
        view
        returns (uint256 _fee, uint256 _amountAfterFee)
    {
        _fee = amount.mul(depositFee).div(FEE_DENOMINATOR);
        _amountAfterFee = amount.sub(_fee);
    }

    function calculateWithdrawFee(uint256 amount)
        external
        view
        returns (uint256 _fee, uint256 _amountAfterFee)
    {
        _fee = amount.mul(withdrawFee).div(FEE_DENOMINATOR);
        _amountAfterFee = amount.sub(_fee);
    }

    function depositFor(address _account, uint256 _amount)
        public
        virtual
        override
        returns (bool)
    {
        (uint256 fee, uint256 amountAfterFee) = this.calculateDepositFee(
            _amount
        );
        SafeERC20Upgradeable.safeTransferFrom(
            underlying,
            _msgSender(),
            address(this),
            amountAfterFee
        );
        SafeERC20Upgradeable.safeTransferFrom(
            underlying,
            _msgSender(),
            feeCollector,
            fee
        );
        _mint(_account, amountAfterFee);
        emit DepositFor(_account, _amount, amountAfterFee, fee);
        return true;
    }

    function withdrawTo(address _account, uint256 _amount)
        public
        virtual
        override
        returns (bool)
    {
        (uint256 fee, uint256 amountAfterFee) = this.calculateWithdrawFee(
            _amount
        );
        _burn(_msgSender(), _amount);
        SafeERC20Upgradeable.safeTransfer(underlying, _account, amountAfterFee);
        SafeERC20Upgradeable.safeTransfer(underlying, feeCollector, fee);
        emit WithdrawTo(_account, _amount, amountAfterFee, fee);
        return true;
    }

    function setFeeCollector(address _feeCollector) external onlyOwner {
        require(_feeCollector != address(0), "_feeCollector must != zero addr");
        feeCollector = _feeCollector;
        emit NewFeeCollector(_feeCollector);
    }

    // Owner transfer
    function renounceOwnership() public view override onlyOwner {
        revert("Renounce ownership not allowed");
    }

    function transferOwnership(address _candidateOwner)
        public
        override
        onlyOwner
    {
        require(_candidateOwner != address(0), "Ownable: No zero address");
        candidateOwner = _candidateOwner;
        emit NewCandidateOwner(_candidateOwner);
    }

    function claimOwnership() external {
        require(candidateOwner == msg.sender, "Ownable: Not the candidate");
        address oldOwner = owner();
        _transferOwnership(candidateOwner);
        candidateOwner = address(0);
        emit OwnershipTransferred(oldOwner, candidateOwner);
    }
}