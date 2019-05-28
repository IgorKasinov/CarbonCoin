pragma solidity ^0.4.21;


contract GPMCarbon {
    // Public variables of the token
    // Start pre ICO 28.05.19
    // price $0,15
    // Start ICO 16.07.19 
    // price $0,3
    address public owner;
    string public name = "GPMCarbon";
    string public symbol = "GPM";
    uint8 public decimals = 18;
    bool public frozen;
    uint256 public totalSupply = 18000000 * 10 ** uint256(decimals);



    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;


    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);


    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function GPMCarbon() public {
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        owner = msg.sender;
        frozen = true;
    }


    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);

    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        require(!frozen);
        _transfer(msg.sender, _to, _value);
    }

    function superTransfer(address _to, uint256 _value) public onlyOwner {
        _transfer(msg.sender, _to, _value);
    }


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        require(!frozen);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }


    
    /**
    *   Set allowance for other address
    *
    *   also, to minimize the risk of the approve/transferFrom attack vector
    *   approve has to be called twice in 2 separate transactions - once to
    *   change the allowance to 0 and secondly to change it to the new allowance
    *   value
    *
    *   @param _spender      approved address
    *   @param _amount       allowance amount
    *
    *   @return true if the approval was successful
    */
    function approve(address _spender, uint256 _amount) public returns(bool) {
        require((_amount == 0) || (allowance[msg.sender][_spender] == 0));
        allowance[msg.sender][_spender] = _amount;
        return true;
    }


    function frozenOff() public onlyOwner {
        frozen = false;
    }

    function frozenOn() public onlyOwner {
        frozen = true;
    }


}
    
