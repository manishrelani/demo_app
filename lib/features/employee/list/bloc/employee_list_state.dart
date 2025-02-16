part of 'employee_list_bloc.dart';

@immutable
sealed class EmployeeListState {
  const EmployeeListState();
}

final class EmployeeListLoading extends EmployeeListState {
  const EmployeeListLoading();
}

final class EmployeeListLoadedState extends EmployeeListState {}
