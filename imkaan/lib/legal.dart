import 'package:flutter/material.dart';


class LegalAidPage extends StatelessWidget {
  const LegalAidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Legal Aid",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 255, 255),
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'
            ),
          ),
        backgroundColor: Colors.grey[850],
      ),
      body: const Center(
        child: Text(
          'Legal Aid Data',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}