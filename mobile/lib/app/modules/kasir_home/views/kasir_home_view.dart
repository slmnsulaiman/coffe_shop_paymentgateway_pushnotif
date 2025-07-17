import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobile/app/routes/app_pages.dart';
import 'package:mobile/constant/base_url.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/kasir_home_controller.dart';

class KasirHomeView extends GetView<KasirHomeController> {
  const KasirHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Hari Ini'),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.KASIR_RINGKASAN_PENJUAL);
              },
              icon: const Icon(Icons.analytics),
            ),
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Logout',
                  middleText: 'Yakin ingin logout?',
                  textCancel: 'Batal',
                  textConfirm: 'Logout',
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    final box = GetStorage();
                    final token = box.read('token');

                    try {
                      final res = await http.post(
                        Uri.parse('$bASEURL/api/auth/logout'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $token',
                        },
                      );

                      if (res.statusCode == 200) {
                        print('✅ Logout kasir dan hapus FCM token berhasil');
                      } else {
                        print('⚠️ Gagal hapus FCM token kasir');
                      }
                    } catch (e) {
                      print('❌ Error logout backend: $e');
                    }

                    box.remove('token');
                    box.remove('name');
                    box.remove('email');
                    box.remove('role');

                    Get.offAllNamed(Routes.LOGIN);
                  },
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],

          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Proses'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final prosesList = controller.transaksiList
              .where((trx) => trx.proses.toLowerCase() == 'proses')
              .toList();
          final selesaiList = controller.transaksiList
              .where((trx) => trx.proses.toLowerCase() == 'selesai')
              .toList();

          return TabBarView(
            children: [
              _buildList(prosesList, controller, currencyFormat),
              _buildList(
                selesaiList,
                controller,
                currencyFormat,
                showButton: false,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildList(
    List trxList,
    KasirHomeController controller,
    NumberFormat currencyFormat, {
    bool showButton = true,
  }) {
    if (trxList.isEmpty) {
      return const Center(child: Text('Tidak ada pesanan.'));
    }

    return ListView.builder(
      itemCount: trxList.length,
      itemBuilder: (context, index) {
        final trx = trxList[index];

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            title: Text(
              trx.userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: ${currencyFormat.format(trx.total)}'),
                Text('${trx.metode}'),
                Row(
                  children: [
                    _buildBadge(trx.status),
                    const SizedBox(width: 6),
                    _buildBadge(trx.proses, isProses: true),
                    const Spacer(),
                  ],
                ),
                Text(
                  'Pesanan ${timeago.format(trx.createdAt, locale: 'id')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            children: [
              ...trx.items.map(
                (item) => ListTile(
                  leading: const Icon(Icons.coffee),
                  title: Text(item.name),
                  subtitle: Text(
                    'Jumlah: ${item.jumlah} x ${currencyFormat.format(item.harga)}',
                  ),
                ),
              ),
              if (showButton && trx.proses.toLowerCase() == 'proses')
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Tandai Selesai'),
                    onPressed: () => controller.updateProses(trx.id),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(String text, {bool isProses = false}) {
    Color color;
    switch (text.toLowerCase()) {
      case 'success':
      case 'selesai':
        color = Colors.green;
        break;
      case 'pending':
      case 'proses':
        color = isProses ? Colors.orange : Colors.amber;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.capitalize ?? text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
