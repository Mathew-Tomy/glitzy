class Orderslist {
  List<Orders> ?orders;

  Orderslist({this.orders});

  Orderslist.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = new List<Orders>.empty();
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
   //int? orderId; // Change the type to int
   String ?orderId;
  String ?transaction_number;
  String ?status;
  String ?created_at;
  String ?total_price;
  String ?total;
  String ?paymentStatus;

  Orders(
      {this.orderId,
        this.transaction_number,
        this.status,
        this.created_at,
        this.total_price,
        this.total,
        this.paymentStatus});

  Orders.fromJson(Map<dynamic, dynamic> json) {
    orderId = json['orderId'];
    transaction_number= json['transaction_number'];
    status= json['status'];
    created_at= json['created_at'];
    total_price= json['total_price'];
    total = json['total'];
    paymentStatus= json['paymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['transaction_number'] = this.transaction_number;
    data['status'] = this.status;
    data['date_added'] = this.created_at;
    data['paymentStatus'] = this.paymentStatus;
    data['total'] = this.total;
    data['total_price'] = this.total_price;

    return data;
  }
}
