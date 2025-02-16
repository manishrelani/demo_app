import 'package:drift/drift.dart';
import 'package:realtime/core/util/extension/iterable_extension.dart';
import 'package:realtime/data/services/drift/drift_db.dart';
import 'package:realtime/domain/model/employee_model.dart';

class EmployeeDriftRepository {
  final AppDatabase _database;

  EmployeeDriftRepository(this._database);

  Future<int> updateEmployee(EmployeeModel employee) {
    return (_database.update(_database.employeeTable)
          ..where(
            (e) => e.id.equals(employee.id),
          ))
        .write(
      employee.toCompanion(),
    );
  }

  Future<int> addEmployee(EmployeeModel employee) {
    return _database.into(_database.employeeTable).insert(employee.toCompanion());
  }

  Future<List<EmployeeModel>> getAllEmployees() async {
    final data = await _database.select(_database.employeeTable).get();
    return (data as List).fromList(EmployeeModel.fromTable);
  }

  Future<void> addListOfEmployee(List<EmployeeModel> employees) async {
    await _database.batch((batch) {
      batch.insertAll(_database.employeeTable, employees.map((e) => e.toCompanion()));
    });
  }

  Future<bool> isEmployeeExist(EmployeeModel employee) async {
    final query = _database.select(_database.employeeTable)
      ..where(
        (emp) =>
            emp.name.equals(employee.name) &
            emp.role.equals(employee.name) &
            emp.startDate.equals(employee.startDate) &
            emp.endDate.equalsNullable(employee.endDate),
      )
      ..limit(1);

    return (await query.get()).isNotEmpty;
  }

  Future<int> removeEmployee(int id) async {
    return (_database.delete(_database.employeeTable)..where((e) => e.id.equals(id))).go();
  }

  Future<List<EmployeeModel>> getCurrentEmployee({int page = 1, int pageSize = 20}) async {
    final query = _database.select(_database.employeeTable)
      ..where((emp) => emp.endDate.isNull() | emp.endDate.isBiggerOrEqualValue(DateTime.now()))
      ..orderBy([(emp) => OrderingTerm.asc(emp.name)])
      ..limit(pageSize, offset: (page - 1) * pageSize);

    return query.map(EmployeeModel.fromTable).get();
  }

  Future<List<EmployeeModel>> getPreviousEmployee({int page = 1, int pageSize = 20}) async {
    final query = _database.select(_database.employeeTable)
      ..where((emp) => emp.endDate.isNotNull() & emp.endDate.isSmallerOrEqualValue(DateTime.now()))
      ..orderBy([(emp) => OrderingTerm.asc(emp.name)])
      ..limit(pageSize, offset: (page - 1) * pageSize);

    return query.map(EmployeeModel.fromTable).get();
  }
}
