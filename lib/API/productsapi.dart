// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart';
// import 'package:tahainventory/models/products.dart';

// import 'api_helper.dart';

// class APIProduct {
//   APIHelper _apiHelper = APIHelper();
//   Future<List<Product>> getProduct() async {
//     List<Product> product = [];
//     Response? response = await _apiHelper.get(path: "/products", Header: 2);
//     List js = json.decode(response!.body);

//     for (var j in js) {
//       product.add(Product.fromJson(j));
//     }
//     return product;
//   }

//   Future<Product> AddProduct(Product product) async {
//     try {
//       Response? response =
//           await _apiHelper.post(path: "/products/", Header: 2, body: product);
//     } catch (e) {
//       print(e);
//     }

//     return product;
//   }

//   Future<Product> EditProduct(Product product) async {
//     try {
//       Response? response = await _apiHelper.put(
//           path: "/products/${product.id}", Header: 2, body: product);
//     } catch (e) {
//       print(e);
//     }

//     return product;
//   }

//   Future<Product> DeleteProduct(Product product) async {
//     try {
//       Response? response =
//           await _apiHelper.delete(path: "/product/${product.id}", Header: 2);
//     } catch (e) {
//       print(e);
//     }

//     return product;
//   }

//   Future<void> sendFiletodjango({
//     required File file,
//   }) async {
//     Map data = {};
//     String base64file = base64Encode(file.readAsBytesSync());
//     String fileName = file.path.split("/").last;
//     data['name'] = fileName;
//     data['file'] = base64file;
//     try {
//       var response = await _apiHelper.post(
//           path: "/addimage", Header: 2, body: json.encode(data));
//     } catch (e) {
//       throw (e.toString());
//     }
//   }
// }
