pragma solidity ^0.8.12;

interface ERC20Interface {
    /*function name() external view returns (string);
    function symbol() external view returns (string);
    function decimals() external view returns (uint8);*/
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract SafeMath{

    function safeAdd(uint x, uint y) public pure returns (uint z){
        z = x + y;
        require (z >= x);
    }

    function safeSub(uint x, uint y) public pure returns (uint z){
        require(y <= x);
        z = x - y;
    }

    function safeMul(uint x, uint y) public pure returns (uint z) {
        z = x * y;
        require(x == 0 || z / x == y);
    }

    function safeDiv(uint x, uint y) public pure returns (uint z) {
        require(y > 0);
        z = x / y;
    }


}

contract testToken is SafeMath, ERC20Interface{

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public{
        symbol = "97A53EB0";
        name = "6ACC11CB";
        decimals = 18;
        _totalSupply = 100000;
        balances[0x02d3EBF29Ce3e3f103BA06CbF54d2f9876122670] = _totalSupply;
    } 

    /*function name() public override view returns (string){
        return name;
    }
    function symbol() public override view returns (string){
        return symbol;
    }
    function decimals() public override view returns (uint8){
        return decimals;
    }*/
    function totalSupply() public override view returns (uint256){
        return _totalSupply;
    }
    function balanceOf(address _owner) public override view returns (uint256 balance){
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) public override returns (bool success){
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        balances[_from] = safeSub(balances[_from], _value);
        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public override view returns (uint256 remaining){
        return allowed[_owner][_spender];
    }


}