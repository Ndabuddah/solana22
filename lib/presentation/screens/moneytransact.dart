import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransactScreen extends StatefulWidget {
  @override
  _TransactScreenState createState() => _TransactScreenState();
}

// Define the enum outside the class
enum TransactionStep { amount, country, withdrawPin, appPin, token }

class _TransactScreenState extends State<TransactScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _withdrawPinController = TextEditingController();
  final TextEditingController _appPinController = TextEditingController();

  String? selectedCountry;
  String transactionToken = '';

  final List<String> countries = ['USA', 'UK', 'Canada', 'Australia'];

  // Variable to keep track of the current step
  TransactionStep _currentStep = TransactionStep.amount;

  // Function to move to the next step
  void _goToNextStep() {
    setState(() {
      if (_currentStep != TransactionStep.token) {
        _currentStep = TransactionStep.values[_currentStep.index + 1];
      }
    });
  }

  // Function to generate the token
  void _generateToken() {
    setState(() {
      transactionToken = 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)}';
    });
    _goToNextStep(); // Move to the token display step
  }

  // Function to copy the token to clipboard
  void _copyTokenToClipboard() {
    Clipboard.setData(ClipboardData(text: transactionToken));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Token copied to clipboard')),
    );
  }

  // Function to share the token
  void _shareToken() {
    // Implement your share functionality here, e.g., using share package
    // Example:
    // Share.share('Transaction Token: $transactionToken');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF282828),
        appBar: AppBar(
          title: const Text('Transact'),
          backgroundColor: Colors.black54,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentStepWidget(),
        ),
      ),
    );
  }

  // Widget to build the content of the current step
  Widget _buildCurrentStepWidget() {
    // Use a switch statement instead of pattern matching
    switch (_currentStep) {
      case TransactionStep.amount:
        return _buildTransactionStepCard(
          child: _buildInputField(
            controller: _amountController,
            label: 'Enter Amount',
            hintText: 'Enter amount to send',
            onNext: _goToNextStep,
          ),
        );
      case TransactionStep.country:
        return _buildTransactionStepCard(
          child: _buildDropdownField(onNext: _goToNextStep),
        );
      case TransactionStep.withdrawPin:
        return _buildTransactionStepCard(
          child: _buildInputField(
            controller: _withdrawPinController,
            label: 'Enter 4-Digit Withdraw Pin',
            hintText: 'XXXX',
            obscureText: true,
            onNext: _goToNextStep,
          ),
        );
      case TransactionStep.appPin:
        return _buildTransactionStepCard(
          child: _buildInputField(
            controller: _appPinController,
            label: 'Enter Your App Pin',
            hintText: 'Enter your 4-digit app pin',
            obscureText: true,
            onNext: _generateToken, // Generate token on confirm
          ),
        );
      case TransactionStep.token:
        return _buildTransactionStepCard(
          child: _buildTokenDisplayCard(),
        );
      default:
        return Container();
    }
  }

  // Widget to build a card for each transaction step
  Widget _buildTransactionStepCard({required Widget child}) {
    return Center(
      child: SizedBox(
        height: 40.h,
        width: 90.w,
        child: Card(
          color: Colors.black26,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: child,
          ),
        ),
      ),
    );
  }

  // Widget to build the token display card
  Widget _buildTokenDisplayCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Transaction Token:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFCBFF30).withOpacity(0.2),
          ),
          child: Text(
            transactionToken,
            style: TextStyle(color: Colors.white, fontSize: 17.sp, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "AEWallet tokens let users manage cryptocurrency, but to withdraw funds, they must find a SpazaCoin vendor who converts tokens to local currency",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _copyTokenToClipboard,
              icon: const Icon(Icons.content_copy),
              color: Colors.white,
              iconSize: 28,
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: _shareToken,
              icon: const Icon(Icons.share),
              color: Colors.white,
              iconSize: 28,
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build the text input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool obscureText = false,
    required VoidCallback onNext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white12,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white60, fontSize: 15.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          keyboardType: obscureText ? TextInputType.number : TextInputType.text,
          textInputAction: TextInputAction.done,
          onEditingComplete: onNext,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCBFF30),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  // Helper method to build the country dropdown
  Widget _buildDropdownField({required VoidCallback onNext}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select Country',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: const Color(0xFF282828),
          value: selectedCountry,
          items: countries
              .map((country) => DropdownMenuItem<String>(
                    value: country,
                    child: Text(
                      country,
                      style: TextStyle(color: Colors.white, fontSize: 15.sp),
                    ),
                  ))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              selectedCountry = newValue;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCBFF30),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
