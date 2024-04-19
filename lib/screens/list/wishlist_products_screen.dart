import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Wishlist_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product_detail_screen.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {

  bool isLoading = true;
  List<Products> products= [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWishlist();
  }

  _getWishlist() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    String url =  ApiUrl.wishlist+ '/$userId';
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
      List<dynamic> fav = responseData['products'];
      if(fav.length > 0){
        for (var item  in fav) {
          Map<String, dynamic> convertedItem = {};
          item.forEach((key, value) {
            // Convert the value to String if it's not already a String
            convertedItem[key.toString()] = value.toString();
          });
          products.add(Products.fromJson(convertedItem));

        }
        print(products);
      } else {
        showSnackbar('No products in wishlist');
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
        title: Text('Wishlist',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : _wishlistWidget(),
    );
  }

  _wishlistWidget(){
    return ListView(
      children: [
        createWishlist(),
      ],
    );
  }

  createWishlist() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        Products wishlist = products[position];
        return createwishListItem(wishlist);
      },
      itemCount: products.length,
    );
  }

  createwishListItem(item) {
    return GestureDetector(
      onTap: () => {
      Navigator.push(context, MaterialPageRoute(
      builder: (context) => Productdetail(productId: item.productId.toString(), ),),)
      },
      child: Stack(
        children: <Widget>[
          Container(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Price : ${item.price.toString()}',
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
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10, top: 8),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.redAccent),
              ),
              onTap: () => {
                _confirmDelete(context, item.productId.toString(),item.product_name.toString(),)
              },
            ),
          )
        ],
      ),
    );
  }

  void _confirmDelete(context,String productId,String product_name) {
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
        _removeFromwishlist(productId);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Confirm', style: TextStyle(fontSize: 18),),
      content: Text('Do you want to remove $product_name from wishlist ?', style: TextStyle(fontSize: 13, color:Colors.black)),
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

  _removeFromwishlist(String productId) async {
    Navigator.pop(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    String url =  ApiUrl.wishlistremove;
    Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body:{
          'product_id':productId,
          'customer_id': userId.toString(),
        }
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if(responseData['success'] == 'Success: You have modified your wishlist!'){
        showSnackbar('Product removed from  whishlist');
        setState(() {
          products = [];
        });
        _getWishlist();
      } else {
        showSnackbar('Product remove failed');
      }
    } else {
      print('Contact admin');
    }
  }

}
