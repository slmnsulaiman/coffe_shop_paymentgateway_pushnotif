import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/constant/base_url.dart';

class KasirRingkasanPenjualController extends GetxController {
  var isLoading = false.obs;
  var totalTransaksi = 0.obs;
  var totalPendapatan = 0.obs;
  var totalCash = 0.obs;
  var totalGateway = 0.obs;
  var totalProses = 0.obs;
  var totalSelesai = 0.obs;

  void fetchRingkasan() async {
    isLoading.value = true;
    try {
      final res = await http.get(Uri.parse('$bASEURL/api/checkout'));
      final data = jsonDecode(res.body) as List;

      final today = DateTime.now();

      final todayData = data.where((item) {
        final tgl = DateTime.parse(item['createdAt']);
        return tgl.year == today.year &&
            tgl.month == today.month &&
            tgl.day == today.day;
      }).toList();

      totalTransaksi.value = todayData.length;
      totalPendapatan.value = todayData.fold(0, (sum, item) {
        final total = int.tryParse(item['total'].toString()) ?? 0;
        return sum + total;
      });

      totalCash.value = todayData.where((i) => i['metode'] == 'Cash').length;
      totalGateway.value = todayData.where((i) => i['metode'] != 'Cash').length;

      totalProses.value = todayData
          .where((i) => i['proses'] == 'proses')
          .length;
      totalSelesai.value = todayData
          .where((i) => i['proses'] == 'selesai')
          .length;
    } catch (e) {
      print('Gagal ambil ringkasan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchRingkasan();
  }
}
