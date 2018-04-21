pragma solidity 0.4.18;

import "./MercuriusBase.sol";
import "../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title MercuriusCreator
 *
 * Superset of the ERC721 standard that allows for creating Strategy/Algorithm as a token form
 */
contract MercuriusCreator is MercuriusBase {
    using SafeMath for uint;

    event Mint(address indexed _to, uint256 indexed _tokenId);
    event SetBackTestResult(address indexed _to, uint256 indexed _tokenId, string backTestResult);

    struct Strategy {
        string          name;
        uint            dna;
        string          input;
        string          script;
        string          notifyee;
        string          start;              // e.g. 9am HKT
        string          end;                // e.g. 6pm HKT 
        uint            runningTimeRange;   // million second, it would keep running until die/error if unset
        uint            frequency;          // unit: million second
        string          backTestResult;                         
    }
    
    Strategy[] strategies;

    modifier onlyNonexistentToken(uint _tokenId) {
        require(tokenIdToOwner[_tokenId] == address(0));
        _;
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % DNA_MODULES;
    }

    function encryptScript() {

    }

    function createStrategy(string _name, string _input, string _script, string _notifyee, string _startDT, string _endDT, uint _runningTimeRange, uint _frequency) public {
        uint strategyId = strategies.push(Strategy(
            _name,
            _generateRandomDna(_name),
            _input,
            _script, //?
            _notifyee,
            _startDT,
            _endDT,
            _runningTimeRange,
            _frequency,
            "" // empty back test result at first
        ));
        _setTokenOwner(strategyId, msg.sender);
        _addTokenToOwnersList(msg.sender, strategyId);
        
        Mint(msg.sender, strategyId);
    }

    function setBackTestResult(address _owner, uint256 _strateId, string _backTestResult) public view returns (
        uint result,
        string  name,
        uint    dna,
        string  backTestResult
    ) {
        result = 0;
        // require(_owner == msg.sender);
        Strategy memory strategy = strategies[_strateId];
        strategy.backTestResult = _backTestResult;
        name = strategy.name;
        dna = strategy.dna;
        backTestResult = "";
        // backTestResult = strategy.backTestResult;
        result = 1;
    }

    function getStrategy(address _owner, uint256 _strateId)
        public
        view
        returns (
            uint    dna,
            string  input,
            string  script,
            string  notifyee,
            string  start,
            string  end,
            uint    runningTimeRange,
            uint    freq
        ) {
        // requrie() 
        Strategy memory _strategy = strategies[_strateId];
        dna = _strategy.dna;
        
        input = _strategy.input;
        script = _strategy.script;
        notifyee = _strategy.notifyee;
        start = _strategy.start;
        end = _strategy.end;
        runningTimeRange = _strategy.runningTimeRange;
        freq = _strategy.frequency;
    }
}