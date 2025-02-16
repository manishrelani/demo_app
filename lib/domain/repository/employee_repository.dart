// import 'dart:async';

// import '../../data/model/employee_entity.dart';
// import '../../objectbox.g.dart';
// import '../model/employee_model.dart';

// class EmployeeRepository {
//   final Box<EmployeeEntity> _box;

//   EmployeeRepository(this._box);

//   Future<void> addListEmployee(List<EmployeeModel> employees) async {
//     await _box.putManyAsync(employees.map((e) => EmployeeEntity.fromModel(e)).toList());
//   }

//   Future<int> putEmployee(EmployeeModel employee) async {
//     return _box.putAsync(EmployeeEntity.fromModel(employee));
//   }

//   Future<bool> isEmployeeExist(EmployeeModel employee) async {
//     final query = _box
//         .query(
//           EmployeeEntity_.name
//               .equals(employee.name)
//               .and(EmployeeEntity_.role.equals(employee.role))
//               .and(EmployeeEntity_.startDate.equalsDate(employee.startDate)),
//         )
//         .build();

//     final result = await query.findAsync();
//     query.close();

//     return result.any((e) => e.endDate == employee.endDate);
//   }

//   bool removeEmployee(int employeeId) {
//     return _box.remove(employeeId);
//   }

//   Future<void> removeAll() async {
//     _box.removeAllAsync();
//   }

//   Future<List<EmployeeModel>> getAllEmployees() async {
//     final query = _box.query().order(EmployeeEntity_.name).build();
//     final result = await query.findAsync();
//     final list = result.map((e) => EmployeeModel.fromEntity(e)).toList();
//     query.close();

//     return list;
//   }

//   Future<List<EmployeeModel>> getCurrentEmployee({int page = 1, int pageSize = 20}) async {
//     final query = _box
//         .query(
//           EmployeeEntity_.endDate.isNull().or(
//                 EmployeeEntity_.endDate.greaterOrEqualDate(DateTime.now()),
//               ),
//         )
//         .order(EmployeeEntity_.name)
//         .build()
//       ..offset = (page - 1) * pageSize
//       ..limit = pageSize;
//     final result = await query.findAsync();
//     query.close();
//     return result.map((e) => EmployeeModel.fromEntity(e)).toList();
//   }

//   Future<List<EmployeeModel>> getPreviousEmployee({int page = 1, int pageSize = 20}) async {
//     final query = _box
//         .query(
//           EmployeeEntity_.endDate.notNull().and(
//                 EmployeeEntity_.endDate.lessOrEqualDate(DateTime.now()),
//               ),
//         )
//         .order(EmployeeEntity_.name)
//         .build()
//       ..offset = (page - 1) * pageSize
//       ..limit = pageSize;
//     final result = await query.findAsync();
//     query.close();
//     return result.map((e) => EmployeeModel.fromEntity(e)).toList();
//   }
// }
