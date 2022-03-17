// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Faucet is Ownable, ReentrancyGuard{
    
    using SafeMath for uint256;

    mapping (address => uint) timeouts;

    uint256 public FaucetBlockCount;
    uint256 public FaucetAmount;
    bool public isInitialized;

    
    event Withdrawal(address indexed to);
    event Deposit(address indexed from, uint amount);
    
    constructor(uint256 amount,uint256 waitblockcount) {
        //Will be called on creation of the smart contract.
        FaucetAmount = amount; // 1 coinbase
        FaucetBlockCount = waitblockcount; // 6 hrs //blocktime 4s

    }

    function initialize(
        address _admin,
        uint256 _BlockCount,
        uint256 _faucetAmount
    )external{

        if(!isInitialized){

        FaucetBlockCount = _BlockCount;
        if(_BlockCount <= 0){
            FaucetBlockCount= 5400;
        }
        FaucetAmount = _faucetAmount;
        if(_faucetAmount <= 0){
             FaucetAmount = 1000000000000000000;
        }
        transferOwnership(_admin);
        isInitialized = true;
     }


    }
    
    //  Sends 1 ETH to the sender when the faucet has enough funds
    //  Only allows one withdrawal every 6 hrs
    function requestFaucet(address payable _requestor) external nonReentrant  {
        
        require(address(this).balance >= FaucetAmount, "This faucet is empty. Please check back later.");
        require(isInFaucetPeriod(_requestor), "You can only withdraw once every 6 hrs. Please check back later.");
        
        //sent
        _requestor.transfer(FaucetAmount);
        timeouts[_requestor] = block.timestamp;
        
        emit Withdrawal(_requestor);
    }
    
    //  Sending Tokens to this faucet fills it up
    receive() external payable {
        emit Deposit(msg.sender, msg.value); 
    } 
    
    
    //  Destroys this smart contract and sends all remaining funds to the owner
    function destroy(address payable _owner)external nonReentrant onlyOwner {
        require(msg.sender == _owner, "Only the owner of this faucet can destroy it.");
        selfdestruct(_owner);
    }

    function isInFaucetPeriod(address  _requestor) public view returns (bool faucetRelese) {
        faucetRelese = (block.number >= nextFaucet(_requestor));
    }
    
    function nextFaucet(address  _requestor) public  view returns (uint256) {
        uint256 lastFaucet = timeouts[_requestor];

        if(lastFaucet > 0){
            return lastFaucet.add(FaucetBlockCount);

        }else{
           return block.number;

        }
    }
}