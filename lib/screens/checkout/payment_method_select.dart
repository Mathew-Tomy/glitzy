import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Addressbook_modal.dart';
import 'package:glitzy/modals/Cart_modal.dart';
import 'package:glitzy/modals/Payment_Method_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'order_checkout.dart';

class Paymentselect extends StatefulWidget {
  const Paymentselect({Key? key, this.productsCart, this.selectedAddress, required this.totalAmount}) : super(key: key);

  final  List<Products> ?productsCart;
  final AddressData ?selectedAddress;
  final String totalAmount;


  @override
  _PaymentselectState createState() => _PaymentselectState();
}

class _PaymentselectState extends State<Paymentselect> {

  bool isLoading = true;
  List<PaymentMethods>? paymentMethods = [];
  PaymentMethods ?selectedMethod;
  bool isLoadingButton = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPayment();
  }

  _getPayment() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url =  ApiUrl.paymentMethod;
    print(url);
    Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      List<dynamic> methods = responseData['payment_methods'];

      if(methods.length > 0){
        for (Map data in methods) {
          paymentMethods!.add(PaymentMethods.fromJson(data));
        }
      } else {
        showSnackbar('No address available');
      }



    } else {
      print('Contact admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Payment Method',style: TextStyle(color: CustomColor.accentColor),),
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
      ) : Column(
        children: [
          paymentWidget(),
          SizedBox(height: 10,),
          _proceedButton(),

        ],
      ),
    );
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

  paymentWidget() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: paymentMethods!.length,
        itemBuilder: (context, index) {
          PaymentMethods pay = paymentMethods![index];
          return RadioListTile<PaymentMethods>(
            activeColor: CustomColor.primaryColor,
            value: pay,
            groupValue: selectedMethod,
            onChanged: (PaymentMethods ?ind) => setState(() => {
              selectedMethod = ind!,
              print(selectedMethod!.name),
            }),
            title: Text(pay.name.toString()),
          );
        });
  }

  _proceedButton() {
    return isLoadingButton
        ? Center(
      child: CircularProgressIndicator(),
    )
        : ElevatedButton(
      onPressed: () {
        if (selectedMethod == null) {
          showSnackbar('Select payment method');
        } else {
          setState(() {
            isLoadingButton = true;
          });
          _savePaymentMethodAndProceed(); // Updated function
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.accentColor,
        padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      child: Text(
        "Proceed",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

// Function to save payment method and proceed to the next page
  _savePaymentMethodAndProceed() async {
    // Save the selected payment method to SharedPreferences or database
    // For example:
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('paymentMethod', selectedMethod!.methodName);
    prefs.setString('paymentMethod', selectedMethod?.name ?? '');



    // Navigate to the next page (Ordercheckout) with the selected payment method
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ordercheckout(
          productsCart: widget.productsCart,
          selectedAddress: widget.selectedAddress,
          selectedMethod: selectedMethod?.name ?? '',

          totalAmount: widget.totalAmount,
        ),
      ),
    );
  }


// _savePaymentmethod() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String url =  ApiUrl.paymentMethodsave;
  //   Response response = await post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body:{
  //         'payment_method':selectedMethod!.code,
  //         'customer_id':prefs.getString('userId')
  //       }
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isLoadingButton = false;
  //
  //     });
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     print(responseData);
  //     showSnackbar('Payment method saved');
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Ordercheckout(productsCart: widget.productsCart,selectedAddress: widget.selectedAddress,totalAmount: widget.totalAmount,),),);
  //
  //   } else {
  //     print('Contact admin');
  //   }
  // }

}
