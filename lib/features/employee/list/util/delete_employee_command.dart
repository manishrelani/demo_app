import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:realtime/domain/repository/employee_drift_repository.dart';

import '../../../../domain/model/employee_model.dart';

class DeleteEmployeeCommand {
  final EmployeeModel employee;
  final int index;
  final PagingController<int, EmployeeModel> pagingController;
  final EmployeeDriftRepository employeeRepository;

  const DeleteEmployeeCommand({
    required this.index,
    required this.employee,
    required this.pagingController,
    required this.employeeRepository,
  });

  void delete() {
    final list = [...pagingController.itemList!];
    list.remove(employee);
    pagingController.itemList = list;
    employeeRepository.removeEmployee(employee.id);
  }

  void undo() {
    final list = [...pagingController.itemList!];
    list.insert(index, employee);
    pagingController.itemList = list;
    employeeRepository.addEmployee(employee);
  }
}
