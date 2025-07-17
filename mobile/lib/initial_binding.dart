import 'package:get/get.dart';
import 'package:mobile/app/modules/keranjang/controllers/keranjang_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(KeranjangController()); // dibuat sekali & selalu tersedia
  }
}
