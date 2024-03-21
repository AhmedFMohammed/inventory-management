// import 'dart:convert';

// import 'package:http/http.dart';
// import 'package:tahainventory/API/api_helper.dart';
// import 'package:tahainventory/models/delivery.dart';

// class APIDelivery {
//   APIHelper _apiHelper = APIHelper();
//   Future<List<Delivery>> getDelivery() async {
//     List<Delivery> delivery = [];
//     Response? response = await _apiHelper.get(path: "/delivery/", Header: 2);
//     List js = json.decode(response!.body);

//     for (var j in js) {
//       delivery.add(Delivery.fromJson(j));
//     }
//     return delivery;
//   }

//   Future<Delivery> AddDelivery(Delivery delivery) async {
//     try {
//       Response? response =
//           await _apiHelper.post(path: "/delivery/", Header: 2, body: delivery);
//     } catch (e) {
//       print(e);
//     }

//     return delivery;
//   }

//   Future<Delivery> EditDelivery(Delivery delivery) async {
//     try {
//       Response? response = await _apiHelper.put(
//           path: "/delivery/${delivery.id}", Header: 2, body: delivery);
//     } catch (e) {
//       print(e);
//     }

//     return delivery;
//   }

//   Future<Delivery> DeleteDelivery(Delivery delivery) async {
//     try {
//       Response? response =
//           await _apiHelper.delete(path: "/delivery/${delivery.id}", Header: 2);
//     } catch (e) {
//       print(e);
//     }

//     return delivery;
//   }
// }
