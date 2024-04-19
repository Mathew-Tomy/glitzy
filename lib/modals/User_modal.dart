class Userinfo {
   String ?success;
   String ?apiToken;
  List<Address> ?address;
  // List<Order> ?order;

  // Userinfo({this.success, this.apiToken, this.address, this.order});
  Userinfo({this.success,this.apiToken,this.address});
  Userinfo.fromJson(Map<String, dynamic> json) {
     success = json['success'];
      apiToken = json['api_token'];
    if (json['address'] != null) {
      address = List<Address>.empty(growable: true);
      json['address'].forEach((v) {
        address!.add(new Address.fromJson(v));
      });
    }
    // if (json['order'] != null) {
    //   order = new List<Order>.empty(growable: true);
    //   json['order'].forEach((v) {
    //     order!.add(new Order.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data['success'] = this.success;
      data['api_token'] = this.apiToken;
    if (this.address != null) {
      data['address'] = this.address!.map((v) => v.toJson()).toList();
    }
    // if (this.order != null) {
    //   data['order'] = this.order!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Address {
  int? id; // Change the type to int
  String ?first_name;
  String ?last_name;
  String ?email;
  String ?ship_country;
  String ?ship_company;
  String ?ship_address1;
  String ?ship_address2;
  String ?ship_zip;
  String ?bill_address1;
  String ?bill_address2;
  String ?bill_zip;
  String ?bill_city;
  String ?bill_country;
  String ?bill_company;

  Address(
      {this.id,
        this.first_name,
        this.last_name,
        this.email,
        this.ship_country,
        this.ship_company,
        this.ship_address1,
        this.ship_address2,
        this.ship_zip,
        this.bill_address1,
        this.bill_address2,
        this.bill_zip,
        this.bill_country,
        this.bill_company});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    ship_country = json['ship_country'];
    ship_company = json['ship_company'];
    ship_address1 = json['ship_address1'];
    ship_address2 = json['ship_address2'];
    ship_zip = json['ship_zip'];
    bill_address1 = json['bill_address1'];
    bill_address2 = json['bill_address2'];
    bill_zip = json['bill_zip'];
    bill_country = json['bill_country'];
    bill_company = json['bill_company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['email'] = this.email;

    data['ship_country'] = this.ship_country;
    data['ship_company'] = this.ship_company;
    data['ship_address1'] = this.ship_address1;
    data['ship_address2'] = this.ship_address2;
    data['ship_zip'] = this.ship_zip;
    data['bill_address1'] = this.bill_address1;
    data['bill_address2'] = this.bill_address2;
    data['bill_zip'] = this.bill_zip;
    data['bill_country'] = this.bill_country;
    data['bill_company'] = this.bill_company;
    return data;
  }
}


// class Order {
//   String ?orderId;
//   String ?firstname;
//   String ?lastname;
//   String ?status;
//   String ?dateAdded;
//   String ?total;
//   String ?currencyCode;
//   String ?currencyValue;

//   Order(
//       {this.orderId,
//         this.firstname,
//         this.lastname,
//         this.status,
//         this.dateAdded,
//         this.total,
//         this.currencyCode,
//         this.currencyValue});

//   Order.fromJson(Map<String, dynamic> json) {
//     orderId = json['order_id'];
//     firstname = json['firstname'];
//     lastname = json['lastname'];
//     status = json['status'];
//     dateAdded = json['date_added'];
//     total = json['total'];
//     currencyCode = json['currency_code'];
//     currencyValue = json['currency_value'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_id'] = this.orderId;
//     data['firstname'] = this.firstname;
//     data['lastname'] = this.lastname;
//     data['status'] = this.status;
//     data['date_added'] = this.dateAdded;
//     data['total'] = this.total;
//     data['currency_code'] = this.currencyCode;
//     data['currency_value'] = this.currencyValue;
//     return data;
//   }
// }

