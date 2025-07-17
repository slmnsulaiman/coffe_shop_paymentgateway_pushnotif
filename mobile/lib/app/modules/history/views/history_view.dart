import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';
import 'package:mobile/thema.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KWhiteGreyColor,
      appBar: AppBar(
        backgroundColor: KCoklatColor,
        title: const Text('Riwayat Transaksi'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.historyList.isEmpty) {
          return const Center(
            child: Text('Belum ada transaksi.', style: TextStyle(fontSize: 16)),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: controller.historyList.length,
          itemBuilder: (context, index) {
            final item = controller.historyList[index];

            // Ikon & warna
            final metodeIcon = item['metode'] == 'Cash'
                ? Icons.money
                : Icons.credit_card;
            final metodeColor = item['metode'] == 'Cash'
                ? Colors.green
                : Colors.blue;

            final typeIcon = item['type'] == 'bayar-kasir'
                ? Icons.store
                : Icons.payment;
            final typeColor = item['type'] == 'bayar-kasir'
                ? Colors.brown
                : Colors.orange;

            final statusIcon = item['status'] == 'success'
                ? Icons.check_circle
                : Icons.hourglass_bottom;
            final statusColor = item['status'] == 'success'
                ? Colors.green
                : Colors.grey;

            final prosesIcon = item['proses'] == 'selesai'
                ? Icons.done_all
                : Icons.timelapse;
            final prosesColor = item['proses'] == 'selesai'
                ? Colors.green
                : Colors.orange;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.receipt_long, color: KCoklatColor),
                    title: Text(
                      item['produk'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Tanggal: ${item['tanggal']}'),
                    trailing: Text(
                      'Rp${item['total']}',
                      style: TextStyle(
                        color: KCoklatColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(metodeIcon, color: metodeColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Metode: ${item['metode']}',
                        style: TextStyle(color: metodeColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(typeIcon, color: typeColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Tipe: ${item['type']}',
                        style: TextStyle(color: typeColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Status: ${item['status']}',
                        style: TextStyle(color: statusColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(prosesIcon, color: prosesColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Proses: ${item['proses']}',
                        style: TextStyle(color: prosesColor),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),

      // BottomNavbar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            backgroundColor: KCoklatColor.withOpacity(0.95),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            currentIndex: 1,
            onTap: (index) {
              switch (index) {
                case 0:
                  Get.offAllNamed(Routes.HOME);
                  break;
                case 1:
                  break;
                case 2:
                  Get.offAllNamed(Routes.PROFILE);
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: 'Riwayat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
