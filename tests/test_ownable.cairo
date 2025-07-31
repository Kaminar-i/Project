use project::ownable::{
    IOwnableDispatcher, IOwnableDispatcherTrait, IOwnableSafeDispatcher,
    IOwnableSafeDispatcherTrait,
};

use snforge_std::{
    ContractClassTrait, DeclareResultTrait, EventSpyAssertionsTrait, declare, spy_events,
    start_cheat_caller_address,  stop_cheat_account_contract_address
};

use starknet::ContractAddress;
// const ADMIN: felt252 = 5382942;

// fn __setup__() -> ContractAddress {
//     // deploy jolt contract
//     let ownable_contract = declare("Ownable").unwrap().contract_class();
//     let admin_address:  ContractAddress = 1234.try_into().unwrap();
//     // let admin: ContractAddress = 5382942.try_into().unwrap();
//     let mut ownable_constructor_call_data = array![admin_address.into()];
//     let (ownable_contract_address, _) =  ownable_contract.deploy(@ownable_constructor_call_data).unwrap();
//     return ownable_contract_address;
    
//     // return ownable_contract_address;
// }

// fn deploy() -> IOwnableDispatcher {
//     let contract_class = declare("Ownable").unwrap().contract_class();
//     let admin_address:  ContractAddress = 1234.try_into().unwrap();
//     // let contract = declare(name).unwrap().contract_class();
//     let mut constructor_call_data = array![];
//     admin_address.serialize(ref constructor_call_data);
//     let (contract_address, _) = contract_class.deploy(@constructor_call_data).unwrap();
//     (IOwnableDispatcher {contract_address})
// }

fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let mut constructor_call_data = array![];
    let admin_address:  ContractAddress = 1234.try_into().unwrap();
     admin_address.serialize(ref constructor_call_data);
    let (contract_address, _) = contract.deploy(@constructor_call_data).unwrap();
    contract_address
}

#[test]
fn test_can_get_owner() {
    // let  contract_address = __setup__();
      let contract_address = deploy("Ownable");
       let ownable_dispatcher = IOwnableDispatcher { contract_address };
    // let contract_address = deploy();
    let fake_caller: ContractAddress = 1234.try_into().unwrap();
    // let first_caller: ContractAddress = 5382942.try_into().unwrap();

    // let ownable_dispatcher = IOwnableDispatcher { contract_address};
    // let contract_address = deploy("Ownable");

    // let ownable_dispatcher = IOwnableDispatcher {contract_address};

    let  caller = ownable_dispatcher.get_owner();
    
    // start_cheat_caller_address(contract_address,caller);

    assert_eq!(caller, fake_caller);

    // stop_cheat_account_contract_address(contract_address);
}
