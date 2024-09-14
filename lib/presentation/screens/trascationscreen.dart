import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/transactionModel.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Transaction> _filterTransactions(String status) {
    if (status == 'All') {
      return mockTransactions;
    } else if (status == 'Retrieved') {
      return mockTransactions.where((t) => t.retrieved).toList();
    } else {
      return mockTransactions.where((t) => !t.retrieved).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282828),
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Retrieved'),
            Tab(text: 'Not Retrieved'),
          ],
          indicatorColor: Color(0xFFCBFF30),
          labelColor: Colors.white, // Text color for selected tab
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList('All'),
          _buildTransactionList('Retrieved'),
          _buildTransactionList('Not Retrieved'),
        ],
      ),
    );
  }

  Widget _buildTransactionList(String status) {
    final transactions = _filterTransactions(status);

    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
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
            child: ListTile(
              leading: Icon(
                transaction.retrieved ? Icons.check_circle : Icons.error,
                color: transaction.retrieved ? Colors.green : Colors.red,
              ),
              title: Text(
                'Token: ${transaction.tokenNumber}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Date: ${DateFormat.yMMMd().format(transaction.date)}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                transaction.retrieved ? "Retrieved" : "Not Retrieved",
                style: TextStyle(
                  color: transaction.retrieved ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
