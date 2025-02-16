import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

// AppDatabase constructDb() {
//   return AppDatabase(connectOnWeb());
// }

DatabaseConnection connectDb() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'emp_db', // prefer to only use valid identifiers here
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // Depending how central local persistence is to your app, you may want
      // to show a warning to the user if only unrealiable implemetentations
      // are available.
      // print('Using ${result.chosenImplementation} due to missing browser '
      //     'features: ${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  }));
}
