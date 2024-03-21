import 'dart:convert';

import 'package:flutter/services.dart';

class Order {
  int? id;
  String? name, description, city, datetime, location;

  Order(
      {this.id,
      this.name,
      this.description,
      this.city,
      this.datetime,
      this.location});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'city': city,
      'datetime': datetime,
      'location': location,
    };
  }

  Order.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    city = map['city'];
    datetime = map['datetime'];
    location = map['location'];
  }
}

class OrderItem {
  int? id, quantity, pID, oID;
  String? description;

  OrderItem({this.id, this.quantity, this.pID, this.oID, this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'pID': pID,
      'oID': oID,
      'description': description,
    };
  }

  OrderItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    quantity = map['quantity'];
    pID = map['pID'];
    oID = map['oID'];
    description = map['description'];
  }
}
