part of 'manage_employee_cubit.dart';

sealed class ManageEmployeeState {
  const ManageEmployeeState();
}

final class ManageEmployeeInitial extends ManageEmployeeState {}

final class EmployeeUpdateState extends ManageEmployeeState {
  final EmployeeModel employee;

  EmployeeUpdateState(this.employee);
}
