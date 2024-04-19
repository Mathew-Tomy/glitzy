import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/best_products_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:glitzy/widgets/back_button_widget.dart';
// import 'package:glitzy/widgets/footer_widget.dart';
import 'package:glitzy/modals/Productdetail_modal.dart';
import '../product_detail_screen.dart';
import '../../../constants.dart';
import 'dart:ui'; // Import this for Color class

class TypeProductsScreen extends StatefulWidget {
  const TypeProductsScreen({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  _TypeProductsScreenState createState() => _TypeProductsScreenState();
}

class _TypeProductsScreenState extends State<TypeProductsScreen> {
  bool isLoading = true;
  List<Productsmodal>? products = [];

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _getProducts() async {
    String url = 'https://glitzystudio.ca/api/products/type/${widget.type}';
    Response response = await get(
      Uri.parse(url),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> productList = responseData['products'];

      if (productList.length <= 0) {
        showSnackbar('Product detail not available');
      } else {
        setState(() {
          products = productList.map((data) => Productsmodal.fromJson(data)).toList();
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.white,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            BackWidget(title: '${widget.type} products'),
            SizedBox(height: 10),
            _productsList(),
            // Footerwidget(),
          ],
        ),
      ),
    );
  }

  Widget _productsList() {
    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
      ),
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Productsmodal product = products![index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Productdetail(productId: product.productId.toString()),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 5),
                        product.photo != null
                            ? Image.network(
                          product.photo.toString(),
                          width: 140,
                          height: 100,
                        )
                            : Image.asset(
                          'assets/images/noimage.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(height: 12 * 0.5),
                        Text(
                          product.productName.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CustomColor.accentColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10 * 0.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${product.price.toString()} ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: products!.length,
      ),
    );
  }





}
