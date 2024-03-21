import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tahaelectronic/API/localAPI/local_api_helper.dart';
import 'package:tahaelectronic/controllers/orderController.dart';
import 'package:tahaelectronic/controllers/productController.dart';
import 'package:tahaelectronic/models/order.dart';
import 'package:tahaelectronic/models/products.dart';
import 'package:tahaelectronic/screens/orders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();

    Get.put(ProductController());
    Get.find<ProductController>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              // header
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddProductDialog();
                          }),
                      icon: Icon(Icons.add)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            onChanged: (value) {
                              Get.find<ProductController>()
                                  .searchProducts(value);
                            }, // search for products
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            //Get.find<OrderController>().getOrders(-1);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrderPage(),
                                ));
                          },
                          icon: const Icon(Icons.shopping_cart)),
                    ],
                  ),
                ],
              ),
              // body
              Expanded(
                child: GetBuilder<ProductController>(builder: (_) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: _.productlist.length,
                      itemBuilder: (context, index) => ProductCard(
                            order: OrderItem(),
                            product: _.productlist[index],
                          ));
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final bool ordera;
  final Product product;
  final OrderItem order;
  final int orderID;
  final String page;
  const ProductCard(
      {super.key,
      required this.product,
      this.ordera = false,
      required this.order,
      this.orderID = 0,
      this.page = "home"});

  @override
  Widget build(BuildContext context) {
    TextEditingController orderItemQuantityController =
        TextEditingController(text: "${order.quantity}");
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onLongPress: () {
          if (page == "home") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("Delete ${product.title}?"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            deleteProduct(product.id!);
                            Get.find<ProductController>().loadProducts();
                            Navigator.pop(context);
                          },
                          child: Text("Yes"))
                    ],
                  );
                });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          width: 300,
          height: 300,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    image: MemoryImage(product.profilePicture as Uint8List),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: AutoSizeText(
                              "${product.title}",
                              minFontSize: 8,
                              maxFontSize: 28,
                              overflow: TextOverflow.ellipsis,
                            )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          page == "order"
                              ? SizedBox(
                                  width: 40,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: orderItemQuantityController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    onSubmitted: (value) async {
                                      print("object");

                                      // get corrent quantity
                                      int q1 = order.quantity!;
                                      int q2 = product.quantity!;
                                      int q3 = q2 + q1;
                                      if (q3 < int.parse("$value")) {
                                        value = "$q3";
                                        product.quantity =
                                            q3 - int.parse("$value");
                                      } else {
                                        product.quantity =
                                            q3 - int.parse("$value");
                                      }

                                      print(product);
                                      await updateProduct(product);
                                      Get.find<ProductController>()
                                          .loadProducts();

                                      order.quantity = int.parse(value);
                                      await updateOrderItem(order);
                                      Get.find<OrderItemController>()
                                          .loadOrderItem(orderID);
                                      Get.find<ProductController>()
                                          .loadProducts();
                                    },
                                  ))
                              : Text("${product.quantity}"),
                          GestureDetector(
                            onTap: () async {
                              print("hi");

                              if (!ordera) {
                                OrderItem orderItem = OrderItem(
                                    oID: orderID, pID: product.id, quantity: 0);
                                await insertOrderItem(orderItem);
                                Get.find<OrderItemController>()
                                    .loadOrderItem(-1);
                                Get.find<ProductController>().loadProducts();
                              } else {
                                await deleteOrderItem(order.id!);
                                Get.find<OrderItemController>()
                                    .loadOrderItem(-1);

                                Get.find<ProductController>().loadProducts();
                              }
                            },
                            child: page == "home" || page == "order"
                                ? Container()
                                : IconButton(
                                    onPressed: null,
                                    icon: ordera
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CTextField extends StatelessWidget {
  final TextEditingController? textController;
  final String? title;
  const CTextField({super.key, this.textController, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            label: Text("$title"),
          )),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageEncodedController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Price'),
            ),
            ElevatedButton(
                onPressed: () async {
                  imageEncodedController.text = await pickImage();
                },
                child: Text("AddImage")),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            List<int> bytes = base64.decode(imageEncodedController.text);
            // Validate and save the product
            Product newProduct = Product(
              title: titleController.text,
              description: descriptionController.text,
              quantity: int.tryParse(quantityController.text) ?? 0,
              price: int.tryParse(priceController.text) ?? 0,
              imageEncoded: imageEncodedController.text,
              profilePicture: Uint8List.fromList(bytes),
            );
            await insertProduct(newProduct);
            Get.find<ProductController>().loadProducts();

            Navigator.of(context).pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
