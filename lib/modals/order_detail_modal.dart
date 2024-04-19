class OrderDetail {
  Order? order;
  List<Products>? products;

  OrderDetail({this.order, this.products});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Order {
  int? orderId; // Change the type to int
  String? transactionNumber;
  String? paymentStatus;
  String? createdAt;
  String? status;
  int? customerId; // Change the type to int
  String? firstName;
  String? lastName;
  String? email;
  String? telephone;
  String? paymentCompany;
  String? paymentAddress1;
  String? paymentAddress2;
  String? paymentPostcode;
  String? paymentCity;
  String? paymentCountry;
  String? paymentMethod;

  Order(
      {this.orderId,
        this.transactionNumber,
        this.paymentStatus,
        this.status,
        this.createdAt,
        this.customerId,
        this.firstName,
        this.lastName,
        this.email,
        this.telephone,
        this.paymentCompany,
        this.paymentAddress1,
        this.paymentAddress2,
        this.paymentPostcode,
        this.paymentCity,
        this.paymentCountry,
        this.paymentMethod});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    transactionNumber = json['transaction_number'];
    paymentStatus = json['paymentStatus'];
    status = json['status'];
    createdAt = json['created_at'];
    customerId = json['customerId'];
    firstName = json['firstname'];
    lastName = json['lastname'];
    email = json['email'];
    telephone = json['telephone'];
    paymentCompany = json['paymentCompany'];
    paymentAddress1 = json['paymentAddress1'];
    paymentAddress2 = json['paymentAddress2'];
    paymentPostcode = json['paymentPostcode'];
    paymentCity = json['paymentCity'];
    paymentCountry = json['paymentCountry'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderId'] = orderId;
    data['transaction_number'] = transactionNumber;
    data['paymentStatus'] = paymentStatus;
    data['status'] = status;
    data['customerId'] = customerId;
    data['firstname'] = firstName;
    data['lastname'] = lastName;
    data['email'] = email;
    data['telephone'] = telephone;
    data['paymentCompany'] = paymentCompany;
    data['paymentAddress1'] = paymentAddress1;
    data['paymentAddress2'] = paymentAddress2;
    data['paymentPostcode'] = paymentPostcode;
    data['paymentCity'] = paymentCity;
    data['paymentCountry'] = paymentCountry;
    data['paymentMethod'] = paymentMethod;
    return data;
  }
}

class Products {
  int? productId; // Change data type to int
  String? productName;
  int? orderProductId; // Change data type to int
  int? optionId; // Change data type to int
  int? qty; // Change data type to int
  int? price; // Change data type to int
  int? totalPrice; // Change data type to int
  String? size;
  String? color;

  Products({
    this.productId,
    this.productName,
    this.orderProductId,
    this.optionId,
    this.qty,
    this.price,
    this.totalPrice,
    this.size,
    this.color,
  });

  // Add factory constructor for JSON parsing
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['product_id'], // Parse as int
      productName: json['product_name'],
      orderProductId: json['order_product_id'], // Parse as int
      optionId: json['option_id'], // Parse as int
      qty: json['qty'], // Parse as int
      price: json['price'], // Parse as int
      totalPrice: json['total_price'], // Parse as int
      size: json['size'],
      color: json['color'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['product_name'] = productName;
    data['product_id'] = productId;
    data['order_product_id'] = orderProductId;
    data['option_id'] = optionId;
    data['qty'] = qty;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['size'] = size;
    data['color'] = color;
    return data;
  }
}




