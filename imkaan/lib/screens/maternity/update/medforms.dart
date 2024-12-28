import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MedicalForm extends StatefulWidget {
  final String patientId;
  const MedicalForm({required this.patientId});

  @override
  State<MedicalForm> createState() => _MedicalFormState();
}

class _MedicalFormState extends State<MedicalForm> {
  // Controllers for input fields
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
              const Text(
                'Enter new medical record information here',
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
                  addMedicalForm(
                    widget.patientId,
                    filenoController.text,
                    dateController.text,
                    bpTempController.text,
                    diagnosisController.text,
                    treatmentController.text,
                    labRemarksController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                  child: Text('Save', style: TextStyle(fontSize: 18)),
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
                              IconButton(
                                icon: const Icon(Icons.save),
                                onPressed: () {
                                  updateMedicalForm(
                                    widget.patientId,
                                    document.id,
                                    filenoController.text,
                                    dateController.text,
                                    bpTempController.text,
                                    diagnosisController.text,
                                    treatmentController.text,
                                    labRemarksController.text,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteMedicalForm(
                                      widget.patientId, document.id);
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
      ),
    );
  }
}
