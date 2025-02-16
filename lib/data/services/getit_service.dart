import 'package:get_it/get_it.dart';
import 'package:realtime/data/services/drift/drift_db.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  getIt.registerLazySingleton(() => AppDatabase());
}
