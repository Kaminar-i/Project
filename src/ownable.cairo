// use starknet::ContractAddress;

// #[starknet::interface]
// pub trait IOwnableContract<TContractState> {
//     fn only_owner(ref self: TContractState);
//     fn change_owner(ref self: TContractState, new_owner: ContractAddress);
// }

// #[starknet::contract]
// mod Ownable {
//     use core::num::traits::Zero;
//     use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
//     use starknet::{ContractAddress, get_caller_address};

//     #[storage]
//     struct Storage {
//         owner: ContractAddress,
//     }

//     #[constructor]
//     fn constructor(ref self: ContractState) {
//         let caller = get_caller_address();
//         self.owner.write(caller);
//     }
    
//     #[abi(embed_v0)]
//     impl Ownable of super::IOwnableContract<ContractState> {
//         fn only_owner(ref self: ContractState) {
//             self._only_owner();
//         }

//         fn change_owner(ref self: ContractState, new_owner: ContractAddress) {
//            self._only_owner();
//            self._change_owner(new_owner);
//         }
//     }

//     #[generate_trait]
//     impl OwnableInternalImpl of OwnableInternalTrait {
//         fn _only_owner(ref self: @ContractState) {
//             assert(get_caller_address() == self.owner.read(), 'This caller is not the owner');
//         }

//         fn _change_owner(ref self: @ContractState, new_owner: ContractAddress) {
//              let current_owner = self.owner.read();
//              assert(new_owner != current_owner, 'old owner cannot be the new owner');
//              assert(new_owner.is_non_zero(), 'This is a zero address');
//              self.owner.write(new_owner);
//          }
//     }
// }
use starknet::ContractAddress;

#[starknet::interface]
pub trait IOwnable<TContractState> {
    fn get_owner(self: @TContractState) -> ContractAddress;
    fn only_owner(ref self: TContractState);
    fn change_owner(ref self: TContractState, owner: ContractAddress);
}

#[starknet::contract]
 mod Ownable {
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    #[storage]
    struct Storage {
        owner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, caller: ContractAddress){ 
        self.owner.write(caller);
    }

    #[abi(embed_v0)]
    impl Ownable of super::IOwnable<ContractState>{
        fn get_owner(self: @ContractState) -> ContractAddress {
            return self.owner.read();    
        }

        fn change_owner(ref self: ContractState, owner: ContractAddress) {
            self.only_owner();
            self.owner.write(owner);
           
        }

        fn only_owner(ref self: ContractState) {
            self._only_owner();
        }

    }

    #[generate_trait]
    pub impl OwnableInternalImpl of OwnableInternal {

        fn _only_owner(ref self: ContractState) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'this the wrong caller address ')  
        }

    }
}
