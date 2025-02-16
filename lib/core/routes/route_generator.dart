import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime/data/services/drift/drift_db.dart';
import 'package:realtime/data/services/getit_service.dart';
import 'package:realtime/domain/model/employee_model.dart';
import 'package:realtime/domain/repository/employee_drift_repository.dart';
import 'package:realtime/features/employee/manage/cubit/manage_employee_cubit.dart';

import '../../features/employee/list/bloc/employee_list_bloc.dart';
import '../../features/employee/list/screen/employee_list_screen.dart';
import '../../features/employee/manage/screen/manage_employee_screen.dart';
import '../../features/landing/cubit/landing_cubit.dart';
import '../../features/landing/screen/landing_screen.dart';
import 'screen_name.dart';

final class RouteGenerator {
  RouteGenerator._();

  static Route? generate(RouteSettings settings) {
    switch (settings.name) {
      case ScreenName.employeeList:
        return CupertinoPageRoute(
          builder: (ctx) => BlocProvider(
            create: (context) => EmployeeListBloc(
              EmployeeDriftRepository(
                // ObjectBoxService.instance.box<EmployeeEntity>(),
                getIt<AppDatabase>(),
              ),
            ),
            child: const EmployeeListScreen(),
          ),
        );

      case ScreenName.landing:
        return CupertinoPageRoute(
          builder: (ctx) => BlocProvider(
            create: (context) => LandingCubit(),
            child: const LandingScreen(),
          ),
        );
      case ScreenName.manageEmployee:
        return CupertinoPageRoute(
          builder: (ctx) => BlocProvider(
            create: (context) {
              return ManageEmployeeCubit(
                employeeRepository: EmployeeDriftRepository(getIt<AppDatabase>()),
                employee: settings.arguments is EmployeeModel ? settings.arguments as EmployeeModel : null,
              );
            },
            child: const ManageEmployeeScreen(),
          ),
        );

      default:
        return CupertinoPageRoute(
          builder: (ctx) => const SizedBox(),
        );
    }
  }
}
