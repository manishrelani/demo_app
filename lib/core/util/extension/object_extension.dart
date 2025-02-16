import 'dart:developer' as dev;

extension DevLog on Object? {
  void get showLog {
    dev.log(toString());
  }
}
