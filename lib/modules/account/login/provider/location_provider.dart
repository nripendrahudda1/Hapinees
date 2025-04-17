
import 'package:Happinest/common/common_imports/common_imports.dart';

class LocationListener extends ChangeNotifier {
  Future<bool> checkLocationEnable() async {
    if (await Utility.requestLocationPermission()) {
      return true;
    } else {
      notifyListeners();
      return true;
    }
  }
}
