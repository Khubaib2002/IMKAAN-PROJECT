import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imkaan/screens/maternity/search/ancdetailed.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

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
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: searchKey)
          .where(FieldPath.documentId, isLessThan: searchKey + '\uf8ff')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Name or ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchKey = value.trim();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _searchPatients(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Patients Found'));
                  }

                  return ListView(
                    children: snapshot.data!.map((doc) {
                      final data = doc.data() as Map<String, dynamic>?;
                      if (data == null) return const SizedBox.shrink();

                      final name = data['name'] ?? data['Name'] ?? 'Unknown';
                      final patientId = doc.id;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientDetailTabsScreen(
                                patientId: doc.id,
                                patientName: name,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Text(name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("ID: $patientId"),
                            leading: CircleAvatar(
                              child: Text(name[0].toUpperCase(),
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDetailTabsScreen extends StatelessWidget {
  final String patientId;
  final String patientName;

  const PatientDetailTabsScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Details - $patientName',
              style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Delivery Files'),
              Tab(text: 'Previous Deliveries'),
              Tab(text: 'Medical Forms'),
              Tab(text: 'ANC Cards'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DeliveryFilesTab(patientId: patientId),
            PreviousDeliveriesTab(patientId: patientId),
            MedicalFormsTab(patientId: patientId),
            ANCCardsTab(patientId: patientId),
          ],
        ),
      ),
    );
  }
}

class DeliveryFilesTab extends StatefulWidget {
  final String patientId;
  const DeliveryFilesTab({super.key, required this.patientId});

  @override
  State<DeliveryFilesTab> createState() => _DeliveryFilesTabState();
}

class _DeliveryFilesTabState extends State<DeliveryFilesTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Delivery Files',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Patients')
                  .doc(widget.patientId)
                  .collection('deliveryfiles')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No Delivery Files Found',
                          style: TextStyle(fontSize: 16.0)));
                }
                return ListView(
                  children: snapshot.data!.docs.map<Widget>((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    if (data == null) return const SizedBox.shrink();

                    final admissionDate = data['admissiondate'] ?? 'Unknown';
                    final diagnosis = data['selecteddiagnosis'] ?? 'N/A';
                    final procedure = data['selectedprocedure'] ?? 'N/A';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailedDeliveryScreen(
                                deliveryData: data,
                              ),
                            ));
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text("Admission Date: $admissionDate",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Diagnosis: $diagnosis"),
                          trailing: Text("Procedure: $procedure"),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PreviousDeliveriesTab extends StatefulWidget {
  final String patientId;
  const PreviousDeliveriesTab({super.key, required this.patientId});

  @override
  State<PreviousDeliveriesTab> createState() => _PreviousDeliveriesTabState();
}

class _PreviousDeliveriesTabState extends State<PreviousDeliveriesTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Previous Deliveries',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Patients')
                  .doc(widget.patientId)
                  .collection('prevdeliveries')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No Previous Deliveries Found'));
                }
                return ListView(
                  children: snapshot.data!.docs.map<Widget>((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    if (data == null) return const SizedBox.shrink();

                    final date = data['Date of Delivery'] ?? 'Unknown';
                    final type = data['Type'] ?? 'N/A';
                    final location = data['Location'] ?? 'N/A';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PreviousDeliveriesDetailedScreen(
                              deliveryData: data,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text("Date of Delivery: $date",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Type/Mode: $type"),
                          trailing: Text("Location: $location"),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MedicalFormsTab extends StatefulWidget {
  final String patientId;
  const MedicalFormsTab({super.key, required this.patientId});

  @override
  State<MedicalFormsTab> createState() => _MedicalFormsTabState();
}

class _MedicalFormsTabState extends State<MedicalFormsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Medical Forms',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Patients')
                  .doc(widget.patientId)
                  .collection('medicalRecords')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Medical Forms Found'));
                }
                return ListView(
                  children: snapshot.data!.docs.map<Widget>((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    if (data == null) return const SizedBox.shrink();

                    final date = data['Date'] ?? 'Unknown';
                    final diagnosis = data['Diagnosis'] ?? 'N/A';
                    final fileno = data['fileno'] ?? 'N/A';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicalFormsDetailedScreen(
                              medicalFormData: data,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text("File no: $fileno",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Date $date"),
                          trailing: Text("Diagnosis: $diagnosis"),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ANCCardsTab extends StatefulWidget {
  final String patientId;
  const ANCCardsTab({super.key, required this.patientId});

  @override
  State<ANCCardsTab> createState() => _ANCCardsTab();
}

class _ANCCardsTab extends State<ANCCardsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Antenatal, Labor, and Delivery Cards',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Patients')
                  .doc(widget.patientId)
                  .collection('AntenatalRecords')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No ANC Cards Found'));
                }
                return ListView(
                  children: snapshot.data!.docs.map<Widget>((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    if (data == null) return const SizedBox.shrink();

                    final ancregno = data['ANC Reg No'] ?? 'Unknown';
                    final date = data['Date'] ?? 'N/A';
                    final time = data['Time'] ?? 'N/A';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ANCDetailedScreen(
                                  ancData: data,
                                  patientId: widget.patientId,
                                  cardId: doc.id)),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text("ANC Reg No: $ancregno",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Date: $date"),
                          trailing: Text("Time: $time"),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailedDeliveryScreen extends StatelessWidget {
  final Map<String, dynamic> deliveryData;

  const DetailedDeliveryScreen({Key? key, required this.deliveryData})
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery File Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const Divider(),
            buildInfoTile(
                'Admission Date', deliveryData['admissiondate'] ?? ''),
            buildInfoTile('Blood Group', deliveryData['bloodgroup'] ?? ''),
            buildInfoTile('Blood Pressure', deliveryData['bp'] ?? ''),
            buildInfoTile(
                'Diagnosis', deliveryData['compaintsdiagnosis'] ?? ''),
            buildInfoTile('Fundal Height', deliveryData['fundalheight'] ?? ''),
            buildInfoTile('FHR', deliveryData['fhr'] ?? ''),
            buildInfoTile(
                'Discharge Date', deliveryData['dischargeDate'] ?? ''),
            buildInfoTile(
                'Discharge Done By', deliveryData['dischargeDoneBy'] ?? ''),
            buildInfoTile('Mode of Delivery', deliveryData['mode'] ?? ''),
            buildInfoTile('Mother\'s BP', deliveryData['motherBP'] ?? ''),
            buildInfoTile('Mother\'s Pulse', deliveryData['motherPulse'] ?? ''),
            buildInfoTile(
                'Mother\'s Temperature', deliveryData['motherTemp'] ?? ''),
            buildInfoTile('Diagnosis', deliveryData['selectedDiagnosis'] ?? ''),
            buildInfoTile('Procedure', deliveryData['selectedProcedure'] ?? ''),
            buildInfoTile('Special Recommendations',
                deliveryData['specialRecommendations'] ?? ''),
            buildInfoTile('Length of Stay', deliveryData['lengthOfStay'] ?? ''),
            buildInfoTile('Engagement', deliveryData['engagement'] ?? ''),
            buildInfoTile('Dilation (cm)', deliveryData['dilation_cm'] ?? ''),
            buildInfoTile('Effacement', deliveryData['effacement'] ?? ''),
            buildInfoTile(
                'Presenting Part', deliveryData['presentingPart'] ?? ''),
            buildInfoTile('Lie', deliveryData['lie'] ?? ''),
            buildInfoTile('Weight', deliveryData['weight'] ?? ''),
            const SizedBox(height: 20),
            const Text(
              'Postnatal Care',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const Divider(),
            buildInfoTile('Exclusive Breastfeeding',
                deliveryData['exclusivebreastfeeding'] ?? ''),
            buildInfoTile(
                'Postnatal Care Provided', deliveryData['postnatalCare'] ?? ''),
            buildInfoTile('Lochia Normal', deliveryData['lochiaNormal'] ?? ''),
            buildInfoTile(
                'Uterus Contracted', deliveryData['uterusContracted'] ?? ''),
            buildInfoTile('Vitamin A Given', deliveryData['vitaminA'] ?? ''),
            buildInfoTile('Family Planning Provided',
                deliveryData['familyPlanning'] ?? ''),
            const SizedBox(height: 20),
            const Text(
              'Newborn Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const Divider(),
            buildInfoTile('Newborn Passed Stool',
                deliveryData['newbornPassedStool'] ?? ''),
            buildInfoTile('Newborn Passed Urine',
                deliveryData['newbornPassedUrine'] ?? ''),
            buildInfoTile(
                'Newborn Temperature', deliveryData['newbornTemp'] ?? ''),
          ],
        ),
      ),
    );
  }
}

class PreviousDeliveriesDetailedScreen extends StatelessWidget {
  final Map<String, dynamic> deliveryData;

  const PreviousDeliveriesDetailedScreen({Key? key, required this.deliveryData})
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Delivery Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const Divider(),
            buildInfoTile('Baby Alive', deliveryData['Baby Alive'] ?? ''),
            buildInfoTile(
                'Date of Delivery', deliveryData['Date of Delivery'] ?? ''),
            buildInfoTile('Location', deliveryData['Location'] ?? ''),
            buildInfoTile('Type', deliveryData['Type'] ?? ''),
          ],
        ),
      ),
    );
  }
}

class MedicalFormsDetailedScreen extends StatelessWidget {
  final Map<String, dynamic> medicalFormData;

  const MedicalFormsDetailedScreen({Key? key, required this.medicalFormData})
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Form Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medical Form Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const Divider(),
            buildInfoTile('File Number', medicalFormData['fileno'] ?? ''),
            buildInfoTile('Date', medicalFormData['Date'] ?? ''),
            buildInfoTile('BP/Temp', medicalFormData['BP/Temp'] ?? ''),
            buildInfoTile('Diagnosis', medicalFormData['Diagnosis'] ?? ''),
            buildInfoTile('Lab/Remarks', medicalFormData['Lab/Remarks'] ?? ''),
            buildInfoTile('Treatment', medicalFormData['Treatment'] ?? ''),
          ],
        ),
      ),
    );
  }
}
