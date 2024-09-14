import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:solana22/presentation/screens/homepage.dart';
import 'package:solana22/presentation/screens/trascationscreen.dart';
import 'package:solana22/presentation/widgets/customnav.dart';

import '../widgets/Drawer.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  // Define the different pages for navigation
  final List<Widget> _pages = [
    const HomePage(),
    const TransactionHistoryScreen(),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF282828),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        color: Color(0xFFCBFF30),
                        size: 3.h,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.notifications_none,
                    size: 3.h,
                    color: Color(0xFFCBFF30),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Conditionally display the selected page here
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Colors.black, Colors.black45],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              //shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(FontAwesomeIcons.whatsapp, size: 4.5.h, color: Colors.white),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CustomNavBar(
            currentIndex: _selectedIndex,
            onItemTapped: _onNavBarTapped,
          ),
        ),
      ),
    );
  }
}
