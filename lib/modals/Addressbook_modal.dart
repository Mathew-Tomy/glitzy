class Addresslist {
  List<AddressData> ?addressData;

  Addresslist({this.addressData});

  Addresslist.fromJson(Map<String, dynamic> json) {
    if (json['address_data'] != null) {
      addressData = new List<AddressData>.empty();
      json['address_data'].forEach((v) {
        addressData!.add(new AddressData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressData != null) {
      data['address_data'] = this.addressData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressData {

  String ?firstname;
  String ?lastname;
  String ?phone;
  String ?email;
  String ?ship_address1;
  String ?ship_address2;
  String ?ship_zip;
  String ?ship_city;
  String ?ship_country;
  String ? ship_company;
  String ?bill_address1;
  String ?bill_address2;
  String ?bill_zip;
  String ?bill_city;
  String ?bill_country;
  String ?bill_company;



  AddressData(
      {
        this.firstname,
        this.lastname,
        this.phone,
        this.email,
        this.ship_company,
        this.ship_address1,
        this.ship_address2,
        this.ship_zip,
        this.ship_city,
        this.ship_country,
        this.bill_company,
        this.bill_address1,
        this.bill_address2,
        this.bill_zip,
        this.bill_city,
        this.bill_country,
        });

  AddressData.fromJson(Map<dynamic, dynamic> json) {

    firstname = json['first_name'];
    lastname = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    ship_company = json['ship_company'];
    ship_address1 = json['ship_address1'];
    ship_address2 = json['ship_address2'];
    ship_zip = json['ship_zip'];
    ship_city = json['ship_city'];
    ship_country = json['ship_country'];
    bill_company = json['bill_company'];
    bill_address1 = json['bill_address1'];
    bill_address2 = json['bill_address2'];
    bill_zip = json['bill_zip'];
    bill_city = json['bill_city'];
    bill_country = json['bill_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['ship_company'] = this.ship_company;
    data['ship_address_1'] = this.ship_address1;
    data['ship_address_2'] = this.ship_address2;
    data['ship_zip'] = this.ship_zip;
    data['ship_city'] = this.ship_city;
    data['ship_country'] = this.ship_country;
    data['bill_company'] = this.ship_company;
    data['bill_address_1'] = this.bill_address1;
    data['bill_address_2'] = this.bill_address2;
    data['bill_zip'] = this.bill_zip;
    data['bill_city'] = this.bill_city;
    data['bill_country'] = this.bill_country;
    data['bill_company'] = this.bill_company;

    return data;
  }
}
