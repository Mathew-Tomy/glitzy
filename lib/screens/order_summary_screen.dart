import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/order_detail_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:glitzy/screens/product_detail_screen.dart';
import 'package:glitzy/screens/product_return.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ordersummary extends StatefulWidget {


  const Ordersummary({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  _OrdersummaryState createState() => _OrdersummaryState();
}

class _OrdersummaryState extends State<Ordersummary> {

  bool isLoading = true;
  List<Products> products = [];
  Order order = Order();

  double getTotalSum() {
    double totalSum = 0.0;
    if (products != null) {
      for (Products product in products) {
        totalSum += double.parse(product.totalPrice.toString() ?? '0');
        // Convert totalPrice to string explicitly with toString()
      }
    }
    return totalSum;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrderSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Order Summary',style: TextStyle(color:CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView(
        children: [
          _orderIdCard(),
          _products(),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right: 10),
            child: Divider(thickness: 1.5,),
          ),
          _totalAmount(),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right: 10),
            child: Text('Address',style: TextStyle(fontSize: 17,color: Colors.grey,fontWeight: FontWeight.w700),),
          ),
          _address(),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right: 10),
            child: Text('Payment',style: TextStyle(fontSize: 17,color: Colors.grey,fontWeight: FontWeight.w700),),
          ),
          order.paymentMethod == 'Stripe' ? _paymentMethodOnline() : _paymentMethodCOD(),
        ],

      ),

    );
  }

  _getOrderSummary() async {
    String url = ApiUrl.orderSummary + '/${widget.orderId}';
    try {
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
        print(responseData);

        // Parse order data
        if (responseData.containsKey('order') && responseData['order'] is List) {
          List<dynamic> orderData = responseData['order'];
          if (orderData.isNotEmpty) {
            order = Order.fromJson(orderData[0]); // Assuming there's only one order in the list
          } else {
            print('No order data found');
          }
        } else {
          print('Order data is missing or not in the expected format');
        }

        // Parse products data
        if (responseData.containsKey('products') && responseData['products'] is List) {
          List<dynamic> productsData = responseData['products'];
          products.clear(); // Clear existing products list
          for (dynamic data in productsData) {
            // Ensure that each item is a map before parsing
            if (data is Map<String, dynamic>) {
              products.add(Products.fromJson(data));
            }
          }
        } else {
          print('Products data is missing or not in the expected format');
        }

      } else {
        print('Failed to load order summary: ${response.statusCode}');
        // Handle the error, show a message to the user, or retry
      }
    } catch (e) {
      print('Error fetching order summary: $e');
      // Handle the error, show a message to the user, or retry
    }
  }



  sortDate(date){
    final DateFormat formatter = DateFormat('dd-MMMM-y');
    final String formatted = formatter.format(date);
    return formatted;
  }


  _orderIdCard() {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text('Order Transaction Number : ${order.transactionNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(order.createdAt!))}'),
            Text('Payment Status: ${order.paymentStatus}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400)),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(order.status.toString()), // Access status from individual Orders object
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            order.status.toString(), // Access status from individual Orders object
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }


  _products() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.assignment_return_rounded,
                  color: Colors.red,
                  size: 35,
                ),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Productreturn(productId:products[index].productId.toString(),
                   product:products[index].productName.toString(), orderProductId: products[index].orderProductId.toString(),orderId: widget.orderId,quantity: products[index].qty.toString(),optionId: products[index].optionId.toString(), ),),)
                },
              ),
              Container(
                height: 25,
                width: 25,
                child: Center(child: Text(products[index].qty.toString())),
                color: Colors.white60,
              ),

              SizedBox(width: 10,),
              Icon(Icons.close, size: 12, color: Colors.grey,),
              Flexible(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Productdetail(productId: products[index]!.productId.toString()),
                      ),
                    );
                  },
                  title: Text(

                    products[index].productName.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${products[index].price}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),),
                      Text('Color: ${products[index].color}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),),
                      Text('Size: ${products[index].size}', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),),
                    ],
                  ),
                ),

              ),

              Text(
                products[index].totalPrice.toString(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: CustomColor.accentColor),
              ),

            ],
          );
        },

      ),

    );
  }

  _totalAmount() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
          Text(getTotalSum().toStringAsFixed(2), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: CustomColor.accentColor),)


        ],
      ),
    );
  }

  _address() {
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(order.firstName!.toUpperCase() + ' ' + order. lastName!.toUpperCase().toString(),style: TextStyle(fontWeight: FontWeight.w300),),
         Text(order.paymentCompany.toString(),style: TextStyle(fontWeight: FontWeight.w300),),
         Text(order.paymentAddress1 .toString()+ ',' + order.paymentAddress2.toString(),style: TextStyle(fontWeight: FontWeight.w300),),
         Text(order.paymentCity.toString() + ',' + order.paymentPostcode.toString(),style: TextStyle(fontWeight: FontWeight.w300),),
         Text(order.paymentPostcode.toString() + ',' + order.paymentCountry.toString(),style: TextStyle(fontWeight: FontWeight.w300),),

       ],
     ),
   );
  }
  _paymentMethodCOD(){
    return ListTile(
      leading: Image.asset(
        'https://glitzystudio.ca/assets/images/1631032407index.png',
        width: 50,
        height: 50,
      ),
      title: Text('Cash on delivery'),
    );
  }

  _paymentMethodOnline(){
    return ListTile(
      leading: Image.network(
        'https://glitzystudio.ca/assets/images/1601930611stripe-logo-blue.png',
        width: 50,
        height: 50,
      ),
      title: Text('Stripe'),
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


