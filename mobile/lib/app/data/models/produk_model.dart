import 'package:mobile/constant/base_url.dart';

class ProdukModel {
  final String id;
  final String name;
  final int harga;
  final String deskripsi;
  final String foto;

  ProdukModel({
    required this.id,
    required this.name,
    required this.harga,
    required this.deskripsi,
    required this.foto,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['_id'],
      name: json['name'],
      harga: json['harga'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
    );
  }
  // ✅ Getter untuk URL lengkap foto
  String get fullImageUrl => '$bASEURL$foto';

  // ✅ Fungsi toJson untuk menyimpan ke GetStorage
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'harga': harga,
      'deskripsi': deskripsi,
      'foto': foto,
    };
  }
}
