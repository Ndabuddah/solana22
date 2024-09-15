import 'dart:math';

import 'package:currency_converter/currency.dart' as currencyConverter; // Import the package's Currency enum
import 'package:currency_converter/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TransactScreen extends StatefulWidget {
  @override
  _TransactScreenState createState() => _TransactScreenState();
}

enum TransactionStep { amount, country, withdrawPin, appPin, token }

enum Currency {
  USD,
  GBP,
  CAD,
  AUD,
}

class _TransactScreenState extends State<TransactScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _withdrawPinController = TextEditingController();
  final TextEditingController _appPinController = TextEditingController();

  String? selectedCountry;
  double convertedAmount = 0.0;
  String transactionToken = '';
  String transactionPin = '';

  final List<String> countries = ['USA', 'UK', 'Canada', 'Australia'];
  String fromCurrency = 'USD'; // Replace with user's currency
  String toCurrency = 'USD'; // This will be based on selected country

  TransactionStep _currentStep = TransactionStep.amount;

  void _goToNextStep() {
    setState(() {
      if (_currentStep != TransactionStep.token) {
        _currentStep = TransactionStep.values[_currentStep.index + 1];
      }
    });
  }

  Future<void> _convertAmount() async {
    toCurrency = _getCountryCurrency(selectedCountry ?? '');
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    convertedAmount = await _convertCurrency(fromCurrency, toCurrency, amount);
    _goToNextStep();
  }

  Future<double> _convertCurrency(String from, String to, double amount) async {
    try {
      // Map your custom Currency enum to the package's Currency enum
      currencyConverter.Currency fromCurrencyEnum = _mapCurrencyEnum(from);
      currencyConverter.Currency toCurrencyEnum = _mapCurrencyEnum(to);

      var conversionResult = await CurrencyConverter.convert(
        from: fromCurrencyEnum,
        to: toCurrencyEnum,
        amount: amount,
        withoutRounding: true,
      );
      return conversionResult ?? 0.0; // Fix the convertedAmount issue
    } catch (e) {
      print('Conversion error: $e');
      return 0.0;
    }
  }

  // Helper function to map your custom Currency enum to the package's Currency enum
  currencyConverter.Currency _mapCurrencyEnum(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return currencyConverter.Currency.usd;
      case 'GBP':
        return currencyConverter.Currency.gbp;
      case 'CAD':
        return currencyConverter.Currency.cad;
      case 'AUD':
        return currencyConverter.Currency.aud;
      default:
        throw Exception('Unsupported currency code');
    }
  }

  void _generateToken() {
    setState(() {
      transactionToken = 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)}';
      transactionPin = _generatePin();
    });
    _goToNextStep(); // Move to the token display step
  }

  String _generatePin() {
    var rng = Random();
    return rng.nextInt(9999).toString().padLeft(4, '0');
  }

  void _copyTokenToClipboard() {
    Clipboard.setData(ClipboardData(text: transactionToken));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Token copied to clipboard')),
    );
  }

  void _shareToken() {
    // Implement sharing functionality here
  }

  String _getCountryCurrency(String country) {
    switch (country) {
      case 'USA':
        return 'USD';
      case 'UK':
        return 'GBP';
      case 'Canada':
        return 'CAD';
      case 'Australia':
        return 'AUD';
      default:
        return 'USD';
    }
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

  Widget _buildCurrentStepWidget() {
    switch (_currentStep) {
      case TransactionStep.amount:
        return _buildTransactionStepCard(
          child: _buildInputField(
            controller: _amountController,
            label: 'Enter Amount',
            hintText: 'Enter amount to send',
            onNext: _convertAmount,
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
            onNext: _generateToken,
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
        const SizedBox(height: 10),
        Text(
          '4-Digit PIN: $transactionPin',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white38),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFCBFF30)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: obscureText ? TextInputType.number : TextInputType.text,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCBFF30),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required VoidCallback onNext}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButton<String>(
          dropdownColor: Colors.black54,
          value: selectedCountry,
          hint: const Text(
            'Select Country',
            style: TextStyle(color: Colors.white38),
          ),
          isExpanded: true,
          items: countries.map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(
                country,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCountry = value;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: selectedCountry != null ? onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCBFF30),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text('Next'),
        ),
      ],
    );
  }
}
