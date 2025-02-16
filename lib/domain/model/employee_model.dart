import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../../data/services/drift/drift_db.dart';

class EmployeeModel extends Equatable {
  final int id;
  final String name;
  final String role;
  final DateTime startDate;
  final DateTime? endDate;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    required this.endDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
    );
  }

  // factory EmployeeModel.fromEntity(EmployeeEntity entity) {
  //   return EmployeeModel(
  //     id: entity.id,
  //     name: entity.name,
  //     role: entity.role,
  //     startDate: entity.startDate,
  //     endDate: entity.endDate,
  //   );
  // }
  factory EmployeeModel.fromTable(EmployeeTableData table) {
    return EmployeeModel(
      id: table.id,
      name: table.name,
      role: table.role,
      startDate: table.startDate,
      endDate: table.endDate,
    );
  }

  EmployeeTableCompanion toCompanion() {
    return EmployeeTableCompanion(
      id: id == 0 ? const Value.absent() : Value(id),
      name: Value(name),
      role: Value(role),
      startDate: Value(startDate),
      endDate: Value(endDate),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        startDate,
        endDate,
      ];

  EmployeeModel copyWith({
    int? id,
    String? name,
    String? role,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
