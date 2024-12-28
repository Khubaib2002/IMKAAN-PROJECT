import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SearchPatientPage extends StatefulWidget {
  const SearchPatientPage({super.key});

  @override
  State<SearchPatientPage> createState() => _SearchPatientPageState();
}

class _SearchPatientPageState extends State<SearchPatientPage> {
  final TextEditingController searchController = TextEditingController();
  String searchKey = "";

  Stream<List<DocumentSnapshot>> _searchPatients() {
    if (searchKey.isEmpty) {
      // Return all patients if no search key is provided
      return FirebaseFirestore.instance
          .collection('Patients')
          .snapshots()
          .map((snapshot) => snapshot.docs);
    } else {
      // Perform search on `name`, `Name`, or `Patient_1`
      final nameQuery = FirebaseFirestore.instance
          .collection('Patients')
          .where('name', isGreaterThanOrEqualTo: searchKey)
          .where('name', isLessThan: searchKey + '\uf8ff')
          .snapshots();

      final capitalNameQuery = FirebaseFirestore.instance
          .collection('Patients')
          .where('Name', isGreaterThanOrEqualTo: searchKey)
          .where('Name', isLessThan: searchKey + '\uf8ff')
          .snapshots();

      final patientIdQuery = FirebaseFirestore.instance
          .collection('Patients')
          .where('Patient_id', isGreaterThanOrEqualTo: searchKey)
          .where('Patient_id', isLessThan: searchKey + '\uf8ff')
          .snapshots();

      // Combine the results of the three queries
      return Rx.combineLatest3<QuerySnapshot, QuerySnapshot, QuerySnapshot,
          List<DocumentSnapshot>>(
        nameQuery,
        capitalNameQuery,
        patientIdQuery,
        (nameResult, capitalNameResult, patientIdResult) {
          final allDocs = [
            ...nameResult.docs,
            ...capitalNameResult.docs,
            ...patientIdResult.docs
          ];
          // Remove duplicates by ID
          return allDocs.toSet().toList();
        },
      );
    }
  }

  Stream<QuerySnapshot> _searchDeliveries() {
    if (searchKey.isEmpty) {
      return FirebaseFirestore.instance.collection('Prev_Delivery').snapshots();
    }

    return FirebaseFirestore.instance
        .collection('Prev_Delivery')
        .where('year', isEqualTo: searchKey)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient and Delivery Viewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Name, ID, or Year',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchKey = value.trim();
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Patients'),
                        Tab(text: 'Deliveries'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPatientList(),
                          _buildDeliveryList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _searchPatients(), // Replace with your stream function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Patients Found'),
          );
        }

        return ListView(
          children: snapshot.data!.map((doc) {
            final data = doc.data()
                as Map<String, dynamic>?; // Safely cast document data
            if (data == null) return const SizedBox.shrink();

            // Safely access fields with null checks
            final name = data['name'] ?? data['Name'] ?? 'Unknown';
            final fileNo = data['file_no'] ?? 'N/A';
            final patientId = data['Patient_1'] ?? 'N/A';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailScreen(
                      patientData: data,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text("File Number: $fileNo"),
                  trailing: Text("ID: $patientId"),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDeliveryList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _searchDeliveries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Deliveries Found'),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data()
                as Map<String, dynamic>?; // Safely cast document data
            if (data == null) return const SizedBox.shrink();

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryDetailScreen(
                      deliveryData: data,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text("Year: ${data['year'] ?? 'Unknown'}"),
                  subtitle: Text("Type: ${data['type'] ?? 'Unknown'}"),
                  trailing: Text("Location: ${data['location'] ?? 'Unknown'}"),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class PatientDetailScreen extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientDetailScreen({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: patientData.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value?.toString() ?? 'N/A'),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DeliveryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> deliveryData;

  const DeliveryDetailScreen({super.key, required this.deliveryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: deliveryData.entries.map((entry) {
            return ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value?.toString() ?? 'N/A'),
            );
          }).toList(),
        ),
      ),
    );
  }
}
