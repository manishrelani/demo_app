import 'package:drift/drift.dart';

import '../../model/drift/employee_drift_model.dart';
import 'shared/connection.dart';

part 'drift_db.g.dart';

@DriftDatabase(tables: [EmployeeTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connectDb());

  @override
  int get schemaVersion => 1;

  // static LazyDatabase _openConnection() {
  //   return LazyDatabase(() async {
  //     final dbFolder = await getApplicationDocumentsDirectory();
  //     final file = File(p.join(dbFolder.path, 'emp_db.sqlite'));
  //     return NativeDatabase.createInBackground(file);
  //   });
  // }
}
