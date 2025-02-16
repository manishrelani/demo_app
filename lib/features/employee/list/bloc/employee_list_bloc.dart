import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../../../core/util/extension/object_extension.dart';
import '../../../../core/util/method/snack_bar.dart';
import '../../../../domain/model/employee_model.dart';
import '../../../../domain/repository/employee_drift_repository.dart';
import '../../manage/util/extension.dart';
import '../util/delete_employee_command.dart';

part 'employee_list_event.dart';
part 'employee_list_state.dart';

class EmployeeListBloc extends Bloc<EmployeeListEvent, EmployeeListState> {
  final EmployeeDriftRepository _employeeRepository;

  List<EmployeeModel> get currentEmployees => [...cEmpPagingController.itemList ?? []];

  List<EmployeeModel> get previousEmployees => [...pEmpPagingController.itemList ?? []];

  static const int _pageSize = 10;

  final cEmpPagingController = PagingController<int, EmployeeModel>(
    firstPageKey: 1,
    invisibleItemsThreshold: 5,
  );
  final pEmpPagingController = PagingController<int, EmployeeModel>(
    firstPageKey: 1,
    invisibleItemsThreshold: 5,
  );

  // for delete employee
  DeleteEmployeeCommand? _currentCommand;
  Timer? _undoTimer;

  EmployeeListBloc(this._employeeRepository) : super(const EmployeeListLoading()) {
    on<InitializeEmployeeEvent>(_fetchAllEmployee);
    on<AddUpdateEmployeeEvent>(_onAddUpdateEmployee);
    on<DeleteEmployeeEvent>(_deleteEmployee);
    on<UndoDeletedEmployeeEvent>(_undoDeletedEmployee);
    // _employeeRepository.removeAll();
    _initialize();
  }

  void _initialize() {
    add(InitializeEmployeeEvent());

    cEmpPagingController.addPageRequestListener((pageKey) {
      if (pageKey > 1) {
        _fetchCurrentEmployee(pageKey);
      }
    });

    pEmpPagingController.addPageRequestListener((pageKey) {
      if (pageKey > 1) {
        _fetchPreviousEmployee(pageKey);
      }
    });
  }

  Future<void> _fetchAllEmployee(InitializeEmployeeEvent event, Emitter<EmployeeListState> emit) async {
    await Future.wait([_fetchCurrentEmployee(1), _fetchPreviousEmployee(1)]);
    emit(EmployeeListLoadedState());
  }

  Future<void> _fetchCurrentEmployee(int pageKey) async {
    try {
      final newItems = await _employeeRepository.getCurrentEmployee(page: pageKey, pageSize: _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        cEmpPagingController.appendLastPage(newItems);
      } else {
        cEmpPagingController.appendPage(newItems, ++pageKey);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> _fetchPreviousEmployee(int pageKey) async {
    try {
      final newItems = await _employeeRepository.getPreviousEmployee(page: pageKey, pageSize: _pageSize);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pEmpPagingController.appendLastPage(newItems);
      } else {
        pEmpPagingController.appendPage(newItems, ++pageKey);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> _onAddUpdateEmployee(AddUpdateEmployeeEvent event, Emitter<EmployeeListState> emit) async {
    try {
      event.employee.toJson().showLog;
      if (event.employee.isPreviousEmployee) {
        _addUpdatePreviousEmployee(event.employee, emit);
      } else {
        _addUpdateCurrentEmployee(event.employee, emit);
      }
    } catch (e, s) {
      e.showLog;
      s.showLog;
    }
  }

  void _addUpdatePreviousEmployee(EmployeeModel employee, Emitter<EmployeeListState> emit) {
    final list = pEmpPagingController.itemList;

    final int index = list?.indexWhere((e) => e.id == employee.id) ?? -1;

    if (index == -1) {
      pEmpPagingController.itemList = [...list ?? const [], employee];

      // update ui if it smaller than 3
      if (pEmpPagingController.itemList!.length <= 3) {
        emit(EmployeeListLoadedState());
      }
    } else {
      list![index] = employee;
      pEmpPagingController.itemList = [...list];
    }
  }

  void _addUpdateCurrentEmployee(EmployeeModel employee, Emitter<EmployeeListState> emit) {
    final list = cEmpPagingController.itemList;

    final int index = list?.indexWhere((e) => e.id == employee.id) ?? -1;

    if (index == -1) {
      cEmpPagingController.itemList = [...list ?? [], employee];

      // update ui if it smaller than 3
      if (cEmpPagingController.itemList!.length <= 3) {
        emit(EmployeeListLoadedState());
      }
    } else {
      list![index] = employee;
      cEmpPagingController.itemList = [...list];
    }
  }

  void _deleteEmployee(DeleteEmployeeEvent event, Emitter<EmployeeListState> emit) async {
    try {
      final list = event.isPrevious ? pEmpPagingController.itemList : cEmpPagingController.itemList;
      final employee = list![event.index];

      _currentCommand = DeleteEmployeeCommand(
        employee: employee,
        pagingController: event.isPrevious ? pEmpPagingController : cEmpPagingController,
        employeeRepository: _employeeRepository,
        index: event.index,
      );

      _currentCommand!.delete();
      SnackToast.showWithUndo(
        message: "Employee has been deleted",
        onUndo: () {
          add(UndoDeletedEmployeeEvent());
        },
      );
      _startUndoTimer();

      // this is the list before item got deleted
      if (list.length <= 3) {
        emit(EmployeeListLoadedState());
      }
    } catch (e, s) {
      e.showLog;
      s.showLog;
    }
  }

  void _startUndoTimer() {
    _undoTimer?.cancel();
    _undoTimer = Timer(const Duration(seconds: 5), () {
      _currentCommand = null;
    });
  }

  void _undoDeletedEmployee(UndoDeletedEmployeeEvent event, Emitter<EmployeeListState> emit) {
    try {
      final command = _currentCommand;
      _currentCommand = null;
      _undoTimer?.cancel();

      if (command != null) {
        command.undo();
        if (command.pagingController.itemList!.length <= 3) {
          emit(EmployeeListLoadedState());
        }
      }
    } catch (e, s) {
      e.showLog;
      s.showLog;
    }
  }

  @override
  Future<void> close() {
    _undoTimer?.cancel();
    _undoTimer = null;
    cEmpPagingController.dispose();
    pEmpPagingController.dispose();
    return super.close();
  }
}
