import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tahaelectronic/API/deliveryAPI.dart';
import 'package:tahaelectronic/API/localAPI/local_api_helper.dart';
import 'package:tahaelectronic/API/orderAPI.dart';
import 'package:tahaelectronic/API/productsapi.dart';
import 'package:tahaelectronic/controllers/orderController.dart';
import 'package:tahaelectronic/controllers/productController.dart';
import 'package:tahaelectronic/models/delivery.dart';
import 'package:tahaelectronic/models/products.dart';
import 'package:tahaelectronic/screens/add_order_item_to_order.dart';
import 'package:tahaelectronic/screens/home_page.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

import '../models/order.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> orderlist = [];
  List<Product> productlist = [];
  List<Delivery> deliverylist = [
    Delivery(id: 1, city: "others", price: 8000),
    Delivery(id: 2, city: "baghdad", price: 5000),
  ];
  List<OrderItem> orderItemlist = [];
  var selectedValue;

  @override
  void initState() {
    Get.find<OrderController>().loadOrder();

    super.initState();
  }

  Future<void> _dialogBuilder(
      BuildContext context, List<DropdownMenuItem<String>> list) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          selectedValue = list[0].value;

          return AlertDialog(
            title: const Text('Add Order'),
            content: Container(
              height: 300,
              child: Column(
                children: [
                  CTextField(title: "name", textController: nameController),
                  CTextField(
                      title: "description",
                      textController: descriptionController),
                  CTextField(
                      title: "location", textController: locationController),
                  StatefulBuilder(
                    builder: (context, setState) => DropdownButton(
                      value: selectedValue,
                      items: list,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    print(selectedValue);
                    var order = Order(
                        name: nameController.text,
                        city: selectedValue,
                        description: descriptionController.text,
                        location: locationController.text);
                    await insertOrder(order);
                    Navigator.pop(context);
                  },
                  child: const Text("add Order")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 75,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                   
                                  Navigator.pop(context);
                                },
                                icon:
                                    const Icon(Icons.arrow_back_ios_outlined)),
                            
                                ElevatedButton(
                                    onPressed: () {
                                      // show dialog
                                      List<DropdownMenuItem<String>> list =
                                          deliverylist.map(
                                        (e) {
                                          return DropdownMenuItem(
                                            value: "${e.city}",
                                            child: Text(e.city!),
                                          );
                                        },
                                      ).toList();
                                      _dialogBuilder(context, list);
                                      Get.find<OrderController>().loadOrder();
                                    },
                                    child: const Text("Add")),
                              
                          ],
                        ),
                      ),
                    ]),
              ),
              OrderListWidget(
                  orders: orderlist,
                  orderItemlist: orderItemlist,
                  product: productlist)
            ],
          ),
        ),
      ),
    );
  }
}

class OrderListWidget extends StatefulWidget {
  final List<Order>? orders;
  final List<OrderItem>? orderItemlist;
  final List<Product>? product;
  const OrderListWidget(
      {super.key, this.orders, this.orderItemlist, this.product});

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  List<Delivery> deliverylist = [
    Delivery(id: 1, city: "others", price: 8000),
    Delivery(id: 2, city: "baghdad", price: 5000),
  ];
  @override
  void initState() {
    super.initState();
  }

