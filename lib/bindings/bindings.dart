

import 'package:communtiy/controllers/google_sign_in_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => Get.put(GoogleSignInController()));
  }

}