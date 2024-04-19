class Productdata {
  List<Productsmodal> ?products;

  Productdata({this.products});

  Productdata.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Productsmodal>.empty();
      json['products'].forEach((v) {
        products!.add(new Productsmodal.fromJson(v));
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
class Productsmodal {
  int? productId;
  String? productName;
  String? categoryName;
  int? categoryId;
  String? subcategoryName;
  int? totalStock;
  int? attributeStock;
  int? optionId;
  String? color;
  String? size;
  int? subcategoryId;
  int? childcategoryId;
  String? brand;
  String? slug;
  String? sortDetails;
  String? photo;
  String? code;
  String? type;
  int? price;
  int? stock;
  String? thumbnail;

  Productsmodal({
    this.productId,
    this.productName,
    this.categoryName,
    this.categoryId,
    this.subcategoryName,
    this.totalStock,
    this.attributeStock,
    this.optionId,
    this.color,
    this.size,
    this.subcategoryId,
    this.childcategoryId,
    this.brand,
    this.slug,
    this.sortDetails,
    this.photo,
    this.code,
    this.type,
    this.price,
    this.stock,
    this.thumbnail,
  });

  Productsmodal.fromJson(Map<dynamic, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    subcategoryName = json['subcategory_name'];
    totalStock = json['total_stock'];
    attributeStock = json['attribute_stock'];
    optionId = json['option_id'];
    color = json['color'];
    size = json['size'];
    subcategoryId = json['subcategory_id'];
    childcategoryId = json['childcategory_id'];
    brand = json['brand'];
    slug = json['slug'];
    sortDetails = json['sort_details'];
    photo = json['photo'];
    code = json['code'];
    type = json['type'];
    price = json['price'];
    stock = json['stock'];
    thumbnail=json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['category_name'] = this.categoryName;
    data['category_id'] = this.categoryId;
    data['subcategory_name'] = this.subcategoryName;
    data['total_stock'] = this.totalStock;
    data['attribute_stock'] = this.attributeStock;
    data['option_id'] = this.optionId;
    data['color'] = this.color;
    data['size'] = this.size;
    data['subcategory_id'] = this.subcategoryId;
    data['childcategory_id'] = this.childcategoryId;
    data['brand'] = this.brand;
    data['slug'] = this.slug;
    data['sort_details'] = this.sortDetails;
    data['photo'] = this.photo;
    data['code'] = this.code;
    data['type'] = this.type;
    data['price'] = this.price;
    data['stock'] = this.stock;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}