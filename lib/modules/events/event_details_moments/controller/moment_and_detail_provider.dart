import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/common_imports/common_imports.dart';

final momentAndDetailProvider = ChangeNotifierProvider((ref) => MomentAndDetailProvider());

class MomentAndDetailProvider extends ChangeNotifier {

  int _initialIndex=0;

  int get getInitialIndex =>_initialIndex;

  setInitialIndex({required initialndex}) {
    _initialIndex=initialndex;
    notifyListeners();
  }
}
