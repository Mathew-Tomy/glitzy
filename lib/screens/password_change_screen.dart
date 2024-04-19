import 'dart:convert';

import 'package:glitzy/colors/Colors.dart';
import 'package:glitzy/restAPI/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Passwordchange extends StatefulWidget {
  const Passwordchange({Key? key}) : super(key: key);

  @override
  _PasswordchangeState createState() => _PasswordchangeState();
}

class _PasswordchangeState extends State<Passwordchange> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading  =  false;
  String ?password;
  String ?confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Change Password',style: TextStyle(color: CustomColor.accentColor),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color:CustomColor.accentColor),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          _passwordForm(),
          SizedBox(height: 25,),
          continueWidget(context),
        ],
      )
    );
  }

  _passwordForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Padding(
            padding:  EdgeInsets.only(left:10.0,right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Enter your new password',
                suffixIcon: Icon(Icons.lock_outline,color: Colors.grey,),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onSaved: (value) {
                password = value;
              },
              validator: (String? value){
                if(value!.isEmpty){
                  return 'Enter your new password';
                }else{
                  return null;
                }
              },
            ),
          ),
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Confirm Password",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: 'Confirm your new password',
                suffixIcon: Icon(Icons.lock_outline,color: Colors.grey,),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onSaved: (value) {
                confirmPassword = value;
              },
              validator: (String? value){
                if(value!.isEmpty){
                  return 'Enter password';
                }else{
                  return null;
                }
              },
            ),
          ),

        ],
      ),
    );
  }

  void _submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });
    }
    formKey.currentState!.save();
    _savePassword();

  }

  continueWidget(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 12.0,right: 12),
      child: isLoading ? Center (
        child: CircularProgressIndicator(),
      ) :  GestureDetector(
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: CustomColor.primaryColor,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,

              ),
            ),
          ),
        ),
        onTap: () => {
          _submit()
        },
      ),
    );
  }

  _savePassword() async {
    String url =  ApiUrl.accountUpdate;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0; // Get user ID as an integer
    Response response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body:{
          'user_id': userId.toString(),
          'confirm':confirmPassword,
          'password':password
        }
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      showSnackbar('Your password has been updated');
    } else {
      print('Contact admin');
    }

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
}
