import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime/domain/repository/employee_drift_repository.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/util/extension/date_extension.dart';
import '../../../../core/util/extension/object_extension.dart';
import '../../../../core/util/global.dart';
import '../../../../core/util/method/snack_bar.dart';
import '../../../../domain/model/employee_model.dart';
import '../../util/enum.dart';

part 'manage_employee_state.dart';

class ManageEmployeeCubit extends Cubit<ManageEmployeeState> {
  ManageEmployeeCubit({
    required EmployeeDriftRepository employeeRepository,
    this.employee,
  })  : _employeeRepository = employeeRepository,
        super(ManageEmployeeInitial()) {
    if (employee != null) {
      _setup(employee!);
    }
  }

  final EmployeeDriftRepository _employeeRepository;

  final EmployeeModel? employee;

  bool get isUpdate => employee != null;

  final tecEmployeeName = TextEditingController();
  final tecStartDate = TextEditingController();
  final tecEndDate = TextEditingController();
  final tecRole = TextEditingController();

  final DateTime today = DateTime.now();

  bool isToday(DateTime time) => isSameDay(time, today);

  DateTime? _startDateTime;
  DateTime? get startDateTime => _startDateTime;

  DateTime? _endDateTime;
  DateTime? get endDateTime => _endDateTime;

  void _setup(EmployeeModel employee) {
    tecEmployeeName.text = employee.name;
    tecRole.text = employee.role;
    tecStartDate.text = _getDateValue(employee.startDate) ?? '';
    tecEndDate.text = _getDateValue(employee.endDate) ?? '';

    _startDateTime = employee.startDate;
    _endDateTime = employee.endDate;
  }

  void onSelectStartDate(DateTime date) {
    _startDateTime = date;
    tecStartDate.text = _getDateValue(date) ?? '';

    if (_endDateTime?.isBefore(date) ?? false) {
      _endDateTime = null;
      tecEndDate.text = "";
    }
  }

  void onSelectEndDate(DateTime? date) {
    if (_startDateTime != null && (date?.isBeforeOrEqual(_startDateTime!) ?? false)) {
      SnackToast.show(message: "Invalid End Date");
      return;
    }
    _endDateTime = date;
    tecEndDate.text = _getDateValue(date) ?? '';
  }

  String? _getDateValue(DateTime? time) {
    if (time == null) return null;

    if (isToday(time)) {
      return "Today";
    }

    return time.todMMMyyyy();
  }

  void onSelectRole(EmployeeRole role) {
    tecRole.text = role.title;
  }

  Future<void> onSave() async {
    try {
      if (tecEmployeeName.text.trim().isEmpty) {
        SnackToast.show(message: "Please enter employee name");
        return;
      } else if (tecRole.text.isEmpty) {
        SnackToast.show(message: "Please select role");
        return;
      } else if (_startDateTime == null) {
        SnackToast.show(message: "Please select start date");
        return;
      }

      showLoader();
      final data = EmployeeModel(
        id: employee?.id ?? 0,
        name: tecEmployeeName.text.trim(),
        role: tecRole.text,
        startDate: _startDateTime!,
        endDate: _endDateTime,
      );

      if (employee == data) {
        SnackToast.show(message: "No data to update");
        return;
      }

      // if (data.id == 0) {
      final isExist = await _employeeRepository.isEmployeeExist(data);

      if (isExist) {
        SnackToast.show(message: "Employee already exits");
        return;
      }
      // }

      data.showLog;

      if (isUpdate) {
        final id = await _employeeRepository.updateEmployee(data);
        id.showLog;

        SnackToast.show(message: "Employee has been updated");

        emit(EmployeeUpdateState(data));
      } else {
        final id = await _employeeRepository.addEmployee(data);
        id.showLog;

        SnackToast.show(message: "Employee has been added");

        emit(EmployeeUpdateState(data.copyWith(id: id)));
      }
    } catch (e, s) {
      e.showLog;
      s.showLog;
      SnackToast.show(message: "Unable to procced, Please try again");
    } finally {
      hideLoader();
    }
  }

  @override
  Future<void> close() {
    tecEmployeeName.dispose();
    tecStartDate.dispose();
    tecEndDate.dispose();
    tecRole.dispose();
    return super.close();
  }
}
