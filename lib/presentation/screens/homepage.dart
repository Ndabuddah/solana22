import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this import for SVG images
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:solana22/presentation/screens/findVendorScreen.dart';
import 'package:solana22/presentation/screens/moneytransact.dart';
import 'package:solana22/presentation/screens/profile.dart';
import 'package:solana22/presentation/screens/vendorRegistration.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateToScreen(BuildContext context, String screenName) {
    Widget screen;
    switch (screenName) {
      case 'Explore':
        screen = ExploreScreen();
        break;
      case 'Transact':
        screen = TransactScreen();
        break;
      case 'Vendor':
        screen = FindVendorScreen();
        break;
      case 'Profile':
        screen = ProfileScreen();
        break;
      case 'Vendor Reg':
        screen = VendorRegistrationScreen();
        break;
      default:
        screen = PlaceholderScreen(screenName: screenName);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF282828),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 20.h, // Adjust the height as needed
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Colors.black54, Colors.black45],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 12, bottom: 8, top: 8), // Adjust bottom padding to fit new height
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Explore",
                                    style: TextStyle(
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFCBFF30),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _navigateToScreen(context, 'Explore'),
                                    child: Container(
                                      height: 3.8.h,
                                      width: 3.8.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF282828),
                                      ),
                                      child: const Icon(
                                        Icons.explore,
                                        color: Color(0xFFCBFF30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h), // Add space between the bottom padding and the SVG
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Transform.scale(
                          scale: 1.5, // Adjust this scale factor to increase the SVG size
                          child: SvgPicture.asset(
                            'assets/explore.svg', // Update with your SVG file path
                            height: 8.h, // Original height
                            width: 8.h, // Original width
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCard(
                      context,
                      icon: FontAwesomeIcons.moneyBillTransfer,
                      title: "Transact",
                      svgPath: 'assets/cash.svg', // Use the SVG path here
                      gradient: const LinearGradient(
                        colors: [Colors.black54, Colors.black45],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToScreen(context, 'Transact'),
                    ),
                    _buildCard(
                      context,
                      title: "Vendor",
                      icon: FontAwesomeIcons.locationPin,
                      svgPath: 'assets/vendor.svg', // Use the SVG path here
                      gradient: LinearGradient(
                        colors: [Colors.grey[700]!, Colors.grey[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToScreen(context, 'Vendor'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCard(
                      context,
                      icon: FontAwesomeIcons.moneyBillTransfer,
                      title: "Profile",
                      svgPath: 'assets/explore.svg', // Use the SVG path here
                      gradient: LinearGradient(
                        colors: [Colors.grey[700]!, Colors.grey[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToScreen(context, 'Profile'),
                    ),
                    _buildCard(
                      context,
                      icon: FontAwesomeIcons.moneyBillTransfer,
                      title: "Spaza\nReg",
                      svgPath: 'assets/register.svg', // Use the SVG path here
                      gradient: const LinearGradient(
                        colors: [Colors.black54, Colors.black45],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _navigateToScreen(context, 'Vendor Reg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String svgPath, // Change icon to svgPath
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 21.h,
        width: 19.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 3.5.h,
                    width: 3.5.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF282828),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFFCBFF30),
                      size: 2.h,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SvgPicture.asset(
                svgPath, // Use the SVG image
                height: 12.h, // Adjust the size to your preference
                width: 12.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: const Center(
        child: Text('This is the Explore screen'),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String screenName;

  const PlaceholderScreen({Key? key, required this.screenName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
      ),
      body: Center(
        child: Text('This is the $screenName screen'),
      ),
    );
  }
}
