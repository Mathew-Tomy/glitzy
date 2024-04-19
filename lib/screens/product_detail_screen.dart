import 'dart:convert';
import '../../../constants.dart';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Productdetail_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:glitzy/screens/list/category_product_list.dart';
import 'package:glitzy/screens/list/subcategory_product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_svg/flutter_svg.dart';
import 'list/cart_list_screen.dart';

class Productdetail extends StatefulWidget {


  const Productdetail({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  _ProductdetailState createState() => _ProductdetailState();
}

class _ProductdetailState extends State<Productdetail> {

  bool isLoading = true;
  List<Productsmodal> ?products = [];

  int? optionId; // Declare optionId as an int
  int quantity = 1;
  bool wishlisted = false;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.productId);
    _getProduct();
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

  _getProduct() async{
    String url =  ApiUrl.productdetail + '/${widget.productId}';
    print(url);
    Response response = await get( // Change post to get here
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> productList = responseData['products'];
      if(productList.length <= 0){
        showSnackbar('Product detail not available');
      } else {
        setState(() {
          for (Map data in productList) {
            products!.add(Productsmodal.fromJson(data));
          }
          print(products![0].productName);

        });
      }


    } else {
      print('Contact admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product detail',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
        actions: <Widget>[
          IconButton(
            icon: wishlisted ?Icon(
              Icons.favorite ,
              color: Colors.red,
            ) :  Icon(
              Icons.favorite_border_outlined ,
              color: Colors.black,
            ),
            onPressed: () {
              _addWishlist();
              setState(() {
                wishlisted = !wishlisted;
              });
            },
          ),
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
      ) : _productWidget(),
    );
  }

  Widget _productWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: 250,
                  height: 250,
                  child: Image.network(
                    products![0].photo.toString(),
                    height: MediaQuery.of(context).size.height / 1.8,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        products![0].productName.toString(),
                        style: TextStyle(
                          color: CustomColor.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: products![0].brand != null
                          ? Text(products![0].brand.toString())
                          : Text(products![0].brand ?? ''),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                products![0].stock.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Categories:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        products![0].categoryName.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryProduct(
                              categoryId: products![0].categoryId.toString(),
                              categoryName: products![0].categoryName.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Sub Categories:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        products![0].subcategoryName.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubCategoryProduct(
                              subcategoryId: products![0].subcategoryId.toString(),
                              subcategoryName: products![0].subcategoryName.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(
                        'CODE:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        products![0].code.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: kDefaultPaddin / 2),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                products![0].type.toString() == 'false'
                    ? Text('')
                    : Text(
                  products![0].price.toString(),
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                products![0].type.toString() != 'false'
                    ? Text(
                  ' ${products![0].price.toString()} / \$${products![0].price.toString()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )
                    : Text(
                  '\$${products![0].price.toString()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  products![0].sortDetails.toString(),
                  style: TextStyle(fontSize: 15),
                ),

              ],
            ),
          ),
          SizedBox(height: kDefaultPaddin),
          SizedBox(height: kDefaultPaddin),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: products == null || products!.isEmpty
                ? Text('Loading...') // Handle cases where products haven't loaded yet
                : (products!.first.optionId != null && products!.first.optionId != 0)
                ? DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<String>(
                  iconSize: 30,
                  icon: null,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Select Size', style: TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a size';
                    }
                    return null;
                  },
                  value: optionId != null && optionId != 0 ? optionId.toString() : null,
                  onChanged: (newValue) {
                    setState(() {
                      optionId = newValue != null ? int.tryParse(newValue) : null;
                    });
                  },
                  items: (products![0].size ?? '').split(', ').where((size) => size.isNotEmpty).map((size) {
                    return DropdownMenuItem<String>(
                      value: products![0].optionId.toString(), // Store size directly
                      child: Text(size),
                    );
                  }).toList(),
                ),
              ),
            )
                : Text(''), // Display nothing if optionId is null or 0

          ),

          SizedBox(height: kDefaultPaddin),
          // Description
          SizedBox(height: kDefaultPaddin),
          SizedBox(height: 15),
          _addingWidget(),

        ],
      ),
    );
  }


  Widget _addingWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: CustomColor.secondaryColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.remove,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Minimum quantity is 1',
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    });
                  },
                ),
                SizedBox(width: 10 * 2),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    color: CustomColor.accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10 * 2),
                GestureDetector(
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: CustomColor.secondaryColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(width: 30), // Add some space between the two sections
          Expanded(
            flex: 1,
            child:GestureDetector(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,

                    ),
                  ),
                ),
              ),
              onTap: () => {
                _addCart(),

              },
            ),
          ),
        ],
      ),
    );
  }

  _addCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer

    String url = ApiUrl.addtocart;
    Response response = await post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        'product_id': widget.productId,
        'quantity': quantity.toString(),
        'option': optionId != null && optionId != 0 ? optionId.toString() : '',
        'customer_id': userId.toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      if (responseData.containsKey('success')) {
        // Display success message
        showSnackbar(responseData['success']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Cart()),
        );
      } else if (responseData.containsKey('error')) {
        // Display error message
        showSnackbar(responseData['error']);
      } else {
        // Unexpected response format
        print('Unexpected response from server');
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
    }
  }

  //wishlist
  _addWishlist() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    print(userId);
    String url =  ApiUrl.wishlistadd;
    Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body:{
          'product_id':widget.productId,
          'customer_id': userId.toString(), // Convert user ID to string
        }
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      showSnackbar('Product added to wishlist');

    } else {
      showSnackbar('Product not  added to wishlist');
      setState(() {
        wishlisted = !wishlisted;
      });
      print('Contact admin');
    }
  }




}

