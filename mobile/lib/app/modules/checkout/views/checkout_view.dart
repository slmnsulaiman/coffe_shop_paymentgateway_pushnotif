import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

import '../controllers/checkout_controller.dart';
import '../../keranjang/controllers/keranjang_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final keranjangC = Get.find<KeranjangController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama: ${controller.box.read('name') ?? '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Email: ${controller.box.read('email') ?? '-'}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Produk yang dibeli:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: keranjangC.selectedItems.length,
              itemBuilder: (context, index) {
                final item = keranjangC.selectedItems[index];
                final jumlah = keranjangC.jumlahMap[item] ?? 1;
                return ListTile(
                  leading: Image.network(
                    item.fullImageUrl,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(item.name),
                  subtitle: Text('Rp ${item.harga} x $jumlah'),
                  trailing: Text('Rp ${item.harga * jumlah}'),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Text(
                    'Rp ${keranjangC.totalHarga.value}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                Get.bottomSheet(
                  const PilihPembayaranView(),
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                );
              },
              child: const Text('Pilih Metode Pembayaran'),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final metode = controller.selectedMetode.value;
            if (metode.isEmpty) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  if (metode == 'Cash') {
                    final result = await controller.checkoutCash();
                    if (result) {
                      keranjangC.clearCart();
                      Get.snackbar(
                        'Berhasil',
                        'Pesanan Cash berhasil diproses',
                        backgroundColor: Colors.green.shade100,
                        colorText: Colors.black,
                      );
                      await Future.delayed(const Duration(seconds: 1));
                      Get.offAllNamed(
                        Routes.HOME,
                      ); // ganti sesuai nama route home kamu
                    } else {
                      Get.snackbar(
                        'Gagal',
                        'Checkout Cash gagal',
                        backgroundColor: Colors.red.shade100,
                        colorText: Colors.black,
                      );
                    }
                  } else {
                    final url = await controller.checkoutMidtrans(metode);
                    if (url != null) {
                      Get.toNamed(Routes.SNAP, arguments: {'url': url});
                    } else {
                      Get.snackbar(
                        'Gagal',
                        'Gagal mendapatkan token pembayaran',
                      );
                    }
                  }
                },
                child: Text('Bayar Sekarang ($metode)'),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class PilihPembayaranView extends StatelessWidget {
  const PilihPembayaranView({super.key});

  @override
  Widget build(BuildContext context) {
    final metode = ['Payment Gateway', 'Cash'];
    final checkoutC = Get.find<CheckoutController>();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: metode.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(metode[index]),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            checkoutC.selectedMetode.value = metode[index]; // Simpan pilihan
            Get.back(); // Tutup bottom sheet
          },
        );
      },
    );
  }
}
