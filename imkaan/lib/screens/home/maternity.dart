import 'package:flutter/material.dart';


class MaternityClinicPage extends StatelessWidget {
  const MaternityClinicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maternity Clinic Data",
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
          'Maternity Clinic Data',
          style: TextStyle(fontSize: 34),
        ),
      ),
    );
  }
}
