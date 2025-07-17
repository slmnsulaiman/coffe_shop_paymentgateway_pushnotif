import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:mobile/constant/base_url.dart';

class HistoryController extends GetxController {
  var historyList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchHistoryByEmail();
  }

  void fetchHistoryByEmail() async {
    isLoading.value = true;

    final email = box.read('email');
    try {
      final res = await http.get(
        Uri.parse('$bASEURL/api/checkout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);

        final filtered = data
            .where((item) => item['userEmail'] == email)
            .toList();

        historyList.value = filtered.map((item) {
          final produkList = item['items']
              .map((p) => p['name'] ?? '')
              .toList()
              .join(', ');

          return {
            'produk': produkList,
            'tanggal': item['createdAt'].substring(0, 10),
            'total': item['total'].toString(),
            'metode': item['metode'],
            'proses': item['proses'],
            'status': item['status'],
            'type': item['type'] ?? '-',
          };
        }).toList();
      }
    } catch (e) {
      print('❌ Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
