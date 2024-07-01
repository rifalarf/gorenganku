class Stok {
  String id;
  String name;
  int qty;
  String attr;
  double weight;

  Stok({
    required this.id,
    required this.name,
    required this.qty,
    required this.attr,
    required this.weight,
  });

  factory Stok.fromJson(Map<String, dynamic> json) {
    return Stok(
      id: json['id'],
      name: json['name'],
      qty: (json['qty'] as num).toInt(), // Konversi ke int
      attr: json['attr'],
      weight: (json['weight'] as num).toDouble(), // Konversi ke double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'attr': attr,
      'weight': weight,
    };
  }
}
