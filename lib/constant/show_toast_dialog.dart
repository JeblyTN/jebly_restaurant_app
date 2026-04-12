import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowToastDialog {
  static void showToast(String? message, {EasyLoadingToastPosition position = EasyLoadingToastPosition.top}) {
    EasyLoading.showToast(message!, toastPosition: position);
  }

  static void showToastDuration(String? message, {EasyLoadingToastPosition position = EasyLoadingToastPosition.top, required Duration duration}) {
    EasyLoading.showToast(message!, toastPosition: position, duration: duration);
  }

  static void showLoader(String message) {
    EasyLoading.show(status: message, maskType: EasyLoadingMaskType.black, dismissOnTap: false);
  }

  static void closeLoader() {
    EasyLoading.dismiss();
  }
}
