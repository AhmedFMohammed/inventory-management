class Delivery {
  int? id;
  int? price;
  String? city;

  Delivery({this.id, this.price, this.city});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'city': city,
    };
  }

  Delivery.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    price = map['price'];
    city = map['city'];
  }
}
