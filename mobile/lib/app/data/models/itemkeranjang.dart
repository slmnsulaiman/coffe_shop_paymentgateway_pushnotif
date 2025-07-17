import 'package:mobile/app/data/models/produk_model.dart';

class ItemKeranjang {
  final ProdukModel produk;
  int jumlah;

  ItemKeranjang({required this.produk, this.jumlah = 1});

  Map<String, dynamic> toJson() => {
    'produk': produk.toJson(),
    'jumlah': jumlah,
  };

  factory ItemKeranjang.fromJson(Map<String, dynamic> json) {
    return ItemKeranjang(
      produk: ProdukModel.fromJson(json['produk']),
      jumlah: json['jumlah'],
    );
  }
}
