import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile/app/data/models/produk_model.dart';
import 'package:mobile/app/modules/keranjang/controllers/keranjang_controller.dart';
import 'package:mobile/app/routes/app_pages.dart';
import 'package:mobile/thema.dart';

import '../controllers/detail_produk_controller.dart';

class DetailProdukView extends GetView<DetailProdukController> {
  const DetailProdukView({super.key});
  @override
  Widget build(BuildContext context) {
    final ProdukModel product = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: KCok,
        title: Text(
          'Detail Produk',
          style: whitegrerTextStyle.copyWith(fontSize: 25, fontWeight: bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              product.fullImageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              product.name,
              style: CokTextStyle.copyWith(fontSize: 30, fontWeight: bold),
            ),
          ),

          Divider(),
          Text(
            product.deskripsi,
            style: BlackTextStyle,
            textAlign: TextAlign.center,
          ),

          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Harga',
                style: BlackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
              ),
              Text(
                'Rp. ${product.harga}',
                style: CokTextStyle.copyWith(fontSize: 20),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              final keranjangC = Get.find<KeranjangController>();
              keranjangC.tambahKeKeranjang(product);
              Get.toNamed(Routes.KERANJANG);
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: KCok,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.add_shopping_cart, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      'Masukkan Keranjang',
                      style: whitegrerTextStyle.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
