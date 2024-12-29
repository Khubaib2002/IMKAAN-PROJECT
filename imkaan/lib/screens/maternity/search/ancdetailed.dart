import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ANCDetailedScreen extends StatelessWidget {
  final Map<String, dynamic> ancData;
  final String patientId;
  final String cardId;

  const ANCDetailedScreen(
      {Key? key,
      required this.ancData,
      required this.patientId,
      required this.cardId})
      : super(key: key);

  Widget buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTrueValuesSection(String title, Map<String, dynamic> data) {
    final trueValues = data.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    if (trueValues.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const Divider(),
        ...trueValues.map((value) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                value,
                style: const TextStyle(fontSize: 16.0),
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  void navigateToVisits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ANCVisitsScreen(patientId: patientId, cardId: cardId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ANC Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
        backgroundColor: const Color(0xFFFFCA03),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const Divider(),
            buildInfoTile('ANC Reg No', ancData['ANC Reg No'] ?? ''),
            buildInfoTile('Date', ancData['Date'] ?? ''),
            buildInfoTile('Time', ancData['Time'] ?? ''),
            buildInfoTile('Comments', ancData['Comments'] ?? ''),
            const SizedBox(height: 16),
            buildTrueValuesSection('Current Pregnancy',
                Map<String, dynamic>.from(ancData['Current Pregnancy'] ?? {})),
            buildTrueValuesSection('General Medical',
                Map<String, dynamic>.from(ancData['General Medical'] ?? {})),
            buildTrueValuesSection('Obstetric History',
                Map<String, dynamic>.from(ancData['Obstetric History'] ?? {})),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => navigateToVisits(context),
              child: const Text('View Visits Information'),
            ),
          ],
        ),
      ),
    );
  }
}

class ANCVisitsScreen extends StatelessWidget {
  final String patientId, cardId;

  const ANCVisitsScreen(
      {Key? key, required this.patientId, required this.cardId})
      : super(key: key);

  Widget buildVisitTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ANC Visits Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
        backgroundColor: const Color(0xFFFFCA03),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Patients')
            .doc(patientId)
            .collection('AntenatalRecords')
            .doc(cardId)
            .collection('Visits')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Visits Found'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildVisitTile('Date', data['Date'] ?? ''),
                      const Text(
                        'Examination',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const Divider(),
                      buildVisitTile(
                          'Gestational Age', data['Gestational Age'] ?? ''),
                      buildVisitTile('Weight', data['Weight'] ?? ''),
                      buildVisitTile(
                          'Blood Pressure', data['Blood Pressure'] ?? ''),
                      buildVisitTile(
                          'Fundal Height (cm)', data['Fundal Height'] ?? ''),
                      buildVisitTile('Fetal Heart Beat (Beats/Minute)',
                          data['Fetal Heart Beat'] ?? ''),
                      buildVisitTile('Fetal Movement (Positive/Negative)',
                          data['Fetal Movement'] ?? ''),
                      buildVisitTile('Position', data['Position'] ?? ''),
                      buildVisitTile(
                          'Presentation', data['Presentation'] ?? ''),
                      buildVisitTile(
                          'Conjunctivita', data['Conjunctivitis'] ?? ''),
                      buildVisitTile('Oedema', data['Oedema'] ?? ''),
                      buildVisitTile(
                          'Other Complaints', data['Other Complaints'] ?? ''),
                      const Text(
                        'Laboratory Tests',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const Divider(),
                      buildVisitTile('Haemoglobin', data['Haemoglobin'] ?? ''),
                      buildVisitTile('AntihCV', data['AntihCV'] ?? ''),
                      buildVisitTile('HBSAG', data['HBSAG'] ?? ''),
                      buildVisitTile('Pregnancy Test', data['Pregtest'] ?? ''),
                      buildVisitTile(
                          'Urine Analysis', data['Urine Analysis'] ?? ''),
                      buildVisitTile('Blood Group', data['Blood Group'] ?? ''),
                      buildVisitTile('Other tests', data['Other Test'] ?? ''),
                      const Text(
                        'Medication',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const Divider(),
                      buildVisitTile('Ferrous Sulphate/Folic Acid',
                          data['Ferrous Sulphate/Folic Acid'] ?? ''),
                      buildVisitTile('Albendazole', data['Albendazole'] ?? ''),
                      buildVisitTile(
                          'UTI Treatment', data['Uti Treatment'] ?? ''),
                      buildVisitTile('Vitamin C', data['Vitamin C'] ?? ''),
                      buildVisitTile(
                          'Other Medication', data['Other Meds'] ?? ''),
                      const Text(
                        'Next Appointment',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const Divider(),
                      buildVisitTile(
                          'Next Appointment', data['Next Appointment'] ?? ''),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
