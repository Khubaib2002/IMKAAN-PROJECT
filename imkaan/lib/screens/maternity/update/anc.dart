import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AntenatalDeliveryCard extends StatefulWidget {
  final String patientId, name;
  const AntenatalDeliveryCard({required this.patientId, required this.name});

  @override
  State<AntenatalDeliveryCard> createState() => _AntenatalDeliveryCardState();
}

class _AntenatalDeliveryCardState extends State<AntenatalDeliveryCard> {
  // TextEditingControllers for various fields
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  Map<String, bool> currentPregnancy = {
    'Single fetus': false,
    'Suspected multiple pregnancy': false,
    'Age less than 16 years': false,
    'RH(-) in current or previous pregnancy': false,
    'Anemia': false,
  };

  Map<String, bool> obstetricHistory = {
    'Previous stillbirth or neonatal loss and IUD': false,
    'History of abortion': false,
    'SVD at home or hospital': false,
    'Low birth weight baby': false,
    'Prolonged labor': false,
    'PPH and APH': false,
    'Blood transfusion': false,
    'C/S (cesarean section)': false,
    'Fetal distress': false,
  };

  Map<String, bool> generalMedical = {
    'Diabetes mellitus': false,
    'HCV': false,
    'HBsAg': false,
    'Cardiac disease': false,
    'TB': false,
    'Chronic hypertension': false,
  };

  Future<void> saveancRecord() async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(widget.patientId)
          .collection('AntenatalRecords')
          .add({
        'Date': dateController.text,
        'Time': timeController.text,
        'Current Pregnancy': currentPregnancy,
        'Obstetric History': obstetricHistory,
        'General Medical': generalMedical,
        'Comments': commentsController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> updateancRecord(
    String patientId,
    String recordId,
    String date,
    String time,
    String currentPregnancy,
    String obstetricHistory,
    String generalMedical,
    String comments,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .collection('AntenatalRecords')
          .doc(recordId) // Use the recordId to update a specific document
          .set({
        'Date': date,
        'Time': time,
        'Current Pregnancy': currentPregnancy,
        'Obstetric History': obstetricHistory,
        'General Medical': generalMedical,
        'Comments': comments,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Antenatal record updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> deleteancRecord(String patientId, String recordId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .collection('AntenatalRecords')
          .doc(recordId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record deleted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antenatal, Labor, and Delivery Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Patient Name: ${widget.name}',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Current Pregnancy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...currentPregnancy.keys.map((key) {
              return CheckboxListTile(
                title: Text(key),
                value: currentPregnancy[key],
                onChanged: (val) {
                  setState(() {
                    currentPregnancy[key] = val!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Obstetric History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...obstetricHistory.keys.map((key) {
              return CheckboxListTile(
                title: Text(key),
                value: obstetricHistory[key],
                onChanged: (val) {
                  setState(() {
                    obstetricHistory[key] = val!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'General Medical',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...generalMedical.keys.map((key) {
              return CheckboxListTile(
                title: Text(key),
                value: generalMedical[key],
                onChanged: (val) {
                  setState(() {
                    generalMedical[key] = val!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            TextField(
              controller: commentsController,
              decoration: const InputDecoration(
                labelText: 'Comments',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            ElevatedButton(
              onPressed: saveancRecord,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                child: Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
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
                return Column(
                  children: snapshot.data!.docs.map<Widget>((document) {
                    final data = document.data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text('Date: ${document['Date']}'),
                        subtitle: Text('Time: ${document['Time']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                dateController.text = data.containsKey('Date')
                                    ? data['Date']
                                    : '';
                                timeController.text = data.containsKey('Time')
                                    ? data['Time']
                                    : '';
                                currentPregnancy =
                                    data.containsKey('Current Pregnancy')
                                        ? Map<String, bool>.from(
                                            data['Current Pregnancy'])
                                        : currentPregnancy;
                                obstetricHistory =
                                    data.containsKey('Obstetric History')
                                        ? Map<String, bool>.from(
                                            data['Obstetric History'])
                                        : obstetricHistory;
                                generalMedical =
                                    data.containsKey('General Medical')
                                        ? Map<String, bool>.from(
                                            data['General Medical'])
                                        : generalMedical;
                                commentsController.text =
                                    data.containsKey('Comments')
                                        ? data['Comments']
                                        : '';
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () {
                                updateancRecord(
                                    widget.patientId,
                                    document.id,
                                    dateController.text,
                                    timeController.text,
                                    currentPregnancy.toString(),
                                    obstetricHistory.toString(),
                                    generalMedical.toString(),
                                    commentsController.text);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteancRecord(widget.patientId, document.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
