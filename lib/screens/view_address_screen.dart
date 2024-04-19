import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/modals/Addressbook_modal.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

class Viewaddress extends StatefulWidget {


  const Viewaddress({Key? key, required this.address}) : super(key: key);
  final AddressData address;

  @override
  _ViewaddressState createState() => _ViewaddressState();
}

class _ViewaddressState extends State<Viewaddress> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.address.firstname);
  }

  String ?firstname;
  String ?lastname;
  String ?phone;
  String ?ship_company;
  String ?ship_address1;
  String ?ship_address2;
  String ?ship_city;
  String ?ship_country;
  String ?ship_zip;
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });
    }
    _formKey.currentState!.save();
    _saveAddress();
  }

  Future<void> _showMyDialog(msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        Dashboard()), (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Edit Address book',
          style: TextStyle(color: CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: CustomColor.accentColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.address.firstname,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter first name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          firstname = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.lastname,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter last name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          lastname = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.phone,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "phone",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Phone';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phone = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.ship_company,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Company",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter company name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ship_company = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.ship_address1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Address 1",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter address 1';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ship_address1 = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.ship_address2,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Address 2",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter address 2';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ship_address2 = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.ship_city,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "City",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter city';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ship_city = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.ship_zip,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Post Code",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter postcode';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ship_zip = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        initialValue: widget.address.ship_country,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Country",
                          border:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          enabledBorder:
                          OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.black54)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3d63ff)),
                          ),
                        ),

                        textCapitalization:
                        TextCapitalization.sentences,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter country';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ship_country = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            isLoading ? Center(
              child: CircularProgressIndicator(

              ),
            ) : MaterialButton(
              onPressed: () {
                _submit();
              },
              color: CustomColor.accentColor,
              padding: EdgeInsets.only(
                  top: 12, left: 60, right: 60, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
              child: Text(
                "Update Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSnackbar(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.all(10),
      backgroundColor: CustomColor.primaryColor,
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      duration: Duration(seconds: 4),
    ));
  }

  _saveAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    String url = ApiUrl.addressedit;
    print(url);
    try {
      Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'first_name': firstname.toString(),
          'last_name': lastname.toString(),
          'phone': phone.toString(),
          'ship_address1': ship_address1.toString(),
          'ship_address2': ship_address2.toString(),
          'ship_city': ship_city.toString(),
          'ship_zip': ship_zip.toString(),
          'ship_country': ship_country.toString(),
          'ship_company': ship_company.toString(),
          // 'bill_address1': bill_address1.toString(),
          // 'bill_address2': bill_address2.toString(),
          // 'bill_city': bill_city.toString(),
          // 'bill_zip': bill_zip.toString(),
          // 'bill_country': bill_country.toString(),
          // 'bill_company': bill_company.toString(),
          'user_id': userId.toString(), // Convert userId to string
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
        _showMyDialog('Address has been edited');
      } else {
        print('Contact admin');
      }
    } catch (e) {
      print('Error: $e');
      // Handle exceptions here, e.g., display an error message to the user
    }
  }

}