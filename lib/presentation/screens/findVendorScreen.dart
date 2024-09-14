import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';

class Vendor {
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String imageUrl; // Optional

  Vendor({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl = "", // Default empty image URL
  });
}

class FindVendorScreen extends StatefulWidget {
  @override
  _FindVendorScreenState createState() => _FindVendorScreenState();
}

class _FindVendorScreenState extends State<FindVendorScreen> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  List<Vendor> allVendors = [];
  List<Vendor> filteredVendors = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMockVendors();
  }

  void _loadMockVendors() {
    setState(() {
      allVendors = [
        Vendor(name: "Vendor A", description: "Grocery Store", latitude: 37.78825, longitude: -122.4324),
        Vendor(name: "Vendor B", description: "Electronics", latitude: 37.785833, longitude: -122.406417),
        // ... more vendors
      ];
      filteredVendors = allVendors;
    });
  }

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _filterVendors(String query) {
    setState(() {
      filteredVendors = allVendors.where((vendor) => vendor.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _onVendorSelected(Vendor vendor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorDetailsScreen(vendor: vendor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282828), // Matching the background color of HomePage
      appBar: AppBar(
        title: const Text('Find Vendors'),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterVendors,
              decoration: InputDecoration(
                hintText: 'Search vendors...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                suffixIcon: IconButton(
                  icon: Icon(Icons.my_location, color: Colors.grey[500]),
                  onPressed: () {
                    // Get current location and update search
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black45,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredVendors.length,
                    itemBuilder: (context, index) {
                      final vendor = filteredVendors[index];
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          color: Colors.black54,
                          child: ListTile(
                            onTap: () => _onVendorSelected(vendor),
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              vendor.name,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              vendor.description,
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              '${_calculateDistance(0, 0, vendor.latitude, vendor.longitude).toStringAsFixed(1)} km',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class VendorDetailsScreen extends StatelessWidget {
  final Vendor vendor;

  VendorDetailsScreen({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vendor.name),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: const Color(0xFF282828), // Matching the background color of HomePage
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display vendor details here
            Text(vendor.name, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(vendor.description, style: TextStyle(color: Colors.white70, fontSize: 16)),
            // ... other details
          ],
        ),
      ),
    );
  }
}
