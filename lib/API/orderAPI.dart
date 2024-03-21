// import 'dart:convert';

// import 'package:http/http.dart';

// import '../models/order.dart';
// import 'api_helper.dart';

// class APIOrder {
//   APIHelper _apiHelper = APIHelper();
//   Future<List<Order>> getOrder() async {
//     List<Order> order = [];
//     Response? response = await _apiHelper.get(path: "/orders", Header: 2);
//     List js = json.decode(response!.body);

//     for (var j in js) {
//       order.add(Order.fromJson(j));
//     }
//     return order.reversed.toList();
//   }

//   Future<Order> AddOrder(Order order) async {
//     try {
//       Response? response =
//           await _apiHelper.post(path: "/orders/", Header: 2, body: order);
//     } catch (e) {
//       print(e);
//     }

//     return order;
//   }

//   Future<Order> EditOrder(Order order) async {
//     try {
//       Response? response = await _apiHelper.put(
//           path: "/orders/${order.id}", Header: 2, body: order);
//     } catch (e) {
//       print(e);
//     }

//     return order;
//   }

//   Future<Order> DeleteOrder(Order order) async {
//     try {
//       Response? response =
//           await _apiHelper.delete(path: "/orders/${order.id}", Header: 2);
//     } catch (e) {
//       print(e);
//     }

//     return order;
//   }
// }

// class APIOrderItem {
//   APIHelper _apiHelper = APIHelper();
//   Future<List<OrderItem>> getOrderItem() async {
//     List<OrderItem> orderItem = [];
//     Response? response =
//         await _apiHelper.get(path: "/orders/orderitem/", Header: 2);
//     List js = json.decode(response!.body);

//     for (var j in js) {
//       orderItem.add(OrderItem.fromJson(j));
//     }
//     return orderItem;
//   }

//   Future<OrderItem> AddOrderItem(OrderItem orderItem) async {
//     try {
//       Response? response = await _apiHelper.post(
//           path: "/orders/orderitem/", Header: 2, body: orderItem);
//     } catch (e) {
//       print(e);
//     }

//     return orderItem;
//   }

//   Future<OrderItem> EditOrderItem(OrderItem orderItem) async {
//     try {
//       Response? response = await _apiHelper.put(
//           path: "/orders/orderitem/${orderItem.id}",
//           Header: 2,
//           body: orderItem);
//     } catch (e) {
//       print(e);
//     }

//     return orderItem;
//   }

//   Future<OrderItem> DeleteOrderItem(OrderItem orderItem) async {
//     try {
//       Response? response = await _apiHelper.delete(
//           path: "/orders/orderitem/${orderItem.id}", Header: 2);
//     } catch (e) {
//       print(e);
//     }

//     return orderItem;
//   }
// }
