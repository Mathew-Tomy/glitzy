import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Footerwidget extends StatefulWidget {
  const Footerwidget({Key? key}) : super(key: key);

  @override
  _FooterwidgetState createState() => _FooterwidgetState();
}

class _FooterwidgetState extends State<Footerwidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Copyright © 2020 Dsouq. All Rights Reserved',style: TextStyle(color: Colors.white),),
            SizedBox(height: 5,),
            Text('Powered by SUNUNITED INFOLOGICS.',style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
