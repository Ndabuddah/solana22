import 'package:flutter/material.dart';

class transact extends StatelessWidget {
  const transact({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.grey.shade100,
          child: TextFormField(
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(0xFFCBFF30),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Send",
                  style: TextStyle(color: Colors.black87, fontSize: 26, fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.send,
                  color: Colors.black87,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
