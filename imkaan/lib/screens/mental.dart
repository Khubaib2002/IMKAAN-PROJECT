import 'package:flutter/material.dart';

class MentalHealth extends StatelessWidget {
  const MentalHealth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mental Health Clinic",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(252, 252, 216, 0),
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
        ),
        backgroundColor: Color.fromARGB(252, 252, 216, 0),
      ),
      body: const Center(
        child: Text(
          'Mental Health Clinic',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
