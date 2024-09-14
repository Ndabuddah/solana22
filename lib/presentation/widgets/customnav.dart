import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_filled,
                size: 3.2.h,
                color: currentIndex == 0 ? Color(0xFFCBFF30) : Color(0xFFCBFF30),
              ),
              onPressed: () {
                onItemTapped(0); // Switch to Home Page
              },
            ),
            IconButton(
              icon: Icon(
                Icons.history,
                size: 3.2.h,
                color: currentIndex == 1 ? Color(0xFFCBFF30) : Color(0xFFCBFF30),
              ),
              onPressed: () {
                onItemTapped(1); // Switch to Transaction History Page
              },
            ),
          ],
        ),
      ),
    );
  }
}
