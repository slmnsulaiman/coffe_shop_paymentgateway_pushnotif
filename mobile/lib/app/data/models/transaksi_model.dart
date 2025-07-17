class ItemModel {
  final String name;
  final int harga;
  final int jumlah;
  final String productId;

  ItemModel({
    required this.name,
    required this.harga,
    required this.jumlah,
    required this.productId,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      name: json['name'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      productId: json['productId'],
    );
  }
}

class TransaksiModel {
  final String id;
  final String userName;
  final String metode;
  final String status;
  final String proses;
  final int total;
  final DateTime createdAt;
  final List<ItemModel> items;

  TransaksiModel({
    required this.id,
    required this.userName,
    required this.metode,
    required this.status,
    required this.proses,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    List<ItemModel> parsedItems = (json['items'] as List)
        .map((e) => ItemModel.fromJson(e))
        .toList();

    return TransaksiModel(
      id: json['_id'],
      userName: json['userName'],
      metode: json['metode'],
      status: json['status'],
      proses: json['proses'],
      total: json['total'],
      createdAt: DateTime.parse(json['createdAt']),
      items: parsedItems,
    );
  }
}
