import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Cart_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/screens/checkout/address_select.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';


import '../product_detail_screen.dart';


class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}



class _CartState extends State<Cart> {

  bool isLoading = true;
  List<Products> ?productsCart = [];
  double cartTotal = 0;
  double getTotalSum() {
    double totalSum = 0.0;
    if (productsCart != null) {
      for (Products product in productsCart!) {
        totalSum += double.parse(product.total ?? '0');
      }
    }
    return totalSum;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCart();
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


  _getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    String url = ApiUrl.cart + '/$userId'; // Concatenate customer ID to the URL
    Response response = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        cartTotal = 0;
        isLoading = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      //print(responseData);
      List<dynamic> cart = responseData['products'];
      //print(cart);
      if (cart.length > 0) {

        for (var item in cart) {
          // Create a new Map<String, dynamic> to hold the converted values
          Map<String, dynamic> convertedItem = {};

          // Iterate over each key-value pair in the original map
          item.forEach((key, value) {
            // Convert the value to String if it's not already a String
            convertedItem[key.toString()] = value.toString();
          });

          // Pass the converted map to Products.fromJson()
          productsCart!.add(Products.fromJson(convertedItem));
        }

        print(productsCart);

      } else {
        showSnackbar('No products in cart');
      }
    } else {
      print('Contact admin');
    }
  }


  _updateCart(String product_id, String quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer

    String url = ApiUrl.cartedit;
    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'product_id': product_id,
          // 'quantity': quantity.toString(),
          'customer_id': userId.toString(), // Pass the userId variable
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        if (responseData.containsKey('success')) {
          showSnackbar(responseData['success']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cart()),
          );
        } else if (responseData.containsKey('error')) {
          showSnackbar(responseData['error']);
        } else {
          print('Unexpected response from server');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error'); // Handle network errors or exceptions
    }
  }

  _reduceupdateCart(String product_id, String quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer

    String url = ApiUrl.cartreduce;
    try {
      setState(() {
        isLoading = true; // Set isLoading to true when request begins
      });

      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'product_id': product_id,
          'quantity': quantity.toString(),
          'customer_id': userId.toString(), // Pass the userId variable
        },
      );

      setState(() {
        isLoading = false; // Set isLoading to false when request completes
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);

        if (responseData.containsKey('success')) {
          showSnackbar(responseData['success']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cart()),
          );
        } else if (responseData.containsKey('error')) {
          showSnackbar(responseData['error']);
        } else {
          print('Unexpected response from server');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error'); // Handle network errors or exceptions
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(

        title: ListTile(title: Text('Shopping cart',style: TextStyle(color: Colors.black),),
          subtitle: productsCart!.length > 0  ? Text(
            "Total(${productsCart!.length}) Items",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ) : Text('')
          ,),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home,
              color: CustomColor.accentColor,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/dashboard");

            },
          )
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :productsCart!.length > 0 ? cartWidget() : emptyWidgetCart(),

    );
  }

  emptyWidgetCart(){
    return Center(
      child: Text('Your shopping cart is empty',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: CustomColor.accentColor),),
    );
  }

  cartWidget() {
    return ListView(
      children: [
        createCartList(),
        SizedBox(height: 15,),
        footer(context),


      ],
    );
  }



  footer(BuildContext context) {
    double totalSum = getTotalSum(); // Call your getTotalSum method here
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total Amount",
                  style: TextStyle(color: Colors.grey, fontSize: 15,fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  'Total: \$${totalSum.toStringAsFixed(2)}', // Format total as currency
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutAddress(
                    productsCart: productsCart,
                    totalAmount: totalSum.toStringAsFixed(2),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CustomColor.accentColor), // Set background color here
              padding: MaterialStateProperty.all(EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              )),
            ),
            child: Text(
              "Checkout",
              style: TextStyle(color: Colors.white),
            ),
          ),

          //Utils.getSizedBox(height: 8),
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }


  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        Products products = productsCart![position];
        return createCartListItem(products);
      },
      itemCount: productsCart!.length,
    );
  }

  createCartListItem(item) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Productdetail(productId: item.product_id.toString(), ),),)
          },
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      color: Colors.blue.shade200,
                      image: DecorationImage(
                          image: NetworkImage(item.photo.toString())
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            item.product_name.toString(),
                            maxLines: 2,
                            softWrap: true,
                            style:TextStyle(fontSize: 14),
                          ),

                        ),
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            item.size.toString(),
                            maxLines: 2,
                            softWrap: true,
                            style:TextStyle(fontSize: 14),
                          ),

                        ),

                        // Text(
                        //  ' Price : ${item.price.toString()}',
                        //   style: TextStyle(color: Colors.grey, fontSize: 14),
                        // ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Text(
                              //   'Product Price : ${item.price.toString()}',
                              //   style: TextStyle(color: Colors.green),
                              // ),
                              Text(
                                'Total Price : ${item.total.toString()}',
                                style: TextStyle(color: Colors.green),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Icon(
                                        Icons.remove,
                                        size: 24,
                                        color: Colors.grey.shade700,
                                      ),
                                      onTap: () => {
                                        cartCalculationReduce(item.product_id.toString(), item.quantity.toString(), item.product_name.toString())
                                      },
                                    ),
                                    Container(
                                      color: Colors.grey.shade200,
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 12, left: 12),
                                      child: Text(
                                        item.quantity.toString(),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.add,
                                        size: 24,
                                        color: Colors.grey.shade700,
                                      ),
                                      onTap: () => {
                                        cartCalculationAdd(item.product_id.toString(), item.quantity.toString(), item.product_name.toString())
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 100,
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10, top: 8),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: CustomColor.accentColor),
            ),
            onTap: () => {
              _confirmDelete(context, item.product_id.toString(),item.product_name.toString(),)
            },
          ),
        )
      ],
    );
  }


  cartCalculationAdd(String product_id,String quantity,String product_name){
    print(quantity);
    int qty = int.parse(quantity);
    qty = qty + 1;
    setState(() {
      isLoading = true;
      productsCart = [];
    });
    _updateCart(product_id, qty.toString());
  }
  cartCalculationReduce(String product_id,String quantity,String product_name){
    print(quantity);
    int qty = int.parse(quantity);
    if(qty == 1){
      _confirmDelete(context, product_id, product_name);
    }  if(qty  != 1) {
      qty = qty - 1;
      setState(() {
        isLoading = true;
        productsCart = [];
      });
      _reduceupdateCart(product_id, qty.toString());
    }
  }


  void _confirmDelete(context,String product_id,String product_name) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text('No', style: TextStyle(color: Colors.green)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text('Yes', style: TextStyle(color:  Colors.green)),
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        _removeFromCart(product_id);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Confirm', style: TextStyle(fontSize: 18),),
      content: Text('Do you want to remove $product_name from cart ?', style: TextStyle(fontSize: 13, color:Colors.black)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  _removeFromCart(String product_id) async {
    Navigator.pop(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    String url = ApiUrl.cartdelete;

    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'product_id': product_id,
          'customer_id': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body); // Parse JSON response

        if (responseData is Map<String, dynamic>) { // Check if response data is a map
          if (responseData.containsKey('success')) {
            showSnackbar(responseData['success']);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Cart()),
            );
          } else if (responseData.containsKey('error')) {
            showSnackbar(responseData['error']);
          } else {
            print('Unexpected response from server');
          }
        } else {
          print('Invalid response data type');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error'); // Handle network errors or exceptions
    }
  }


}

