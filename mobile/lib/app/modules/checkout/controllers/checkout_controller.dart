import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/constant/base_url.dart';

import '../../keranjang/controllers/keranjang_controller.dart';

class CheckoutController extends GetxController {
  final keranjangC = Get.find<KeranjangController>();
  final box = GetStorage();

  final name = ''.obs;
  final email = ''.obs;
  final selectedMetode = ''.obs;

  String baseUrl = '$bASEURL/api';

  @override
  void onInit() {
    super.onInit();
    name.value = box.read('name') ?? '-';
    email.value = box.read('email') ?? '-';
  }

  Future<bool> checkoutCash() async {
    final items = keranjangC.selectedItems.map((item) {
      return {
        'productId': item.id,
        'name': item.name,
        'harga': item.harga,
        'jumlah': keranjangC.jumlahMap[item] ?? 1,
      };
    }).toList();

    final total = keranjangC.totalHarga.value;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userName": name.value,
          "userEmail": email.value,
          "items": items,
          "total": total,
          "metode": "Cash",
        }),
      );

      print("CASH RESPONSE STATUS: ${response.statusCode}");
      print("CASH RESPONSE BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("CASH ERROR: $e");
      return false;
    }
  }

  Future<String?> checkoutMidtrans(String metodeBank) async {
    final items = keranjangC.selectedItems.map((item) {
      return {
        'productId': item.id,
        'name': item.name,
        'harga': item.harga,
        'jumlah': keranjangC.jumlahMap[item] ?? 1,
      };
    }).toList();

    final total = keranjangC.totalHarga.value;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/midtrans'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userName": name.value,
          "userEmail": email.value,
          "items": items,
          "total": total,
          "metode": metodeBank,
        }),
      );

      print("MIDTRANS STATUS: ${response.statusCode}");
      print("MIDTRANS BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['redirect_url']; // GANTI dari token ke redirect_url
      } else {
        return null;
      }
    } catch (e) {
      print("MIDTRANS ERROR: $e");
      return null;
    }
  }
}
