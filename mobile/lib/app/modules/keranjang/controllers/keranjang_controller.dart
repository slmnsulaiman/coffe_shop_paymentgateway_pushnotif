// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../../data/models/produk_model.dart';

// class KeranjangController extends GetxController {
//   final keranjang = <ProdukModel>[].obs;
//   final selectedItems = <ProdukModel>[].obs;
//   final box = GetStorage();

//   String get _userKey => 'cart_${box.read('email') ?? 'guest'}';

//   // ❌ Jangan panggil loadKeranjang di sini
//   @override
//   void onInit() {
//     super.onInit();
//     // loadKeranjang(); ← hapus ini
//   }

//   void tambahKeKeranjang(ProdukModel produk) {
//     keranjang.add(produk);
//     simpanKeranjang();
//   }

//   void hapusDariKeranjang(ProdukModel produk) {
//     keranjang.remove(produk);
//     selectedItems.remove(produk);
//     simpanKeranjang();
//   }

//   void togglePilihan(ProdukModel produk, bool selected) {
//     if (selected) {
//       selectedItems.add(produk);
//     } else {
//       selectedItems.remove(produk);
//     }
//   }

//   int get totalHarga => selectedItems.fold(0, (sum, item) => sum + item.harga);

//   void simpanKeranjang() {
//     final data = keranjang.map((e) => e.toJson()).toList();
//     box.write(_userKey, data);
//     print('Simpan ke $_userKey: $data');
//   }

//   void loadKeranjang() {
//     final data = box.read(_userKey);
//     print('Load dari $_userKey: $data');
//     if (data != null) {
//       keranjang.assignAll(
//         List<ProdukModel>.from(
//           (data as List).map((e) => ProdukModel.fromJson(e)),
//         ),
//       );
//     }
//   }

//   void kosongkanMemori() {
//     keranjang.clear();
//     selectedItems.clear();
//   }
// }

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/produk_model.dart';

class KeranjangController extends GetxController {
  final keranjang = <ProdukModel>[].obs;
  final jumlahMap = <ProdukModel, int>{}.obs;
  final selectedItems = <ProdukModel>[].obs;
  final box = GetStorage();

  var totalHarga = 0.obs;

  String get _userKey => 'cart_${box.read('email') ?? 'guest'}';

  @override
  void onInit() {
    super.onInit();
    selectedItems.listen((_) => hitungTotal());
    hitungTotal();
    // loadKeranjang(); ❌ Jangan auto-load
  }

  void tambahKeKeranjang(ProdukModel produk) {
    keranjang.add(produk);
    jumlahMap[produk] = 1;
    simpanKeranjang();
  }

  void hapusDariKeranjang(ProdukModel produk) {
    keranjang.remove(produk);
    selectedItems.remove(produk);
    jumlahMap.remove(produk);
    simpanKeranjang();
  }

  void tambahJumlah(ProdukModel produk) {
    if (jumlahMap.containsKey(produk)) {
      jumlahMap[produk] = jumlahMap[produk]! + 1;
      simpanKeranjang();
      hitungTotal();
    }
  }

  void kurangJumlah(ProdukModel produk) {
    if (jumlahMap.containsKey(produk) && jumlahMap[produk]! > 1) {
      jumlahMap[produk] = jumlahMap[produk]! - 1;
      simpanKeranjang();
      hitungTotal();
    }
  }

  void togglePilihan(ProdukModel produk, bool selected) {
    if (selected) {
      selectedItems.add(produk);
    } else {
      selectedItems.remove(produk);
    }
  }

  // int get totalHarga {
  //   int total = 0;
  //   for (var item in selectedItems) {
  //     final jumlah = jumlahMap[item] ?? 1;
  //     total += item.harga * jumlah;
  //   }
  //   return total;
  // }
  void hitungTotal() {
    int total = 0;
    for (var item in selectedItems) {
      final jumlah = jumlahMap[item] ?? 1;
      total += item.harga * jumlah;
    }
    totalHarga.value = total;
  }

  void simpanKeranjang() {
    final data = keranjang.map((e) => e.toJson()).toList();
    final jumlahData = {
      for (var entry in jumlahMap.entries) entry.key.id: entry.value,
    };

    box.write(_userKey, data);
    box.write('${_userKey}_jumlah', jumlahData);
  }

  void loadKeranjang() {
    final data = box.read(_userKey);
    final jumlahData = box.read('${_userKey}_jumlah');

    if (data != null && jumlahData != null) {
      keranjang.assignAll(
        List<ProdukModel>.from(
          (data as List).map((e) => ProdukModel.fromJson(e)),
        ),
      );

      jumlahMap.clear();
      for (var item in keranjang) {
        final jumlah = jumlahData[item.id];
        if (jumlah != null) jumlahMap[item] = jumlah;
      }
    }
  }

  void clearCart() {
    selectedItems.clear();
    jumlahMap.clear();
    totalHarga.value = 0;
    update();
  }

  void kosongkanMemori() {
    keranjang.clear();
    selectedItems.clear();
    jumlahMap.clear();
  }
}
