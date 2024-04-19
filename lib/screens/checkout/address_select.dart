import 'dart:convert';
import 'package:glitzy/modals/Addressbook_modal.dart';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Addressbook_modal.dart';
import 'package:glitzy/modals/Cart_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/screens/checkout/payment_method_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_address_screen.dart';
import '../add_address_screen.dart';
// import 'order_checkout.dart';

class CheckoutAddress extends StatefulWidget {

  const CheckoutAddress({Key? key, this.productsCart, required this.totalAmount}) : super(key: key);
  final  List<Products> ?productsCart;
  final String totalAmount;


  @override
  _CheckoutAddressState createState() => _CheckoutAddressState();
}

class _CheckoutAddressState extends State<CheckoutAddress> {

  bool isLoading = true;
  List<AddressData> addressData = [];
  AddressData ?selectedAddress;
  bool isLoadingButton = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddress();
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
        title: Text('Delivery Address',style: TextStyle(color: CustomColor.accentColor),),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColor.accentColor,

        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Addaddress(),
          ),
          );
        },
        icon: Icon(Icons.add),
        label: Text("New Address"),

      ),


      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Column(
        children: [
          addressbookWidget(),
          SizedBox(height: 10,),
          _proceedButton(),


        ],
      ),
    );
  }

  addressbookWidget() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: addressData.length,
        itemBuilder: (context, index) {
          AddressData address = addressData[index];
          return Column(
            children: [
              RadioListTile<AddressData>(
                activeColor: CustomColor.primaryColor,
                value: address,
                groupValue: selectedAddress,
                onChanged: (AddressData? ind) {
                  setState(() {
                    selectedAddress = ind!;
                    print(selectedAddress!.ship_address1);
                  });
                },
                title: Text(address.firstname.toString() + ' ' + address.lastname.toString()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.email.toString() + ',' +
                      address.ship_address1.toString() + ',' +
                          address.ship_address2.toString() + ',' +
                          address.ship_city.toString(), // Assuming this is a method call
                    ),
                    Text(
                      address.ship_country.toString() + ',' +
                          address.ship_zip.toString() + ',' +
                          address.ship_company.toString() + ',' +
                          address.phone.toString(), // Assuming this is a property
                    ),
                    addressAction(address)
                  ],
                ),
              ),

            ],
          );

        });


  }
  Widget addressAction(AddressData address) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Viewaddress(address: address),
          ),
        );
      },
      child: Text(
        "Update Address / Change Address",
        style: TextStyle(fontSize: 12, color: Colors.indigo.shade700),
      ),
    );
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    String url =  ApiUrl.addresslist + '/$userId';
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
      List<dynamic> address = responseData['address_data'];

      if(address.length > 0){
        for (Map data in address) {
          addressData.add(AddressData.fromJson(data));
        }
      } else {
        showSnackbar('No address available');
      }



    } else {
      print('Contact admin');
    }
  }


  _proceedButton() {
    return isLoadingButton
        ? Center(
      child: CircularProgressIndicator(),
    )
        : ElevatedButton(
      onPressed: () {
        if (selectedAddress == null) {
          showSnackbar('Select delivery address');
        } else if (selectedAddress!.ship_address1 == null ||
            selectedAddress!.ship_address2 == null ||
            selectedAddress!.ship_zip == null ||
            selectedAddress!.ship_country == null ||
            selectedAddress!.ship_city == null) {
          showSnackbar('Please update your address');
        } else {
          // Navigate to Paymentselect page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Paymentselect(
                productsCart: widget.productsCart,
                selectedAddress: selectedAddress,
                totalAmount: widget.totalAmount,
              ),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColor.accentColor,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        "Proceed",
        style: TextStyle(color: Colors.white),
      ),
    );
  }




  }


