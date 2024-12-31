import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imkaan/screens/maternity/update/anc/visits.dart';
import 'package:intl/intl.dart';

class AntenatalDeliveryCard extends StatefulWidget {
  final String patientId, name;
  const AntenatalDeliveryCard({super.key, required this.patientId, required this.name});

  @override
  State<AntenatalDeliveryCard> createState() => _AntenatalDeliveryCardState();
}

class _AntenatalDeliveryCardState extends State<AntenatalDeliveryCard> {
  // TextEditingControllers for various fields
  String currentcardid = '';
  bool isUpdating = false;
  TextEditingController ancregController = TextEditingController();
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

  Future<String> saveancRecord(
    String patientId,
    String ancregno,
    String date,
    String time,
    Map<String, bool> currentPregnancy,
    Map<String, bool> obstetricHistory,
    Map<String, bool> generalMedical,
    String comments,
  ) async {
    try {
      DocumentReference docref = await FirebaseFirestore.instance
          .collection('Patients')
          .doc(widget.patientId)
          .collection('AntenatalRecords')
          .add({
        'ANC Reg No': ancregno,
        'Date': date,
        'Time': time,
        'Current Pregnancy': currentPregnancy,
        'Obstetric History': obstetricHistory,
        'General Medical': generalMedical,
        'Comments': comments,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card added successfully!')),
      );
      return docref.id;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return '';
    }
  }

  Future<void> updateancRecord(
    String patientId,
    String recordId,
    String ancregno,
    String date,
    String time,
    Map<String, bool> currentPregnancy,
    Map<String, bool> obstetricHistory,
    Map<String, bool> generalMedical,
    String comments,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .collection('AntenatalRecords')
          .doc(recordId) // Use the recordId to update a specific document
          .set({
        'ANC Reg No': ancregno,
        'Date': date,
        'Time': time,
        'Current Pregnancy': currentPregnancy,
        'Obstetric History': obstetricHistory,
        'General Medical': generalMedical,
        'Comments': comments,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card updated successfully!')),
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
          const SnackBar(content: Text('Card deleted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _selectDate(
    BuildContext context, {
    required TextEditingController controller,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    // Use default values if none are provided
    initialDate ??= DateTime.now();
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  void toggleMode(bool updating) {
    setState(() {
      isUpdating = updating;
      // clearFields();
    });
  }

  void clearFields() {
    setState(() {
      dateController.clear();
      timeController.clear();
      commentsController.clear();
      ancregController.clear();
      currentPregnancy = {
        'Single fetus': false,
        'Suspected multiple pregnancy': false,
        'Age less than 16 years': false,
        'RH(-) in current or previous pregnancy': false,
        'Anemia': false,
      };
      obstetricHistory = {
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
      generalMedical = {
        'Diabetes mellitus': false,
        'HCV': false,
        'HBsAg': false,
        'Cardiac disease': false,
        'TB': false,
        'Chronic hypertension': false,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.patientId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Antenatal, Labor, and Delivery Cards',
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
          backgroundColor: const Color(0xFFFFCA03), // Yellow-themed AppBar
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFF9C4),
                Color(0xFFFFECB3)
              ], // Soft yellow gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.health_and_safety, // Relevant medical icon
                size: 100, // Slightly larger for emphasis
                color: Color(0xFFFFCA03), // Bright yellow
              ),
              const SizedBox(height: 20),
              const Text(
                'Please select a patient to add or update ANC Cards.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D6E63), // A complementary brown tone
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Antenatal, Labor, and Delivery Cards',
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
            const SizedBox(height: 20),
            Text(
              'Patient Name: ${widget.name}',
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            Text(
              isUpdating ? 'Add ANC Card' : 'Update ANC Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ancregController,
              decoration: const InputDecoration(
                labelText: 'ANC Reg No',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectDate(context, controller: dateController),
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
            }),
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
            }),
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
            }),
            const SizedBox(height: 20),
            TextField(
              controller: commentsController,
              decoration: const InputDecoration(
                labelText: 'Comments',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                if (dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter date to continue.')));
                  return;
                }
                if (isUpdating) {
                  updateancRecord(
                      widget.patientId,
                      currentcardid,
                      ancregController.text,
                      dateController.text,
                      timeController.text,
                      currentPregnancy,
                      obstetricHistory,
                      generalMedical,
                      commentsController.text);
                } else {
                  currentcardid = await saveancRecord(
                      widget.patientId,
                      ancregController.text,
                      dateController.text,
                      timeController.text,
                      currentPregnancy,
                      obstetricHistory,
                      generalMedical,
                      commentsController.text);
                }
                clearFields();
                toggleMode(false);
              },
              // style: ElevatedButton.styleFrom(
              //   foregroundColor: Colors.white,
              //   backgroundColor: Colors.blue,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              // ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(isUpdating ? 'Update ANC Card' : 'Add ANC Card',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ANCVisits(
                        patientId: widget.patientId,
                        name: widget.name,
                        cardid: currentcardid),
                  ),
                );
              },
              child: Text('Add or update visits for this card'),
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
                        title: Text(
                            'ANC Reg No:  ${data.containsKey('ANC Reg No') ? document['ANC Reg No'] : ''}'),
                        subtitle: Text('Date: ${document['Date']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                toggleMode(true);
                                ancregController.text =
                                    data.containsKey('ANC Reg No')
                                        ? document['ANC Reg No']
                                        : '';
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
                                currentcardid = document.id.toString();
                              },
                            ),
                            const Text('Edit'),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteancRecord(widget.patientId, document.id);
                                clearFields();
                              },
                            ),
                            const Text('Delete'),
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
