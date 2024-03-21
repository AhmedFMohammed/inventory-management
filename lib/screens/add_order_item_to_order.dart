import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahaelectronic/controllers/orderController.dart';
import 'package:tahaelectronic/controllers/productController.dart';
import 'package:tahaelectronic/models/order.dart';
import 'package:tahaelectronic/models/products.dart';
import 'package:tahaelectronic/screens/home_page.dart';

class AddOITO extends StatefulWidget {
  final Order order;

  const AddOITO({super.key, required this.order});

  @override
  State<AddOITO> createState() => _AddOITOState();
}

class _AddOITOState extends State<AddOITO> {
  List<Product> products = [];
  List<OrderItem> orderItemlist = [];
  @override
  void initState() {
    Get.find<OrderItemController>().loadOrderItem(widget.order.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_outlined)),
                Text(
                  "${widget.order.name}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.find<ProductController>().loadProducts();
                    },
                    child: const Text("reload")),
              ],
            ),
            Expanded(
              child: GetBuilder<ProductController>(
                builder: (_) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: _.productlist.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        products = _.productlist;
                        // Product p = products
                        //     .where((e) => e.id == orderItemlist.contains(e.id))
                        //     .last;
                        bool? ordera = false;
                        OrderItem order = OrderItem();
                        for (var e
                            in Get.find<OrderItemController>().orderItemlist) {
                          if (e.pID == products[index].id) {
                            order = e;
                            ordera = true;
                          }
                        }

                        return ProductCard(
                          orderID: widget.order.id!,
                          order: order,
                          product: products[index],
                          ordera: ordera!,
                          page: "ADDOITO",
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
