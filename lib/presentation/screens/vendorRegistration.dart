import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Add dependency in pubspec.yaml

class VendorRegistrationScreen extends StatefulWidget {
  @override
  _VendorRegistrationScreenState createState() => _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } catch (e) {
      // Handle location errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Vendor'),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: const Color(0xFF282828),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vendor Registration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Vendor Name',
                icon: Icons.store,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_pin,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _websiteController,
                label: 'Website',
                icon: Icons.language,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _latitudeController,
                label: 'Latitude',
                icon: Icons.location_on,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _longitudeController,
                label: 'Longitude',
                icon: Icons.location_on,
                enabled: false,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the next screen (Page 2)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorDocumentUploadScreen(
                        vendorName: _nameController.text,
                        vendorDescription: _descriptionController.text,
                        vendorAddress: _addressController.text,
                        vendorPhone: _phoneController.text,
                        vendorEmail: _emailController.text,
                        vendorWebsite: _websiteController.text,
                        vendorLatitude: double.tryParse(_latitudeController.text) ?? 0.0,
                        vendorLongitude: double.tryParse(_longitudeController.text) ?? 0.0,
                      ),
                    ),
                  );
                },
                child: const Text('Next'), // Changed button text to "Next"
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCBFF30), // Custom button color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Increased padding
                  textStyle: TextStyle(fontSize: 18), // Increased font size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.black45,
      ),
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}

class VendorDocumentUploadScreen extends StatefulWidget {
  final String vendorName;
  final String vendorDescription;
  final String vendorAddress;
  final String vendorPhone;
  final String vendorEmail;
  final String vendorWebsite;
  final double vendorLatitude;
  final double vendorLongitude;

  const VendorDocumentUploadScreen({
    Key? key,
    required this.vendorName,
    required this.vendorDescription,
    required this.vendorAddress,
    required this.vendorPhone,
    required this.vendorEmail,
    required this.vendorWebsite,
    required this.vendorLatitude,
    required this.vendorLongitude,
  }) : super(key: key);

  @override
  _VendorDocumentUploadScreenState createState() => _VendorDocumentUploadScreenState();
}

class _VendorDocumentUploadScreenState extends State<VendorDocumentUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: const Color(0xFF282828),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Required Documents',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Add your document upload widgets here
            // Example:
            ElevatedButton(
              onPressed: () {
                // Handle document upload
              },
              child: const Text('Upload Business License'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCBFF30), // Custom button color
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle document upload
              },
              child: const Text('Upload Tax ID'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCBFF30), // Custom button color
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle vendor registration with documents
              },
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCBFF30), // Custom button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
