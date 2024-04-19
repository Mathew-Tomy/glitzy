import 'dart:convert';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Addressbook_modal.dart';
import 'package:glitzy/modals/Cart_modal.dart';
import 'package:glitzy/modals/Payment_Method_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 // No prefix needed if there's no conflict with other imports
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dashboard_screen.dart';
import './ stripe_Payment.dart';
import 'package:glitzy/screens/checkout/stripe_service.dart';

class Ordercheckout extends StatefulWidget {

  const Ordercheckout({Key? key, this.productsCart, this.selectedAddress,required this.selectedMethod,  required this.totalAmount}) : super(key: key);
  final  List<Products> ?productsCart;
  final AddressData ?selectedAddress;
  final String selectedMethod; // Add selectedMethod here
  final String totalAmount;


  @override
  _OrdercheckoutState createState() => _OrdercheckoutState();
}

class _OrdercheckoutState extends State<Ordercheckout> {


  bool isLoadingButton = false;
  List productIds = [];
  // List product_option_value_id = [];
  List product_quantity = [];

  String ?products;
  // String ?optionvalueId;
  String ?quantity;

  List<PaymentMethods>? paymentMethods = [];
  PaymentMethods ?selectedMethod;

  bool isLoading = true;

  // get totalAmount => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _getPayment();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Checkout Order',style: TextStyle(color: CustomColor.accentColor),),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('Shipping Address',style: TextStyle(fontSize: 17,color: CustomColor.accentColor,fontWeight: FontWeight.bold),),
            ),
        SizedBox(height: 10,),
        Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.grey.shade200)),
              padding: EdgeInsets.only(left: 12, top: 8, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${widget.selectedAddress!.firstname!.toUpperCase()} ${widget.selectedAddress!.lastname!.toUpperCase()}",
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  createAddressText(
                      widget.selectedAddress!.ship_company.toString(), 16),
                 createAddressText(widget.selectedAddress!.ship_address1.toString() + ',' + widget.selectedAddress!.ship_address2.toString(), 6),
                  createAddressText(widget.selectedAddress!.ship_city.toString() + ',' + widget.selectedAddress!.ship_zip.toString(), 6),
                  SizedBox(
                    height: 6,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.selectedAddress!.ship_zip.toString() + ',' + widget.selectedAddress!.ship_country.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
                      // TextSpan(
                      //     text: "02222673745",
                      //     style:TextStyle(color: Colors.black, fontSize: 12)),
                    ]),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 1,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text(
                'Select payment method: ${widget.selectedMethod}',
                style: TextStyle(fontSize: 17,color: CustomColor.accentColor,fontWeight: FontWeight.bold),
              ),
            ),
            isLoading ? Padding(
              padding: const EdgeInsets.all(8.0),
              // child: Center(
              //   child: CircularProgressIndicator(),
              // ),
            ) : Column(
              children: [
                // paymentWidget(),
                SizedBox(height: 10), // Add some space between the payment widget and the selected payment method
                // Text(
                //   'Selected payment method:  ${widget.totalAmount}', // Display the selected payment method or "None" if no method is selected
                //   style: TextStyle(fontSize: 16, color: Colors.black),
                // ),
              ],
            ),

            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('Shopping Cart',style: TextStyle(fontSize: 17,color: CustomColor.accentColor,fontWeight: FontWeight.bold),),
            ),
            createCartList(),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount',style: TextStyle(fontSize: 17,color: CustomColor.accentColor,fontWeight: FontWeight.bold),),
                  Text(' ${widget.totalAmount}',style: TextStyle(fontSize: 17,color: CustomColor.accentColor,fontWeight: FontWeight.bold),),
                ],
              )
            ),
            SizedBox(height: 15,),
            // _paymentWidget(context),
            _proceedButton(),

           ],
         ),
      ),
    );
  }




  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style:TextStyle(fontSize: 12, color: Colors.grey.shade800),
      ),
    );
  }

  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        Products products = widget.productsCart![position];
        return createCartListItem(products);
      },
      itemCount: widget.productsCart!.length,
    );
  }

  createCartListItem(item) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Total : ${item.total.toString()}',
                              style: TextStyle(color: Colors.green),
                            ),
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
      ],
    );
  }
  Widget _proceedButton() {
    return isLoadingButton
        ? Center(
      // child: CircularProgressIndicator(),
    )
        : GestureDetector(
      child: Container(
        height: 45,
        width: 75,
        decoration: BoxDecoration(
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Place Order',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
      onTap: () async {
        for (var i = 0; i < widget.productsCart!.length; i++) {
          product_quantity.add(widget.productsCart![i].quantity);
        }
        quantity = product_quantity.join(",");
        // setState(() {
        //   isLoadingButton = true;
        // });
        // Check the selected payment method
        if (widget.selectedMethod == 'Stripe') {
          // Navigate to StripeCheckouts page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StripeCheckout(totalAmount: widget.totalAmount),
            ),
          );
        } else if (widget.selectedMethod == 'Cash On Delivery') {
          // Handle Cash On Delivery payment method
          _saveCashOnDeliveryOrder(context);
        }
        // else {
        //   // Handle other payment methods if needed
        //   _saveOrder(context);
        // }
      },
    );
  }

  // Widget _paymentWidget(BuildContext context) {
  //   return ListTile(
  //     leading: Icon(
  //       Icons.person,
  //       color: CustomColor.accentColor,
  //       size: 25,
  //     ),
  //     title: Text(
  //       'Profile',
  //       style: TextStyle(color: Colors.black38, fontSize: 15),
  //     ),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => StripeCheckouts(totalAmount: widget.totalAmount.toString())),
  //       );
  //     },
  //
  //   );
  // }


  _saveCashOnDeliveryOrder(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    String url =  ApiUrl.checkout;
    try {
    Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body:{
          'customer_id':userId.toString(),
          'bill_first_name':widget.selectedAddress!.firstname,
          'bill_last_name':widget.selectedAddress!.lastname,
          'bill_address1':widget.selectedAddress!.ship_address1,
          'bill_address2':widget.selectedAddress!.ship_address2,
          'bill_phone':widget.selectedAddress!.phone,
          'bill_email':widget.selectedAddress!.email,
          'bill_zip':widget.selectedAddress!.ship_zip,
          'bill_city':widget.selectedAddress!.ship_city,
          'bill_country':widget.selectedAddress!.ship_country,
          'bill_company':widget.selectedAddress!.ship_company,

        }
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoadingButton = false;
      });
      _showMyDialog('Order has been placed');
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData['success'] == 'Success: API session successfully started!') {
        _showMyDialog('Order Placed successfully');
        Navigator.pushReplacementNamed(context, "/dashboard");
      } else {
        showSnackbar('Order not placed: ${responseData['error']}');
      }
    } else if (response.statusCode == 302) {
      // Handle redirection
      String? redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        print('Redirecting to: $redirectUrl');
        // Optionally, you can navigate to the login screen here
        Navigator.pushReplacementNamed(context, "/dashboard");
      }
    } else {
      print('Failed to checkout: ${response.statusCode}');
      showSnackbar('Failed to checkout. Please try again later.');
    }
    } catch (error) {
      print('Error checkout: $error');
      showSnackbar('An error occurred while checkout. Please try again later.');
    }
  }


  //
  // _saveOrder(BuildContext context) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
  //   String url =  ApiUrl.checkout;
  //   try {
  //     Response response = await post(
  //         Uri.parse(url),
  //         headers: {
  //           "Content-Type": "application/x-www-form-urlencoded",
  //         },
  //         body:{
  //           'customer_id':userId.toString(),
  //           'bill_first_name':widget.selectedAddress!.firstname,
  //           'bill_last_name':widget.selectedAddress!.lastname,
  //           'bill_address1':widget.selectedAddress!.ship_address1,
  //           'bill_address2':widget.selectedAddress!.ship_address2,
  //           'bill_phone':widget.selectedAddress!.phone,
  //           'bill_email':widget.selectedAddress!.email,
  //           'bill_zip':widget.selectedAddress!.ship_zip,
  //           'bill_city':widget.selectedAddress!.ship_city,
  //           'bill_country':widget.selectedAddress!.ship_country,
  //           'bill_company':widget.selectedAddress!.ship_company,
  //
  //         }
  //     );
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         isLoadingButton = false;
  //       });
  //       _showMyDialog('Order has been placed');
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       print(responseData);
  //       if (responseData['success'] == 'Success: API session successfully started!') {
  //         _showMyDialog('Order Placed successfully');
  //         Navigator.pushReplacementNamed(context, "/dashboard");
  //       } else {
  //         showSnackbar('Order not placed: ${responseData['error']}');
  //       }
  //     } else if (response.statusCode == 302) {
  //       // Handle redirection
  //       String? redirectUrl = response.headers['location'];
  //       if (redirectUrl != null) {
  //         print('Redirecting to: $redirectUrl');
  //         // Optionally, you can navigate to the login screen here
  //         Navigator.pushReplacementNamed(context, "/dashboard");
  //       }
  //     } else {
  //       print('Failed to checkout: ${response.statusCode}');
  //       showSnackbar('Failed to checkout. Please try again later.');
  //     }
  //   } catch (error) {
  //     print('Error checkout: $error');
  //     showSnackbar('An error occurred while checkout. Please try again later.');
  //   }
  // }

  showSnackbar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.all(10),
      backgroundColor: CustomColor.accentColor,
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      duration: Duration(seconds: 4),
    ));
  }

  Future<void> _showMyDialog(msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    Dashboard()), (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }



}
