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
import 'package:glitzy/widgets/footer_widget.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'list/cart_list_screen.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:glitzy/screens/top_rounded_container.dart';
class Productmoredetail extends StatefulWidget {


  const Productmoredetail({Key? key, required this.productId}) : super(key: key);
  final String productId;

  @override
  _ProductdetailState createState() => _ProductdetailState();
}

class _ProductdetailState extends State<Productmoredetail> {

  bool isLoading = true;
  List<Productsmodal> ?products = [];





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
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        title: Text(
          'More detail',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        children: [
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                Image.network(
                  products![0].photo.toString(),
                  fit: BoxFit.cover,
                  height: 135,
                  width: 255,
                ),
                ListTile(
                  title: Text(
                    products![0].productName.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Price: \$${products![0].price.toString()}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                //   subtitle: Text(
                //   products![0].brand != null
                //       ? Text(products![0].brand.toString())
                //       : Text(products![0].brand ?? ''),
                // ),
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
                    'Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Html(
                    data: products![0].details.toString(),
                    style: {
                      // Define the style for the HTML content
                      'body': Style(fontSize: FontSize(15.0)), // Adjust the font size as needed
                    },

                  ),
                ),

              ],
            ),
          ),
        ],
      ),


      persistentFooterButtons: [

        Footerwidget(),
      ],
    );
  }






}

