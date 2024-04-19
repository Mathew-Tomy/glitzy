class Searchproducts {
  int? product_id;
  String? product_name;
  String? photo;
  String? code;
  dynamic price;// Changed to int to represent a numeric value

  Searchproducts({
    this.product_id,
    this.product_name,
    this.photo,
    this.code,
    this.price,
  });

  Searchproducts.fromJson(Map<dynamic, dynamic> json) {
    product_id = json['product_id'];
    product_name = json['product_name'];
    photo = json['photo'];
    code = json['code']; // Removed space before 'code'
    price = json['price']; // Assuming 'price' is numeric
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.product_id;
    data['product_name'] = this.product_name;
    data['photo'] = this.photo;
    data['code'] = this.code;
    data['price'] = this.price;
    return data;
  }
}
