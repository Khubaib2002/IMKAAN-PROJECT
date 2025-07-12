import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsPage extends StatefulWidget {
  final String documentId;
  final String patientName; // Add patientName as a parameter

  const DetailsPage(
      {super.key,
      required this.documentId,
      required this.patientName}); // Update constructor to receive patientName

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // This method loads the data for the main document
  Future<Map<String, dynamic>> _getDocumentData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Mental') // Adjust collection name as needed
        .doc(widget.documentId)
        .get();

    return snapshot.data() as Map<String, dynamic>;
  }

  // This method loads the data for the selected subcollection
  Future<List<Map<String, dynamic>>> _getSubcollectionData(
      String subcollection) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Mental') // Adjust collection name as needed
        .doc(widget.documentId)
        .collection(subcollection)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Widget for the main document details
  Widget _buildDocumentDetails(Map<String, dynamic> data) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: data.entries.map((entry) {
        return Card(
          color: Color(0xFFFFF4B2), // Soft yellow background
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: Text(
              entry.key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color(0xFF6A4E00), // Dark yellow text
              ),
            ),
            subtitle: Text(
              entry.value.toString(),
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Widget to display a subcollection's details
  Widget _buildSubcollectionDetails(String subcollection) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getSubcollectionData(subcollection),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('$subcollection data not available'));
        }

        return ListView(
          padding: EdgeInsets.all(16.0),
          children: snapshot.data!.map((data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.entries.map((entry) {
                return Card(
                  color: Color(0xFFFFF4B2), // Light yellow background
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
                      // style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }

  // Build the tab layout
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Details - ${widget.patientName}', // Use patientName here
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
              Image.asset(
                'logo.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ],
          ),
          backgroundColor: Color(0xFFFFCA03),
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black54,
            labelColor: Color(0xFF6A4E00), // Dark yellow for selected tab
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Psych Details'),
              Tab(text: 'Family Details'),
              Tab(text: 'Weekly Details'),
            ],
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _getDocumentData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Document does not exist'));
            }

            Map<String, dynamic> data = snapshot.data!;

            return TabBarView(
              children: [
                _buildDocumentDetails(data), // Default tab
                _buildSubcollectionDetails('psych'),
                _buildSubcollectionDetails('Family'),
                _buildSubcollectionDetails('Weekly'),
              ],
            );
          },
        ),
      ),
    );
  }
}
