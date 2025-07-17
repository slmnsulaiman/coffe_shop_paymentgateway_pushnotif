import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/kasir_ringkasan_penjual_controller.dart';

class KasirRingkasanPenjualView
    extends GetView<KasirRingkasanPenjualController> {
  const KasirRingkasanPenjualView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Penjualan'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCard(
              'Total Transaksi',
              '${controller.totalTransaksi} Pesanan',
            ),
            _buildCard(
              'Total Pendapatan',
              currencyFormat.format(controller.totalPendapatan.value),
            ),
            _buildCard(
              'Metode Pembayaran',
              'Cash: ${controller.totalCash}, Gateway: ${controller.totalGateway}',
            ),
            _buildCard(
              'Status Proses',
              'Proses: ${controller.totalProses}, Selesai: ${controller.totalSelesai}',
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.bar_chart, color: Colors.brown),
      ),
    );
  }
}
