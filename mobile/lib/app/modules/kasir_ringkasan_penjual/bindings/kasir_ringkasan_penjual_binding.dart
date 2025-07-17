import 'package:get/get.dart';

import '../controllers/kasir_ringkasan_penjual_controller.dart';

class KasirRingkasanPenjualBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KasirRingkasanPenjualController>(
      () => KasirRingkasanPenjualController(),
    );
  }
}
