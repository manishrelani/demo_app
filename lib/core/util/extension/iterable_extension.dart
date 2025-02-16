import 'package:realtime/core/util/extension/object_extension.dart';

extension ListConversion on List {
  List<E> fromList<E, T>(E Function(T) from) {
    final List<E> list = [];

    for (var i in this) {
      try {
        list.add(from(i));
      } catch (e, s) {
        e.showLog;
        s.showLog;
      }
    }
    return list;
  }
}
