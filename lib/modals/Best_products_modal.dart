class BestProducts {
  String? photo;
  String? productName;
  int? price;
  int? productId;
  String? type;

  BestProducts({this.photo,this.productName,this.price,this.productId,this.type});

  BestProducts.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    productName = json['product_name'];
    price = json['price'];
    productId = json['product_id'];
    type= json['type'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['productName'] = productName;
    data['price'] = price;
    data['productId'] = productId;
    data['type'] = type;

    return data;
  }
}

//
// class BestProducts {
//   final List<Product> products;
//
//   BestProducts({required this.products});
//
//   factory BestProducts.fromJson(Map<String, dynamic> json) {
//     var list = json['products'] as List;
//     List<Product> productList = list.map((i) => Product.fromJson(i)).toList();
//     return BestProducts(products: productList);
//   }
// }
// //
// class Product {
//   final String productId;
//   final String productName;
//   final String photo;
//   final double price;
//
//   Product({required this.productId, required this.productName, required this.photo, required this.price});
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       productId: json['productId'],
//       productName: json['productName'],
//       photo: json['photo'],
//       price: json['price'],
//     );
//   }
// }
