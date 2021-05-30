pragma solidity >=0.4.6;

//Contrato destinado a estrutura lógica de um "call" de um derivativo 
//Diversas funcionalidades necessitam ser implementadas

contract derivative {
    
    
    struct Option {
        address _id;
        uint _data;
        uint _dueDate;
        bool _exists;
        int _premium;
    }

    struct Margin {
        uint _data;
        uint _valor;
        address _dono;
        
    }
    
    //criar oraculo para consulta externa dos valores e comparar com strike definido    
    uint oraculo;
    
    Margin [] margins;
    
    mapping (address => Option) private options;
    
    address [] public optionHolders;
    
    address public owner;
    
    constructor  () {
        owner = msg.sender;
        optionHolders.length = 0;
    }
    
    //função permite que seja depositado valor para margins
    function depositMargin (uint) public payable {
        margins.push(Margin({
            _data : now,
            _valor: msg.value,
            _dono : msg.sender
            
        }));
    }
    
    //verifica se o contrato possui saldo de margin
    function checkMargin () public view returns (
        uint _data,
        uint _saldo
    ){
        return (
            _data,
            address(this).balance
            );
    }
    
    //verifica se o contrato existe, consulta só pode ser feita pelo address criador do contrato (holder)
    function getOpttions () public view returns (
        uint _data,
        uint _vencimento,
        bool _exists,
        int _premium
    ){
        return (
            options[msg.sender]._data,
            options[msg.sender]._dueDate,
            options[msg.sender]._exists,
            options[msg.sender]._premium
            );
    }
 
    //Função que cria a opção, na pratica o put
    //vai receber a margem e o premio
    function callOption (uint) public payable returns (bool) {
        
        if(!options[msg.sender]._exists) {
            options[msg.sender] = Option ({
                _id : msg.sender,
                _data : now,
                _dueDate : now + 335 days,
                _exists : true,
                _premium : int(msg.value)
                
            });
            
        }
        
        return true;
    }
    
    //Aqui o holder solicita o pagamento, nesta função haverá uma consulta (laço) ao oraculo para verificar 
    //se o strike foi atingido
    //necessário implementar a data minima de saque
    function claimOption () public returns (bool) {
        if(options[msg.sender]._id == msg.sender) {
            //necessario consulta ao oraculo para ver se condições atingiram o strike
            //setado como true por conveniêcia
            if (true) {
                msg.sender.transfer(1 ether);
            }
        }
        return true;
    }
    
    //Aqui o owner dos contratos solicita retirada dos valores
    function withdrawMoney (uint _lucro) public returns (bool) {
        if (msg.sender == owner) {
            msg.sender.transfer(_lucro);
        } return true;
        return false;
    }    
    
}
