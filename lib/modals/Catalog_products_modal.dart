class CatalogProduct {
  String? photo;
  String? productName;
  int? price;
  int? productId;
  String? type;


  // Fetching product details



  CatalogProduct({this.photo, this.productName, this.price, this.productId, this.type});

  CatalogProduct.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    productName = json['product_name']; // Updated property name
    price = json['price'];
    productId = json['product_id'];
    type = json['type'];

  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['product_name'] = productName; // Updated key name
    data['price'] = price;
    data['product_id'] = productId;
    data['type'] = type;

    return data;
  }
// Method to truncate the product name


}

