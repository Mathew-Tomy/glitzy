import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glitzy/config/theme.dart';

import 'package:glitzy/constants.dart';
const Color inActiveIconColor = Color(0xFFB6B6B6);
class Footerwidget extends StatefulWidget {

  const Footerwidget({Key? key}) : super(key: key);

  @override
  _FooterwidgetState createState() => _FooterwidgetState();
}

class _FooterwidgetState extends State<Footerwidget> {
  final List<String> routeNames = ['/dashboard', '/cart', '/wishlist', '/order']; // Define your route names
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }



  @override

  Widget build(BuildContext context) {
    return Container(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconButton(Icons.home, 'Home', () => Navigator.pushNamed(context, '/dashboard')),
            _buildIconButton(Icons.shopping_cart, 'Cart', () => Navigator.pushNamed(context, '/cart')),
            _buildIconButton(Icons.favorite, 'Wishlist', () => Navigator.pushNamed(context, '/wishlist')),
            _buildIconButton(Icons.assignment, 'Orders', () => Navigator.pushNamed(context, '/order')),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData iconData, String label, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            iconData,
            color: Colors.orange,
            size: 30,
          ),
          SizedBox(height: 5),
          // Text(
          //   label,
          //   style: TextStyle(color: Colors.orange),
          // ),
        ],
      ),
    );
  }
}

