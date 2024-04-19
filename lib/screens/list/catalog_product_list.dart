import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Catalog_products_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
import 'package:glitzy/widgets/footer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../constants.dart';
import '../product_detail_screen.dart';
import 'dart:ui'; // Import this for Color class
import 'package:glitzy/modals/Category_modal.dart';
class CatalogProductScreen extends StatefulWidget {


  const CatalogProductScreen({Key? key}) : super(key: key);

  @override
  _CatalogProductScreenState createState() => _CatalogProductScreenState();
}

class _CatalogProductScreenState extends State<CatalogProductScreen> {
  bool isLoading = true;
  List<CatalogProduct> catalogProductsList = [];
  List<Categorylistmodal> _categorys = [];
  // Define variables to store the price range


  @override
  void initState() {
    super.initState();
    _getProducts();
    _categoryAPI();

  }

  _getProducts() async {
    String url =  ApiUrl.products;
    print(url);
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
      final List<dynamic> productList = responseData['products'];

      if (productList.length <= 0) {
        _showSnackbar('Product detail not available');
      } else {
        setState(() {
          catalogProductsList.clear();
          for (var productData in productList) {
            catalogProductsList.add(CatalogProduct.fromJson(productData));
          }
        });
      }
    } else {
      print('Contact admin');
    }
  }
  _categoryAPI() async {
    String url =  ApiUrl.categories;
    print(url);
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
      final List<dynamic> productList = responseData['products'];
      print(responseData);
      if (productList.length <= 0) {
        _showSnackbar('Product detail not available');
      } else {
        setState(() {
          _categorys = productList.map((data) => Categorylistmodal.fromJson(data)).toList();
          print(_categorys![0].names);
        });
      }



    } else {
      print('Contact admin');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: Container( // Wrap with Container and provide constraints
            height: MediaQuery.of(context).size.height, // Provide height constraint
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                BackWidget(title: ' Products'),
                SizedBox(height: 10,),
                isLoading ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center (
                    child: CircularProgressIndicator(),
                  ),
                ) :
                // _categoryWidget(),
                productWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _categoryWidget() {
  //   return ListView.separated(
  //     itemCount: _categorys.length,
  //     separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
  //     itemBuilder: (BuildContext context, int index) {
  //       Categorylistmodal cat = _categorys[index];
  //       return ListTile(
  //         title: Row(
  //           children: [
  //             Container(
  //               margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
  //               width: 80,
  //               height: 80,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(14)),
  //                 color: Colors.blue.shade200,
  //                 image: DecorationImage(
  //                   image: NetworkImage(cat.photo.toString()), // Assuming photo contains the image URL
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 10), // Add spacing between image and text
  //             Text(cat.names.toString()),
  //           ],
  //         ),
  //
  //       );
  //     },
  //   );
  // }
  //



  Widget productWidget() {
    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          CatalogProduct product = catalogProductsList![index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Productdetail(
                    productId: product.productId.toString(),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black.withOpacity(0.5)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: AspectRatio(
                      aspectRatio: 1, // Maintain a 1:1 aspect ratio
                      child: Center(


                        child: product.photo != null
                            ? Image.network(
                          product.photo!,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.productName.toString()}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$${product.price ?? 0}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: catalogProductsList!.length,
      ),
    );
  }



}