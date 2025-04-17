import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loader {

  static void showLoader() {
    EasyLoading.show(maskType: EasyLoadingMaskType.custom, dismissOnTap: false);
  }

  static void showHideLoader() {
    EasyLoading.show(maskType: EasyLoadingMaskType.custom, dismissOnTap: true);
  }

  static void hideLoader() => EasyLoading.dismiss();
}
