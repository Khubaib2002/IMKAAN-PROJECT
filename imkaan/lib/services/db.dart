import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imkaan/screens/maternity/update/anc/anc.dart';
import 'package:imkaan/screens/maternity/update/previousdeliveries.dart';
import 'package:imkaan/screens/maternity/update/deliveryfiles.dart';
import 'package:imkaan/screens/maternity/update/discharge.dart';
import 'package:imkaan/screens/maternity/update/medforms.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class DatabaseService {
  final CollectionReference patients =
      FirebaseFirestore.instance.collection('Patients');
  // final CollectionReference prevDeliveries =
  // FirebaseFirestore.instance.collection('Prev_Delivery');
  final CollectionReference discharges =
      FirebaseFirestore.instance.collection('DischargeInfo');

  Future<String> addPatientData(
      String name,
      String address,
      DateTime dob,
      String medicalHistory,
      int gravida,
      int para,
      int abortion,
      bool ancConsultation,
      String relation) async {
    String formattedDOB = DateFormat('yyyy-MM-dd').format(dob);

    // Add a new document and get the generated ID
    DocumentReference docRef = await patients.add({
      'name': name,
      'address': address,
      'DOB': formattedDOB,
      'medical_history': medicalHistory,
      'Gravida': gravida,
      'Para': para,
      'Abortion': abortion,
      'ANC_consultation': ancConsultation,
      'relation': relation,
    });

    // Add the generated ID as 'Patient_id' in the document
    await docRef.update({'Patient_id': docRef.id});
    return docRef.id; // Return the ID for confirmation
  }

  Future updateUserData(
      String pid,
      String name,
      String address,
      DateTime dob,
      String medicalHistory,
      int gravida,
      int para,
      int abortion,
      bool ancConsultation,
      String relation) async {
    log('This is a debug message.');

    String formattedDOB =
        '${DateFormat('MMMM d, yyyy \'at\' h:mm:ss a').format(dob.toLocal())} UTC+5';
    log('This is a debug message.');

    return await patients.doc(pid).set({
      'name': name,
      'address': address,
      'DOB': formattedDOB,
      'medical_history': medicalHistory,
      'Gravida': gravida,
      'Para': para,
      'Abortion': abortion,
      'ANC_consultation': ancConsultation,
      'relation': relation,
    });
  }

  Future<DocumentSnapshot> getUserData(String pid) async {
    return await patients.doc(pid).get();
  }

  Stream<QuerySnapshot> getPreviousDeliveryFiles(String patientId) {
    return patients
        .doc(patientId)
        .collection('deliveryfiles') // Access the 'Prev_Delivery' subcollection
        .snapshots();
  }

  // Update a previous delivery for a specific patient
  Future updatePreviousDelivery(String patientId, String deliveryId,
      DateTime year, String type, String location, bool outcome) async {
    String formattedYear = DateFormat('yyyy-MM-dd').format(year);

    return await patients
        .doc(patientId)
        .collection('Prev_Delivery') // Access the 'Prev_Delivery' subcollection
        .doc(deliveryId) // Update specific delivery document
        .set({
      'del_id': deliveryId,
      'patient_id': patientId,
      'year': formattedYear,
      'type': type,
      'location': location,
      'outcome': outcome,
    });
  }

  // Insert a new previous delivery for a specific patient
  Future insertPreviousDelivery(String patientId, DateTime year, String type,
      String location, bool outcome) async {
    String formattedYear = DateFormat('yyyy-MM-dd').format(year);

    return await patients
        .doc(patientId)
        .collection('Prev_Delivery') // Access the 'Prev_Delivery' subcollection
        .add({
      'patient_id': patientId,
      'year': formattedYear,
      'type': type,
      'location': location,
      'outcome': outcome,
    });
  }
  // Stream<QuerySnapshot> getPreviousDeliveries(String patientId) {
  //   return prevDeliveries.where('patient_id', isEqualTo: patientId).snapshots();
  // }
  // Future updatePreviousDelivery(String deliveryId, String patientId,
  //     DateTime year, String type, String location, bool outcome) async {
  //   String formattedYear = DateFormat('yyyy-MM-dd').format(year);

  //   return await prevDeliveries.doc(deliveryId).set({
  //     'del_id': deliveryId,
  //     'patient_id': patientId,
  //     'year': formattedYear,
  //     'type': type,
  //     'location': location,
  //     'outcome': outcome,
  //   });
  // }
  // Future insertPreviousDelivery(String patientId, DateTime year, String type,
  //     String location, bool outcome) async {
  //   String formattedYear = DateFormat('yyyy-MM-dd').format(year);

  //   return await prevDeliveries.add({
  //     'patient_id': patientId,
  //     'year': formattedYear,
  //     'type': type,
  //     'location': location,
  //     'outcome': outcome,
  //   });
  // }

  // // Get all Discharge Info
  // Future<void> addOrUpdateDischargeInfo(
  //     String patientId, String dischargeId, Map<String, dynamic> data) async {
  //   try {
  //     await discharges
  //         .doc(patientId)
  //         .set({'discharge_id': dischargeId, ...data}, SetOptions(merge: true));
  //   } catch (e) {
  //     throw Exception('Error saving discharge info: $e');
  //   }
  // }

  // // Add Newborn Vitals
  // Future<void> addNewbornVitals(
  //     String patientId, String dischargeId, Map<String, dynamic> data) async {
  //   try {
  //     await discharges
  //         .doc(patientId)
  //         .collection('Newborn_Vitals')
  //         .doc(dischargeId)
  //         .set(data, SetOptions(merge: true));
  //   } catch (e) {
  //     throw Exception('Error saving newborn vitals: $e');
  //   }
  // }

  // // Add Procedure
  // Future<void> addProcedure(
  //     String patientId, String dischargeId, Map<String, dynamic> data) async {
  //   try {
  //     await discharges
  //         .doc(patientId)
  //         .collection('Procedures')
  //         .add(data); // Creates a new document with auto-generated ID
  //   } catch (e) {
  //     throw Exception('Error saving procedure: $e');
  //   }
  // }

  // // Get Discharge Information
  // Future<DocumentSnapshot> getDischargeInfo(String patientId) async {
  //   try {
  //     return await discharges.doc(patientId).get();
  //   } catch (e) {
  //     throw Exception('Error retrieving discharge info: $e');
  //   }
  // }
}

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({super.key});

  @override
  _UpdateUserPageState createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  TextEditingController pidController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController medicalHistoryController = TextEditingController();
  TextEditingController gravidaController = TextEditingController();
  TextEditingController paraController = TextEditingController();
  TextEditingController abortionController = TextEditingController();
  TextEditingController relationController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();
  DateTime? selectedDate;
  bool ancConsultation = false;

  bool isUpdating = false; // Determines whether we are updating or adding
  String currentPatientId = ''; // Holds the patient ID for updating

  void populateFields(String pid) async {
    try {
      DocumentSnapshot document = await _databaseService.getUserData(pid);

      if (document.exists) {
        setState(() {
          nameController.text = document['name'] ?? '';
          addressController.text = document['address'] ?? '';
          if (document['DOB'] != null) {
            dobController.text = document['DOB'];
            DateFormat format = DateFormat("MMMM d, yyyy 'at' h:mm:ss a z");
            DateTime parsedDate = format.parse(dobController.text);
            selectedDate = parsedDate;
          } else {
            dobController.clear();
          }
          medicalHistoryController.text = document['medical_history'] ?? '';
          gravidaController.text = document['Gravida']?.toString() ?? '';
          paraController.text = document['Para']?.toString() ?? '';
          abortionController.text = document['Abortion']?.toString() ?? '';
          ancConsultation = document['ANC_consultation'] ?? false;
          relationController.text = document['relation'] ?? '';
          // pidController.text = pid;
        });
      } else {
        clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data found for this pid')),
        );
      }
    } catch (e) {
      print("Error fetching document: $e");
    }
  }

  void clearFields() {
    setState(() {
      pidController.clear();
      nameController.clear();
      addressController.clear();
      dobController.clear();
      medicalHistoryController.clear();
      gravidaController.clear();
      paraController.clear();
      abortionController.clear();
      ancConsultation = false;
      relationController.clear();
      currentPatientId = '';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dobController.text =
            '${DateFormat('MMMM d, yyyy \'at\' h:mm:ss a').format(selectedDate!.toLocal())} UTC+5';
      });
    }
  }

