import 'package:get/get.dart';
import 'package:tahaelectronic/API/localAPI/local_api_helper.dart';
import 'package:tahaelectronic/models/order.dart';

class OrderController extends GetxController {
  RxList<Order> orderlist = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrder();
  }

  void loadOrder() async {
    orderlist.value = await orders();

    update();
  }

  void searchOrder(String query) async {
    orderlist.value = await orders();

    update();
  }
}

class OrderItemController extends GetxController {
  RxList<OrderItem> orderItemlist = <OrderItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrderItem(-1);
  }

  void loadOrderItem(int orderID) async {
    orderItemlist.value = await orderItems();

    orderItemlist.value = orderItemlist.value
        .where(
          (e) => e.oID == orderID,
        )
        .toList();

    update();
  }
}
