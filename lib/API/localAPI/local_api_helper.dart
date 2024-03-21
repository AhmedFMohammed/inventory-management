import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tahaelectronic/models/delivery.dart';
import 'package:tahaelectronic/models/order.dart';
import 'package:tahaelectronic/models/products.dart';

Future<Database> createDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'my_database.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE products(id INTEGER PRIMARY KEY, title TEXT, description TEXT, quantity INTEGER, price INTEGER, imageEncoded TEXT, profilePicture BLOB)',
      );
      db.execute(
        'CREATE TABLE orders(id INTEGER PRIMARY KEY, name TEXT, description TEXT, city TEXT, datetime TEXT, location TEXT)',
      );
      db.execute(
        'CREATE TABLE orderItems(id INTEGER PRIMARY KEY, quantity INTEGER, pID INTEGER, oID INTEGER, description TEXT)',
      );
      db.execute(
        'CREATE TABLE deliveries(id INTEGER PRIMARY KEY, price INTEGER, city TEXT)',
      );
    },
    version: 1,
  );
  return database;
}

Future<void> insertProduct(Product product) async {
  final db = await createDatabase();
  await db.insert(
    'products',
    product.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  print("productADD");
}

Future<String> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  } else {
    // User canceled image picking
    print('Image picking canceled.');
    return "noimage";
  }
}

Future<List<Product>> products() async {
  final db = await createDatabase();
  final List<Map<String, dynamic>> maps = await db.query('products');
  return List.generate(maps.length, (i) {
    return Product(
      id: maps[i]['id'],
      title: maps[i]['title'],
      description: maps[i]['description'],
      quantity: maps[i]['quantity'],
      price: maps[i]['price'],
      imageEncoded: maps[i]['imageEncoded'],
      profilePicture: maps[i]['profilePicture'],
    );
  });
}

Future<void> updateProduct(Product product) async {
  final db = await createDatabase();
  await db.update(
    'products',
    product.toMap(),
    where: 'id = ?',
    whereArgs: [product.id],
  );
}

Future<void> deleteProduct(int id) async {
  final db = await createDatabase();
  await db.delete(
    'products',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> insertOrder(Order order) async {
  final db = await createDatabase();
  await db.insert(
    'orders',
    order.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  print("orderADD");
}

Future<List<Order>> orders() async {
  final db = await createDatabase();
  final List<Map<String, dynamic>> maps = await db.query('orders');
  return List.generate(maps.length, (i) {
    return Order(
      id: maps[i]['id'],
      name: maps[i]['name'],
      description: maps[i]['description'],
      city: maps[i]['city'],
      datetime: maps[i]['datetime'],
      location: maps[i]['location'],
    );
  });
}

Future<void> updateOrder(Order order) async {
  final db = await createDatabase();
  await db.update(
    'orders',
    order.toMap(),
    where: 'id = ?',
    whereArgs: [order.id],
  );
}

Future<void> deleteOrder(int id) async {
  final db = await createDatabase();
  await db.delete(
    'orders',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> insertOrderItem(OrderItem orderItem) async {
  final db = await createDatabase();
  await db.insert(
    'orderItems',
    orderItem.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<OrderItem>> orderItems() async {
  final db = await createDatabase();
  final List<Map<String, dynamic>> maps = await db.query('orderItems');
  return List.generate(maps.length, (i) {
    return OrderItem(
      id: maps[i]['id'],
      quantity: maps[i]['quantity'],
      pID: maps[i]['pID'],
      oID: maps[i]['oID'],
      description: maps[i]['description'],
    );
  });
}

Future<void> updateOrderItem(OrderItem orderItem) async {
  final db = await createDatabase();
  await db.update(
    'orderItems',
    orderItem.toMap(),
    where: 'id = ?',
    whereArgs: [orderItem.id],
  );
}

Future<void> deleteOrderItem(int id) async {
  final db = await createDatabase();
  await db.delete(
    'orderItems',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> insertDelivery(Delivery delivery) async {
  final db = await createDatabase();
  await db.insert(
    'deliveries',
    delivery.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
