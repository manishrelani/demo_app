import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime/core/util/extension/object_extension.dart';

import '../../../core/routes/screen_name.dart';
import '../../../data/services/getit_service.dart';

part 'landing_state.dart';

class LandingCubit extends Cubit<LandingState> {
  LandingCubit() : super(LandingLoading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // await ObjectBoxService.init();
      await initServiceLocator();
      emit(const LandingNavigate(ScreenName.employeeList));
    } catch (e, s) {
      e.showLog;
      s.showLog;
      emit(LandingError());
    }
  }

  void onRefresh() {
    emit(LandingLoading());
    _initialize();
  }
}
