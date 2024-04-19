import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Order_list_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/screens/order_summary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import 'package:intl/intl.dart';

// import 'package:glitzy/config/theme.dart';
class Ordrslist extends StatefulWidget {
  const Ordrslist({Key? key}) : super(key: key);

  @override
  _OrdrslistState createState() => _OrdrslistState();
}

class _OrdrslistState extends State<Ordrslist> {
  bool isLoading = true;
  List<Orders> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrders();
  }

  _getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    String url = ApiUrl.orderList + '/$userId';
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      //print(responseData);
      List<dynamic> order = responseData['orders'];
      //print(cart);
      if (order.length > 0) {
        for (var item in order) {
          // Create a new Map<String, dynamic> to hold the converted values
          Map<String, dynamic> convertedItem = {};

          // Iterate over each key-value pair in the original map
          item.forEach((key, value) {
            // Convert the value to String if it's not already a String
            convertedItem[key.toString()] = value.toString();
          });

          // Pass the converted map to Products.fromJson()
          orders!.add(Orders.fromJson(convertedItem));
        }

        print(orders);
      } else {
        showSnackbar('No orders');
      }
    } else {
      print('Contact admin');
    }
  }

  showSnackbar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.all(10),
      backgroundColor: CustomColor.primaryColor,
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      duration: Duration(seconds: 4),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Orders',style: TextStyle(color:CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : orderWidget(),

    );
  }

  //
  Widget orderWidget() {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return GestureDetector(

          child: Card(
            elevation: 6,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(orders[index].created_at!))}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Transaction Number: ${orders[index].transaction_number!}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Count: ${orders[index].total}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Order Price: ${orders[index].total_price}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(orders[index].status.toString()), // Access status from individual Orders object
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          orders[index].status.toString(), // Access status from individual Orders object
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            if (orders[index] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ordersummary(orderId: orders[index].orderId.toString()),
                ),
              );
            } else {
              // Handle the case where orders[index] is null
              // You can show an error message or handle it in another appropriate way
              print('Order at index $index is null.');
            }
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


}