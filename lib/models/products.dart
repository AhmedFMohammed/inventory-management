import 'dart:convert';

import 'package:flutter/services.dart';

class Product {
  int? id, quantity, price;
  String? title, description, imageEncoded;
  Uint8List? profilePicture;

  Product(
      {this.id,
      this.title,
      this.description,
      this.quantity,
      this.price,
      this.imageEncoded,
      this.profilePicture});

  Map<String, dynamic> toMap() {
    List<int> bytes = base64.decode(imageEncoded!);

    return {
      'id': id,
      'title': title,
      'description': description,
      'quantity': quantity,
      'price': price,
      'imageEncoded': imageEncoded,
      'profilePicture': Uint8List.fromList(bytes),
    };
  }

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    quantity = map['quantity'];
    price = map['price'];
    imageEncoded = map['imageEncoded'];
    profilePicture = map['profilePicture'];
  }
}