  Future<void> _dialogBuilder2(BuildContext context, Order order) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete ?'),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    //delete orderItem
                    await deleteOrder(order.id!);
                    Get.find<OrderController>().loadOrder();
                    Get.find<OrderItemController>().loadOrderItem(-1);
                    Navigator.pop(context);
                  },
                  child: const Text("Yes")),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<OrderController>(
        builder: (_) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _.orderlist.length,
            itemBuilder: (context, index) {
              var order = _.orderlist[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    print("hi");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderItemsScreen(order: order),
                        ));
                  },
                  onLongPress: () {
                    _dialogBuilder2(context, order);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: ListTile(
                      title: Text("${order.name}"),
                      leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddOITO(order: order),
                                ));
                          },
                          icon: Icon(Icons.add)),
                      trailing: IconButton(
                        icon: const Icon(Icons.print),
                        onPressed: () async {
                          var totalPrice = 0;
                          Get.find<OrderItemController>()
                              .loadOrderItem(order.id!);
                          Get.find<ProductController>().loadProducts();
                          var oerderItems =
                              Get.find<OrderItemController>().orderItemlist;

                          var orderItemsss = oerderItems.map((e) {
                            Product p = Get.find<ProductController>()
                                .productlist
                                .where((ee) => ee.id == e.pID)
                                .last;

                            var total = p.price! * num.parse("${e.quantity}");
                            totalPrice += int.parse("$total");
                            return [
                              p.profilePicture,
                              "${p.title}",
                              "${e.quantity}",
                              "${p.price}",
                              "$total",
                            ];
                          }).toList();
                          print(order.city);
                          var delivery = deliverylist
                              .where((e) => e.city == order.city)
                              .first;

                          final pdf = pw.Document();
                          const itemsPerPage = 17;
                          final totalPages =
                              (orderItemsss.length / itemsPerPage).ceil();

                          for (var i = 0; i < totalPages; i++) {
                            final startIndex = i * itemsPerPage;
                            final endIndex = (startIndex + itemsPerPage <
                                    orderItemsss.length)
                                ? startIndex + itemsPerPage
                                : orderItemsss.length;
                            final currentPageItems =
                                orderItemsss.sublist(startIndex, endIndex);

                            pdf.addPage(pw.MultiPage(
                              // ... (page configuration)
                              build: (pw.Context context) => [
                                if (i == 0)
                                  pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("Taha Electronic"),
                                      pw.Text("name :${order?.name}"),
                                      pw.Text("location : ${order?.location}"),
                                      pw.Text(
                                          "description: ${order?.description}"),
                                    ],
                                  ),
                                pw.Container(height: 10),
                                _buildInvoiceTable(context, currentPageItems),
                                if (i == totalPages - 1)
                                  pw.Container(
                                    padding: const pw.EdgeInsets.all(5),
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Text(
                                        'Total Price: $totalPrice IQD + ${delivery.price} IQD = ${totalPrice + delivery.price!} IQD'),
                                  ),
                              ],
                            ));
                          }

                          pdf.save();

                          try {
                            final Directory? appDocDir =
                                await getDownloadsDirectory();
                            final String appDocPath = appDocDir!.path;

                            final File file =
                                File('$appDocPath/${order.id}.pdf');

                            await file.writeAsBytes(await pdf.save());

                            OpenFile.open(file.path);

                            print('PDF saved to: ${file.path}');
                          } catch (error) {
                            print('Error saving PDF: $error');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  pw.Widget _buildInvoiceTable(pw.Context context, var orderItems) {
    final List<pw.TableRow> tableRows = [];

    tableRows.add(_buildTableRow(context, [
      pw.Text('Image'),
      pw.Text('Item'),
      pw.Text('Quantity'),
      pw.Text('Price'),
      pw.Text('Total Price')
    ]));

    for (var p in orderItems) {
      tableRows.add(_buildTableRow(
        context,
        [
          pw.Container(
            height: 25,
            padding: const pw.EdgeInsets.all(5),
            child: pw.Image(pw.MemoryImage(p[0] as Uint8List),
                width: 25, height: 25, fit: pw.BoxFit.fill),
          ),
          pw.Container(
            height: 25,
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text("${p[1]}"),
          ),
          pw.Container(
            height: 25,
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text("${p[2]}"),
          ),
          pw.Container(
            height: 25,
            padding: const pw.EdgeInsets.all(5),
            child:
                pw.Text("${p[3]} IQD", style: const pw.TextStyle(fontSize: 10)),
          ),
          pw.Container(
            height: 25,
            padding: const pw.EdgeInsets.all(5),
            child:
                pw.Text("${p[4]} IQD", style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ));
    }

    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1),
      },
      children: tableRows,
    );
  }

  pw.TableRow _buildTableRow(pw.Context context, List<pw.Widget> rowData) {
    return pw.TableRow(
      children: rowData
          .map((cellData) => pw.Container(
                padding: const pw.EdgeInsets.all(5),
                child: cellData,
              ))
          .toList(),
    );
  }
}

class OrderItemsScreen extends StatefulWidget {
  final Order? order;
  const OrderItemsScreen({super.key, this.order});

  @override
  State<OrderItemsScreen> createState() => _OrderItemsScreenState();
}

class _OrderItemsScreenState extends State<OrderItemsScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<OrderItemController>().loadOrderItem(widget.order!.id!);
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_outlined)),
              ],
            ),
            Expanded(child: GetBuilder<OrderItemController>(builder: (_) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _.orderItemlist.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ProductCard(
                        order: _.orderItemlist[index],
                        orderID: widget.order!.id!,
                        page: "order",
                        product: Get.find<ProductController>()
                            .productlist
                            .where((e) => e.id == _.orderItemlist[index].pID)
                            .first);
                  });
            })),
          ],
        ),
      ),
    );
  }
}
