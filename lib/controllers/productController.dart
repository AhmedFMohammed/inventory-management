import 'package:get/get.dart';

import 'package:tahaelectronic/API/localAPI/local_api_helper.dart';
import 'package:tahaelectronic/models/products.dart';

class ProductController extends GetxController {
  RxList<Product> productlist = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() async {
    productlist.value = await products();
    update();
  }

  void searchProducts(String query) async {
    productlist.value = await products();
    productlist.value = productlist.value
        .where((e) => e.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    update();
  }
}
