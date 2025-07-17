// tiga

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';
import 'package:mobile/thema.dart';
import '../controllers/keranjang_controller.dart';

class KeranjangView extends GetView<KeranjangController> {
  const KeranjangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
        backgroundColor: KCok,
      ),
      body: Obx(() {
        if (controller.keranjang.isEmpty) {
          return const Center(child: Text('Keranjang masih kosong'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.keranjang.length,
                itemBuilder: (context, index) {
                  final item = controller.keranjang[index];

                  final isChecked = controller.selectedItems.contains(item);

                  return Slidable(
                    key: Key(item.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            controller.hapusDariKeranjang(item);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                controller.togglePilihan(item, value ?? false);
                              },
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.fullImageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Rp ${item.harga}'),
                                ],
                              ),
                            ),
                            Obx(() {
                              final jumlah = controller.jumlahMap[item] ?? 1;
                              return Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () =>
                                        controller.kurangJumlah(item),
                                  ),
                                  Text('$jumlah'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        controller.tambahJumlah(item),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KCok,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      'Total: Rp ${controller.totalHarga.value}',
                      style: WhiteTextStyle.copyWith(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.selectedItems.isEmpty
                        ? null
                        : () {
                            Get.toNamed(Routes.CHECKOUT);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Checkout',
                      style: CokTextStyle.copyWith(fontWeight: bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
