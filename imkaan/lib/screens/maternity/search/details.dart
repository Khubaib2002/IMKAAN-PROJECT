import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsPage extends StatefulWidget {
  final String patientId;
  const PatientDetailsPage({super.key, required this.patientId});

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  // This method loads the patient data from the 'Patients' collection
  Future<Map<String, dynamic>> _getPatientData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(widget.patientId)
        .get();

    return snapshot.data() as Map<String, dynamic>;
  }

  // Widget to display the patient details
  Widget _buildDocumentDetails(Map<String, dynamic> data) {
    return ListView.builder(
      itemCount: data.entries.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final entry = data.entries.elementAt(index);
        return Card(
          color: Color(0xFFFFF4B2), // Light yellow background
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: Text(
              entry.key,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Color(0xFF6A4E00)), // Dark yellow text
            ),
            subtitle: Text(
              entry.value.toString(),
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getPatientData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Data Found'));
          }

          Map<String, dynamic> data = snapshot.data!;

          // Display the patient details using the _buildDocumentDetails method
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: double.infinity),
            child: _buildDocumentDetails(data),
          );
        },
      ),
    );
  }
}
