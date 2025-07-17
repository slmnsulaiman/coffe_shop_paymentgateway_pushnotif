import 'package:get/get.dart';

import '../controllers/snap_controller.dart';

class SnapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnapController>(
      () => SnapController(),
    );
  }
}
