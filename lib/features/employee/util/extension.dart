import '../../../domain/model/employee_model.dart';

extension CheckEmployee on EmployeeModel {
  bool get isPreviousEmployee {
    return endDate != null && endDate!.isBefore(DateTime.now());
  }

  // bool isSame(EmployeeModel other) {
  //   return name == other.name && role == other.role && startDate == other.startDate && endDate == other.endDate;
  // }
}
