part of 'employee_list_bloc.dart';

sealed class EmployeeListEvent {}

final class InitializeEmployeeEvent extends EmployeeListEvent {}

final class AddUpdateEmployeeEvent extends EmployeeListEvent {
  final EmployeeModel employee;

  AddUpdateEmployeeEvent(this.employee);
}

final class DeleteEmployeeEvent extends EmployeeListEvent {
  final int index;
  final bool isPrevious;

  DeleteEmployeeEvent({required this.index, required this.isPrevious});
}

final class UndoDeletedEmployeeEvent extends EmployeeListEvent {
  UndoDeletedEmployeeEvent();
}
