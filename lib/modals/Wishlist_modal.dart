class Favourites {
  List<Products> ?products;

  Favourites({this.products});

  Favourites.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Products>.empty();
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String ?productId;
  String ?photo;
  String ?product_name;
  String ?price;



  Products(
      {this.productId,
        this.photo,
        this.product_name,
        this.price,
        });

  Products.fromJson(Map<dynamic, dynamic> json) {
    productId = json['product_id'];
    photo= json['photo'];
    product_name = json['product_name'];
    price = json['price'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['photo'] = this.photo;
    data['product_name'] = this.product_name;
    data['price'] = this.price;

    return data;
  }
}
