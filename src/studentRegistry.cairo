use core::serde::Serde;
use starknet::ContractAddress;
#[derive(Drop, starknet::Store, Serde)]
struct Student {
    pub student_addr: starknet::ContractAddress,
    pub _name: felt252,
    pub age: u8,
}

#[starknet::interface]
pub trait IStudentRegistry<TContractState> {
    fn Register_stud(
        ref self: TContractState, student_addr: ContractAddress, _name: felt252, age: u8,
    );
    fn Get_stud(self: @TContractState, student_addr: ContractAddress) -> Student;
    fn Update_stud(
        ref self: TContractState,
        student_addr: ContractAddress,
        new_student_addr: ContractAddress,
        new_name: felt252,
        new_age: u8,
    );
    fn Delete_stud(ref self: TContractState, student_addr: ContractAddress);
}

mod Events {
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct RegisterStudent {
        // The `#[key]` attribute indicates that this event will be indexed.
        // You can also use `#[flat]` for nested structs.
        #[key]
        pub user: starknet::ContractAddress,
        pub name: felt252,
    }


    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct DeleteStudent {
        // The `#[key]` attribute indicates that this event will be indexed.
        // You can also use `#[flat]` for nested structs.
        #[key]
        pub user: starknet::ContractAddress,
        pub name: felt252,
    }


    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    pub struct UpdateStudent {
        // The `#[key]` attribute indicates that this event will be indexed.
        // You can also use `#[flat]` for nested structs.
        #[key]
        pub user: starknet::ContractAddress,
        pub name: felt252,
    }
}

#[starknet::contract]
mod StudentRegistry {
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use super::Events::*;
    use super::{IStudentRegistry, Student};


    #[storage]
    struct Storage {
        students: Map<ContractAddress, Student>,
        // let zero_address: ContractAddress = 0x000.try_into().unwrap();

    }

    #[event]
    #[derive(Copy, Drop, Debug, PartialEq, starknet::Event)]
    // The event enum must be annotated with the `#[event]` attribute.
    // It must also derive at least the `Drop` and `starknet::Event` traits.
    pub enum Event {
        RegisterStudent: RegisterStudent,
        DeleteStudent: DeleteStudent,
        UpdateStudent: UpdateStudent,
    }

    #[abi(embed_v0)]
    impl StudentRegistry of super::IStudentRegistry<ContractState> {
        fn Register_stud(
            ref self: ContractState, student_addr: ContractAddress, _name: felt252, age: u8,
        ) {
            let student = Student { student_addr, _name, age };

            self.students.write(student_addr, student);

            // emit event for the registration of Student
            self.emit(Event::RegisterStudent(RegisterStudent { user: student_addr, name: _name }));
        }

        fn Get_stud(self: @ContractState, student_addr: ContractAddress) -> Student {
            return self.students.read(student_addr);
        }

        fn Update_stud(
            ref self: ContractState,
            student_addr: ContractAddress,
            new_student_addr: ContractAddress,
            new_name: felt252,
            new_age: u8,
        ) {
            // IF a new contract address exists we'll delete the whole account 
            // with it's information, but if a new contract address does not exist we'll just change the other information
            // let zero_address: ContractAddress = 0x000.try_into().unwrap();
            self.Delete_stud(student_addr);
            self.Register_stud(new_student_addr, new_name, new_age);
            // let mut student = self.students.read(student_addr);
            // student.student_addr = 

            // student.student_addr = new_student_addr;
            // student.name = new_name;
            // student.age = new_age;

            // let updated_student = Student {
            //    student_addr: new_student_addr, _name: new_name, age: new_age,
            // };

            // self.students.write(student_addr, updated_student);

            // emit event for the registration of Student
            self.emit(Event::UpdateStudent(UpdateStudent { user: student_addr, name: new_name }));
            // let current_student =  #[derive(Drop, starknet::Store, Serde)]
        // struct Student {
        //     pub student_addr: new_student_addr,
        //     pub name: new_name,
        //     pub age: new_age,
        // }

            // student.write(current_student);
        }

        fn Delete_stud(ref self: ContractState, student_addr: ContractAddress) {
            let zero_address: ContractAddress = 0x000.try_into().unwrap();
            let student = self.students.read(student_addr);
            let student_name = student._name;

            let Deleted_student = Student { student_addr: zero_address, _name: 0, age: 0 };

            self.students.write(student_addr, Deleted_student);

            // emit event for the Deletion of Student
            self
                .emit(
                    Event::DeleteStudent(DeleteStudent { user: student_addr, name: student_name }),
                );
        }
    }
}