// add or update
  void toggleMode(bool updating) {
    setState(() {
      isUpdating = updating;
      clearFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdating ? 'Update Patient' : 'Add New Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => toggleMode(false),
                      child: const Text('Add New Patient'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => toggleMode(true),
                      child: const Text('Update Existing Patient'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isUpdating) ...{
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: pidController,
                        decoration: const InputDecoration(
                          labelText: 'Patient ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        currentPatientId = pidController.text.trim();
                        if (currentPatientId.isNotEmpty) {
                          populateFields(currentPatientId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please enter valid ID to search patient')),
                          );
                        }
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
              },
              const SizedBox(height: 20),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: medicalHistoryController,
                decoration: const InputDecoration(
                  labelText: 'Medical History',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: gravidaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Gravida',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: paraController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Para',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: abortionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Abortion',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('ANC Consultation:'),
                  Checkbox(
                    value: ancConsultation,
                    onChanged: (bool? value) {
                      setState(() {
                        ancConsultation = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(
                  labelText: 'Relation (W/O, D/O, S/O)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text.trim().toLowerCase();
                  String address = addressController.text.trim().toLowerCase();
                  String medicalHistory =
                      medicalHistoryController.text.trim().toLowerCase();
                  int gravida =
                      int.tryParse(gravidaController.text.trim()) ?? 0;
                  int para = int.tryParse(paraController.text.trim()) ?? 0;
                  int abortion =
                      int.tryParse(abortionController.text.trim()) ?? 0;
                  String relation =
                      relationController.text.trim().toLowerCase();
                  if (dobController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(!isUpdating
                              ? 'Please enter all details to add a new patient'
                              : 'Please enter all details to update patient information')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: isUpdating
                            ? Text('Updating patient data...')
                            : Text('Adding new patient...')),
                  );
                  if (isUpdating && currentPatientId.isNotEmpty) {
                    try {
                      await _databaseService.updateUserData(
                        currentPatientId,
                        name,
                        address,
                        selectedDate!,
                        medicalHistory,
                        gravida,
                        para,
                        abortion,
                        ancConsultation,
                        relation,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Patient data updated!')),
                      );
                    } catch (e) {
                      log('Error: $e'); // Log the error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to update patient data: $e')),
                      );
                    }
                  } else {
                    // Add new patient
                    currentPatientId = await _databaseService.addPatientData(
                      name,
                      address,
                      selectedDate!,
                      medicalHistory,
                      gravida,
                      para,
                      abortion,
                      ancConsultation,
                      relation,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Patient added successfully! ID: $currentPatientId')),
                    );
                  }
                },
                child: Text(isUpdating ? 'Update Patient' : 'Add Patient'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryScreen(
                        patientId: currentPatientId,
                      ),
                    ),
                  );
                },
                child: const Text('Delivery Files'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Previousdeliveries(
                        patientId: currentPatientId,
                        name: nameController.text,
                      ),
                    ),
                  );
                },
                child: const Text('Previous Deliveries'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MedicalForm(
                            patientId: currentPatientId,
                            name: nameController.text)),
                  );
                },
                child: const Text('Medical Forms'),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: ancConsultation,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AntenatalDeliveryCard(
                              patientId: currentPatientId,
                              name: nameController.text)),
                    );
                  },
                  child: const Text('ANC Card Info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MedicalFormsPage extends StatelessWidget {
//   const MedicalFormsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medical Forms'),
//       ),
//       body: const Center(
//         child: Text('Medical Forms Information'),
//       ),
//     );
//   }
// }

class CardInfoPage extends StatelessWidget {
  const CardInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Info'),
      ),
      body: const Center(
        child: Text('Card Info Details'),
      ),
    );
  }
}

class VaginalExaminationsPage extends StatelessWidget {
  const VaginalExaminationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaginal Examinations'),
      ),
      body: const Center(
        child: Text('Vaginal Examinations Information'),
      ),
    );
  }
}
