import '../../../domain/model/employee_model.dart';

extension CheckEmployee on EmployeeModel {
  bool get isPreviousEmployee {
    return endDate != null && endDate!.isBefore(DateTime.now());
  }
}
