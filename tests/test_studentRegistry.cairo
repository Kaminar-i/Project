use project::studentRegistry::{
    IStudentRegistryDispatcher, IStudentRegistryDispatcherTrait, IStudentRegistrySafeDispatcher,
    IStudentRegistrySafeDispatcherTrait,
};
use snforge_std::{
    ContractClassTrait, DeclareResultTrait, EventSpyAssertionsTrait, declare, spy_events,
    start_cheat_caller_address,
};
use starknet::ContractAddress;

fn deploy(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    contract_address
}

#[test]
fn test_can_register_and_get_student() {
    //Contract Deployment and contract dispatcher
    let contract_address = deploy("StudentRegistry");
    let student_dispatcher = IStudentRegistryDispatcher { contract_address };

    // Address Definitions
    let zero_address: ContractAddress = 0x000.try_into().unwrap();
    let fake_caller: ContractAddress = 1234.try_into().unwrap();

    // First function test call assertion before state change
    let Student = student_dispatcher.Get_stud(fake_caller);

    assert_eq!(Student.student_addr, zero_address);
    assert_eq!(Student._name, 0);
    assert_eq!(Student.age, 0);

    // Second Function Call and Assertion, for and after state change, Register student and Get
    // Student Functions at work here and their assertion
    let _initial_student = student_dispatcher.Register_stud(fake_caller, 'Adetumilara', 20);
    let Student = student_dispatcher.Get_stud(fake_caller);

    assert_eq!(Student.student_addr, fake_caller);
    assert_eq!(Student._name, 'Adetumilara');
    assert_eq!(Student.age, 20);
}

// From here.....
#[test]
fn test_can_update_Student() {
    // Deployment of our contract
    let contract_address = deploy("StudentRegistry");
    let student_dispatcher = IStudentRegistryDispatcher { contract_address };

    // Declaration and definition of Our addresses
    let fake_caller: ContractAddress = 1234.try_into().unwrap();
    let new_caller: ContractAddress = 2345.try_into().unwrap();
    let zero_address: ContractAddress = 0x000.try_into().unwrap();

    // Two function calls to register and to get a student and their assertion
    let _initial_student = student_dispatcher.Register_stud(fake_caller, 'Adetumilara', 20);
    let student = student_dispatcher.Get_stud(fake_caller);

    assert_eq!(student.student_addr, fake_caller);
    assert_eq!(student._name, 'Adetumilara');
    assert_eq!(student.age, 20);

    // Function call to Update student and Get student and their Assertion
    let _updated_student = student_dispatcher.Update_stud(fake_caller, new_caller, 'Justice', 22);
    let student = student_dispatcher.Get_stud(new_caller);

    assert_eq!(student.student_addr, new_caller);
    assert_eq!(student._name, 'Justice');
    assert_eq!(student.age, 22);

    let student = student_dispatcher.Get_stud(fake_caller);

    // assert_eq!(student.student_addr, zero_address);
    assert_eq!(student._name, 0);
    assert_eq!(student.age, 0);
}

#[test]
fn test_can_Delete_Student() {
    // Deployment of our contract
    let contract_address = deploy("StudentRegistry");
    let student_dispatcher = IStudentRegistryDispatcher { contract_address };

    // Declaration and definition of Our addresses
    let fake_caller: ContractAddress = 1234.try_into().unwrap();
    // let new_caller:  ContractAddress = 2345.try_into().unwrap();

    // Two function calls to register and to get a student and their assertion
    let _initial_student = student_dispatcher.Register_stud(fake_caller, 'Adetumilara', 20);
    let student = student_dispatcher.Get_stud(fake_caller);

    assert_eq!(student.student_addr, fake_caller);
    assert_eq!(student._name, 'Adetumilara');
    assert_eq!(student.age, 20);

    //The definition of our zero address
    let zero_address: ContractAddress = 0x000.try_into().unwrap();

    // The function call to Delete Student and Get student to confirm
    let _student = student_dispatcher.Delete_stud(fake_caller);

    let student = student_dispatcher.Get_stud(fake_caller);

    assert_eq!(student.student_addr, zero_address);
    assert_eq!(student._name, 0);
    assert_eq!(student.age, 0);
}
