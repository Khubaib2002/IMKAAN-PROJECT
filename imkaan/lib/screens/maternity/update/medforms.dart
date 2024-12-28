import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MedicalForm extends StatefulWidget {
  final String patientId, name;
  const MedicalForm({required this.patientId, required this.name});

  @override
  State<MedicalForm> createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  bool isUpdating = false;
  String docid = '';
  TextEditingController dateController = TextEditingController();
  TextEditingController bpTempController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController treatmentController = TextEditingController();
  TextEditingController labRemarksController = TextEditingController();
  TextEditingController filenoController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> addMedicalForm(
      String patientId,
      String fileno,
      String date,
      String bpTemp,
      String diagnosis,
      String treatment,
      String labRemarks) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .collection('medicalRecords')
          .add({
        'Date': date,
        'fileno': fileno,
        'BP/Temp': bpTemp,
        'Diagnosis': diagnosis,
        'Treatment': treatment,
        'Lab/Remarks': labRemarks,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical record saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> updateMedicalForm(
      String patientId,
      String recordId,
      String fileno,
      String date,
      String bpTemp,
      String diagnosis,
      String treatment,
      String labRemarks) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .collection('medicalRecords')
          .doc(recordId)
          .set({
        'fileno': fileno,
        'Date': date,
        'BP/Temp': bpTemp,
        'Diagnosis': diagnosis,
        'Treatment': treatment,
        'Lab/Remarks': labRemarks,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Medical record updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> deleteMedicalForm(String patientId, String recordId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientId)
          .collection('medicalRecords')
          .doc(recordId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Medical record deleted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
      bpTempController.clear();
      diagnosisController.clear();
      treatmentController.clear();
      labRemarksController.clear();
      filenoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.patientId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Medical Records'),
        ),
        body: const Center(
          child: Text(
            'Please select a patient to add or update medical records.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Patient Name: ${widget.name}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              Text(
                isUpdating ? 'Add Medical Record' : 'Update Medical Form',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: filenoController,
                decoration: const InputDecoration(
                  labelText: 'File No',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bpTempController,
                decoration: const InputDecoration(
                  labelText: 'BP/Temp',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: diagnosisController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: treatmentController,
                decoration: const InputDecoration(
                  labelText: 'Treatment',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: labRemarksController,
                decoration: const InputDecoration(
                  labelText: 'Lab/Remarks',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.patientId.isEmpty ||
                      dateController.text.isEmpty ||
                      diagnosisController.text.isEmpty ||
                      filenoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Please fill in all required fields before saving.')));
                    return;
                  }
                  if (isUpdating) {
                    updateMedicalForm(
                      widget.patientId,
                      docid,
                      filenoController.text,
                      dateController.text,
                      bpTempController.text,
                      diagnosisController.text,
                      treatmentController.text,
                      labRemarksController.text,
                    );
                  } else {
                    addMedicalForm(
                      widget.patientId,
                      filenoController.text,
                      dateController.text,
                      bpTempController.text,
                      diagnosisController.text,
                      treatmentController.text,
                      labRemarksController.text,
                    );
                  }
                  clearFields();
                  toggleMode(false);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                  child: Text(isUpdating ? 'Update' : 'Add',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Saved Medical Records',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
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
                    return const Center(
                        child: Text('No Medical Records Found'));
                  }
                  return Column(
                    children: snapshot.data!.docs.map<Widget>((document) {
                      docid = document.id;
                      final data = document.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text('Date: ${data['Date']}'),
                          subtitle: Text('Diagnosis: ${data['Diagnosis']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  toggleMode(true);
                                  filenoController.text =
                                      data.containsKey('fileno')
                                          ? data['fileno']
                                          : '';
                                  dateController.text = data.containsKey('Date')
                                      ? data['Date']
                                      : '';
                                  bpTempController.text =
                                      data.containsKey('BP/Temp')
                                          ? data['BP/Temp']
                                          : '';
                                  diagnosisController.text =
                                      data.containsKey('Diagnosis')
                                          ? data['Diagnosis']
                                          : '';
                                  treatmentController.text =
                                      data.containsKey('Treatment')
                                          ? data['Treatment']
                                          : '';
                                  labRemarksController.text =
                                      data.containsKey('Lab/Remarks')
                                          ? data['Lab/Remarks']
                                          : '';
                                },
                              ),
                              const Text('Edit'),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteMedicalForm(
                                      widget.patientId, document.id);
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
      ),
    );
  }
}
