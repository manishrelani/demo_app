// import 'package:objectbox/objectbox.dart';

// import '../../domain/model/employee_model.dart';

// @Entity()
// class EmployeeEntity {
//   @Id()
//   int id;
//   final String name;
//   final String role;
//   @Property(type: PropertyType.date)
//   final DateTime startDate;
//   @Property(type: PropertyType.date)
//   final DateTime? endDate;

//   EmployeeEntity({
//     this.id = 0,
//     required this.name,
//     required this.role,
//     required this.startDate,
//     required this.endDate,
//   });

//   factory EmployeeEntity.fromModel(EmployeeModel employee) {
//     return EmployeeEntity(
//       id: employee.id,
//       name: employee.name,
//       role: employee.role,
//       startDate: employee.startDate,
//       endDate: employee.endDate,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'role': role,
//       'startDate': startDate.millisecondsSinceEpoch,
//       'endDate': endDate?.millisecondsSinceEpoch,
//     };
//   }
// }
