import 'package:get/get.dart';

import '../controllers/kasir_home_controller.dart';

class KasirHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KasirHomeController>(
      () => KasirHomeController(),
    );
  }
}
