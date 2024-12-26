// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:imkaan/services/db.dart';
// import 'package:intl/intl.dart';

// class PreviousDeliveryPage extends StatefulWidget {
//   final String patientId;

//   const PreviousDeliveryPage({super.key, required this.patientId});

//   @override
//   State<PreviousDeliveryPage> createState() => _PreviousDeliveryPageState();
// }

// class _PreviousDeliveryPageState extends State<PreviousDeliveryPage> {
//   final DatabaseService _databaseService = DatabaseService();

//   final TextEditingController yearController = TextEditingController();
//   final TextEditingController typeController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController dischargeIdController = TextEditingController();
//   final TextEditingController dischargeDateController = TextEditingController();
//   final TextEditingController lengthOfStayController = TextEditingController();
//   final TextEditingController modeController = TextEditingController();
//   final TextEditingController diagnosisController = TextEditingController();
//   final TextEditingController dischargeDoneByController =
//       TextEditingController();
//   final TextEditingController motherBPController = TextEditingController();
//   final TextEditingController motherTempController = TextEditingController();
//   final TextEditingController motherPulseController = TextEditingController();
//   final TextEditingController specialRecommendationsController =
//       TextEditingController();

//   bool outcome = false;//successful delivery or not successful
//     // Dropdown options for Procedures and Diagnosis
//   String selectedProcedure = '';
//   String selectedDiagnosis = '';

//   final List<String> procedures = [
//     'Induction of Labour',
//     'Augmentation of Labour',
//     'Manual Removal Placenta',
//     'New Born Resuscitation',
//     'Mother Resuscitation',
//     'Episiotomy',
//     'Suture of Cervical Tear',
//     'MVA',
//     'Other'
//   ];

//   final List<String> diagnoses = [
//     'Delivery No Complication',
//     'Prolong Labour',
//     'Obstructed Labour',
//     'APH',
//     'PPH',
//     'Pre Eclampsia',
//     'Eclampsia',
//     'Abortion',
//     'Other'
//   ];
// // Booleans for Discharge Information
//   bool uterusContracted = false;
//   bool passedUrine = false;
//   bool lochiaNormal = false;
//   bool postnatalCare = false;
//   bool familyPlanning = false;
//   bool exclusiveBreast = false;
//   bool lowBirthWeight = false;
//   bool dangerSign = false;
//   bool ferrousSulphate = false;
//   bool amoxicillin = false;

//   // Newborn Vitals Controllers
//   final TextEditingController newbornTempController = TextEditingController();
//   final TextEditingController newbornPulseController = TextEditingController();
//   bool newbornPassedStool = false;
//   bool newbornPassedUrine = false;
//   bool breastfeedingStatus = false;
//   bool hepatitisBStatus = false;

//   // Procedure Controller
//   final TextEditingController procedureController = TextEditingController();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         yearController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//       });
//     }
//   }

//   void saveDischargeInfo() async {
//     if (dischargeIdController.text.isEmpty ||
//         dischargeDateController.text.isEmpty ||
//         lengthOfStayController.text.isEmpty ||
//         diagnosisController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content:
//                 Text('All required fields in Discharge Info are missing.')),
//       );
//       return;
//     }

//     Map<String, dynamic> dischargeData = {
//       'discharge_id': dischargeIdController.text.trim(),
//       'DischargeDate': dischargeDateController.text.trim(),
//       'LengthOfStay': int.tryParse(lengthOfStayController.text.trim()) ?? 0,
//       'mode': modeController.text.trim(),
//       'DiagnosisAtExit': selectedDiagnosis,
//       'DischargeDoneBy': dischargeDoneByController.text.trim(),
//       'Mother_BP': motherBPController.text.trim(),
//       'Mother_temp': motherTempController.text.trim(),
//       'Mother_Pulse': motherPulseController.text.trim(),
//       'UterusContracted': uterusContracted,
//       'PassedUrine': passedUrine,
//       'LochiaNormal': lochiaNormal,
//       'PostnatalCare': postnatalCare,
//       'FamilyPlanning': familyPlanning,
//       'ExclusiveBreast': exclusiveBreast,
//       'LowBirthWeight': lowBirthWeight,
//       'DangerSign': dangerSign,
//       'FerrousSulphate': ferrousSulphate,
//       'Amoxicillin': amoxicillin,
//       'SpecialRecommendations': specialRecommendationsController.text.trim(),
//       'PerformedProcedure': selectedProcedure,
//     };

//     try {
//       await _databaseService.addOrUpdateDischargeInfo(
//           widget.patientId, dischargeIdController.text.trim(), dischargeData);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Discharge Information Saved.')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save discharge information: $e')),
//       );
//     }
//   }
//   void saveNewbornVitals() async {
//     if (newbornTempController.text.isEmpty ||
//         newbornPulseController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Newborn Vitals are required.')),
//       );
//       return;
//     }

//     Map<String, dynamic> vitalsData = {
//       'NewbornTemperature': newbornTempController.text.trim(),
//       'NewbornPulse': newbornPulseController.text.trim(),
//       'Newborn_PassedStool': newbornPassedStool,
//       'Newborn_PassedUrine': newbornPassedUrine,
//       'breast_feeding_status': breastfeedingStatus,
//       'Hepatitis_B_status': hepatitisBStatus,
//     };

//     try {
//       await _databaseService.addNewbornVitals(
//           widget.patientId, dischargeIdController.text.trim(), vitalsData);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Newborn Vitals Saved.')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save newborn vitals: $e')),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     // Check if patientId is empty, if so, show a message
//     if (widget.patientId.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Delivery Files'),
//         ),
//         body: const Center(
//           child: Text(
//             'Please select a patient or add a patient to add or update deliveries files information.',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       );
//     }

//     // Normal flow when patientId is not empty
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Previous Deliveries'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Add New Delivery: ',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: yearController,
//                   readOnly: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Year',
//                     border: OutlineInputBorder(),
//                   ),
//                   onTap: () => _selectDate(context),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: typeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Type',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: locationController,
//                   decoration: const InputDecoration(
//                     labelText: 'Location',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Outcome:'),
//                     Checkbox(
//                       value: outcome,
//                       onChanged: (bool? value) {
//                         setState(() {
//                           outcome = value ?? false;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await _databaseService.insertPreviousDelivery(
//                       widget.patientId,
//                       DateTime.parse(yearController.text),
//                       typeController.text,
//                       locationController.text,
//                       outcome,
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('New Delivery Added Successfully!')),
//                     );
//                     setState(() {
//                       yearController.clear();
//                       typeController.clear();
//                       locationController.clear();
//                       outcome = false;
//                     });
//                   },
//                   child: const Text('Add Delivery'),
//                 ),

//               ],
//             ),
//           ),
//           const Divider(),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _databaseService.getPreviousDeliveries(widget.patientId),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Text('No Previous Deliveries Found'),
//                   );
//                 }

//                 return ListView(
//                   children: snapshot.data!.docs.map((doc) {
//                     // Local state for checkbox
//                     bool outcomeUpdate =
//                         doc['outcome']; // Get outcome from Firestore
//                     TextEditingController yearUpdateController =
//                         TextEditingController(text: doc['year']);
//                     TextEditingController typeUpdateController =
//                         TextEditingController(text: doc['type']);
//                     TextEditingController locationUpdateController =
//                         TextEditingController(text: doc['location']);

//                     return StatefulBuilder(
//                       builder: (context, setState) {
//                         return Card(
//                           margin: const EdgeInsets.all(10),
//                           child: Column(
//                             children: [
//                               TextField(
//                                 controller: yearUpdateController,
//                                 decoration:
//                                     const InputDecoration(labelText: 'Year'),
//                               ),
//                               TextField(
//                                 controller: typeUpdateController,
//                                 decoration:
//                                     const InputDecoration(labelText: 'Type'),
//                               ),
//                               TextField(
//                                 controller: locationUpdateController,
//                                 decoration: const InputDecoration(
//                                     labelText: 'Location'),
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text('Outcome:'),
//                                   Checkbox(
//                                     value: outcomeUpdate,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         outcomeUpdate = value ?? false;
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   await _databaseService.updatePreviousDelivery(
//                                     widget.patientId,
//                                     doc.id,
//                                     DateTime.parse(yearUpdateController.text),
//                                     typeUpdateController.text,
//                                     locationUpdateController.text,
//                                     outcomeUpdate, // Pass updated outcome
//                                   );
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             'Previous Delivery Updated Successfully!')),
//                                   );
//                                 },
//                                 child: const Text('Update Delivery'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imkaan/services/db.dart';
import 'package:intl/intl.dart';

class DeliveryScreen extends StatefulWidget {
  final String patientId;

  const DeliveryScreen({required this.patientId});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  // Controllers for text fields
  // Controllers for text fields
  TextEditingController dischargeIdController = TextEditingController();
  TextEditingController dischargeDateController = TextEditingController();
  TextEditingController lengthOfStayController = TextEditingController();
  TextEditingController modeController = TextEditingController();
  TextEditingController dischargeDoneByController = TextEditingController();
  TextEditingController motherBPController = TextEditingController();
  TextEditingController motherTempController = TextEditingController();
  TextEditingController motherPulseController = TextEditingController();
  TextEditingController specialRecommendationsController =
      TextEditingController();
  TextEditingController newbornTempController = TextEditingController();
  TextEditingController newbornPulseController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  // Controllers for updating existing delivery info
  TextEditingController yearUpdateController = TextEditingController();
  TextEditingController typeUpdateController = TextEditingController();
  TextEditingController locationUpdateController = TextEditingController();
  TextEditingController lengthOfStayUpdateController = TextEditingController();
  TextEditingController modeUpdateController = TextEditingController();
  TextEditingController dischargeDoneByUpdateController =
      TextEditingController();
  TextEditingController motherBPUpdateController = TextEditingController();
  TextEditingController motherTempUpdateController = TextEditingController();
  TextEditingController motherPulseUpdateController = TextEditingController();
  TextEditingController specialRecommendationsUpdateController =
      TextEditingController();
  TextEditingController newbornTempUpdateController = TextEditingController();
  TextEditingController newbornPulseUpdateController = TextEditingController();

  // Checkbox values for boolean information
  bool passedUrine = false;
  bool uterusContracted = false;
  bool lochiaNormal = false;
  bool postnatalCare = false;
  bool familyPlanning = false;
  bool exclusiveBreast = false;
  bool lowBirthWeight = false;
  bool dangerSign = false;
  bool newbornPassedStool = false;
  bool newbornPassedUrine = false;
  bool breastfeedingStatus = false;
  bool hepatitisBStatus = false;

  // Update Checkbox values for boolean information
  bool passedUrineUpdate = false;
  bool uterusContractedUpdate = false;
  bool lochiaNormalUpdate = false;
  bool postnatalCareUpdate = false;
  bool familyPlanningUpdate = false;
  bool exclusiveBreastUpdate = false;
  bool lowBirthWeightUpdate = false;
  bool dangerSignUpdate = false;
  bool newbornPassedStoolUpdate = false;
  bool newbornPassedUrineUpdate = false;
  bool breastfeedingStatusUpdate = false;
  bool hepatitisBStatusUpdate = false;

  String selectedProcedure = '';
  String selectedDiagnosis = '';
  final List<String> procedures = [
    'Induction of Labour',
    'Augmentation of Labour',
    'Manual Removal Placenta',
    'New Born Resuscitation',
    'Mother Resuscitation',
    'Episiotomy',
    'Suture of Cervical Tear',
    'MVA',
    'Other'
  ];

  final List<String> diagnoses = [
    'Delivery No Complication',
    'Prolong Labour',
    'Obstructed Labour',
    'APH',
    'PPH',
    'Pre Eclampsia',
    'Eclampsia',
    'Abortion',
    'Other'
  ];

  // Function for selecting date (for discharge date or delivery year)
  _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        dischargeDateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  // Saving discharge info to Firestore (under deliveryfiles subcollection)
  Future<void> addDischargeInfo(
      String patientid,
      String dischargeId,
      String dischargeDate,
      String lengthOfStay,
      String mode,
      String dischargeDoneBy,
      String motherBP,
      String motherTemp,
      String motherPulse,
      String passedUrine,
      String uterusContracted,
      String lochiaNormal,
      String specialRecommendations,
      String selectedProcedure,
      String selectedDiagnosis,
      String postnatalCare,
      String familyPlanning,
      String exclusiveBreast,
      String lowBirthWeight,
      String dangerSign,
      String newbornTemp,
      String newbornPulse,
      String newbornPassedStool,
      String newbornPassedUrine,
      String breastfeedingStatus,
      String hepatitisBStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientid)
          .collection('deliveryfiles')
          .add({
        'dischargeId': dischargeId,
        'dischargeDate': dischargeDate,
        'lengthOfStay': lengthOfStay,
        'mode': mode,
        'dischargeDoneBy': dischargeDoneBy,
        'motherBP': motherBP,
        'motherTemp': motherTemp,
        'motherPulse': motherPulse,
        'passedUrine': passedUrine,
        'uterusContracted': uterusContracted,
        'lochiaNormal': lochiaNormal,
        'specialRecommendations': specialRecommendations,
        'selectedProcedure': selectedProcedure,
        'selectedDiagnosis': selectedDiagnosis,
        'postnatalCare': postnatalCare,
        'familyPlanning': familyPlanning,
        'exclusiveBreast': exclusiveBreast,
        'lowBirthWeight': lowBirthWeight,
        'dangerSign': dangerSign,
        'newbornTemp': newbornTemp,
        'newbornPulse': newbornPulse,
        'newbornPassedStool': newbornPassedStool,
        'newbornPassedUrine': newbornPassedUrine,
        'breastfeedingStatus': breastfeedingStatus,
        'hepatitisBStatus': hepatitisBStatus,
      }); // Merge ensures existing data is updated

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Delivery information saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if patientId is empty, if so, show a message
    if (widget.patientId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Delivery Files'),
        ),
        body: const Center(
          child: Text(
            'Please select a patient or add a patient to add or update deliveries files information.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Delivery'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Delivery:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Discharge Date Picker
              TextField(
                controller: dischargeDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Delivery',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),
              // Discharge ID
              TextField(
                controller: dischargeIdController,
                decoration: const InputDecoration(labelText: 'Discharge ID'),
              ),
              // Length of Stay
              TextField(
                controller: lengthOfStayController,
                decoration: const InputDecoration(labelText: 'Length of Stay'),
              ),
              // Mode
              TextField(
                controller: modeController,
                decoration: const InputDecoration(labelText: 'Mode'),
              ),
              // Discharge Done By
              TextField(
                controller: dischargeDoneByController,
                decoration:
                    const InputDecoration(labelText: 'Discharge Done By'),
              ),
              const Divider(),
              const Text(
                'Mother Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Mother Info: Blood Pressure, Temperature, Pulse Rate
              TextField(
                controller: motherBPController,
                decoration: const InputDecoration(labelText: 'Blood Pressure'),
              ),
              TextField(
                controller: motherTempController,
                decoration: const InputDecoration(labelText: 'Temperature'),
              ),
              TextField(
                controller: motherPulseController,
                decoration: const InputDecoration(labelText: 'Pulse Rate'),
              ),
              // Checkbox for various conditions
              CheckboxListTile(
                value: passedUrine,
                onChanged: (val) => setState(() => passedUrine = val!),
                title: const Text('Passed Urine'),
              ),
              CheckboxListTile(
                value: uterusContracted,
                onChanged: (val) => setState(() => uterusContracted = val!),
                title: const Text('Uterus Contracted'),
              ),
              CheckboxListTile(
                value: lochiaNormal,
                onChanged: (val) => setState(() => lochiaNormal = val!),
                title: const Text('Lochia Normal'),
              ),
              const Divider(),
              const Text(
                'Health Education',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Health education checkboxes
              CheckboxListTile(
                value: postnatalCare,
                onChanged: (val) => setState(() => postnatalCare = val!),
                title: const Text('Postnatal Care'),
              ),
              CheckboxListTile(
                value: familyPlanning,
                onChanged: (val) => setState(() => familyPlanning = val!),
                title: const Text('Family Planning'),
              ),
              CheckboxListTile(
                value: exclusiveBreast,
                onChanged: (val) => setState(() => exclusiveBreast = val!),
                title: const Text('Exclusive Breastfeeding'),
              ),
              CheckboxListTile(
                value: lowBirthWeight,
                onChanged: (val) => setState(() => lowBirthWeight = val!),
                title: const Text('Low Birth Weight'),
              ),
              CheckboxListTile(
                value: dangerSign,
                onChanged: (val) => setState(() => dangerSign = val!),
                title: const Text('Danger Sign'),
              ),
              // Special Recommendations
              TextField(
                controller: specialRecommendationsController,
                decoration:
                    const InputDecoration(labelText: 'Special Recommendations'),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Performed Procedure',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Procedure Dropdown
              DropdownButtonFormField<String>(
                value: selectedProcedure.isEmpty ? null : selectedProcedure,
                items: procedures
                    .map((procedure) => DropdownMenuItem(
                          value: procedure,
                          child: Text(procedure),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProcedure = value ?? '';
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Procedure',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Diagnosis at Exit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Diagnosis Dropdown
              DropdownButtonFormField<String>(
                value: selectedDiagnosis.isEmpty ? null : selectedDiagnosis,
                items: diagnoses
                    .map((diagnosis) => DropdownMenuItem(
                          value: diagnosis,
                          child: Text(diagnosis),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDiagnosis = value ?? '';
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Diagnosis',
                  border: OutlineInputBorder(),
                ),
              ),
              const Divider(),
              const Text(
                'Treatment at Home',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Treatment at Home checkbox
              CheckboxListTile(
                value: postnatalCare,
                onChanged: (val) => setState(() => postnatalCare = val!),
                title: const Text('Ferrous Sulphate'),
              ),
              const Divider(),
              const Text(
                'Newborn Vitals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // Newborn Vitals inputs
              TextField(
                controller: newbornTempController,
                decoration:
                    const InputDecoration(labelText: 'Newborn Temperature'),
              ),
              TextField(
                controller: newbornPulseController,
                decoration: const InputDecoration(labelText: 'Newborn Pulse'),
              ),
              // Newborn passed stool checkbox
              CheckboxListTile(
                value: newbornPassedStool,
                onChanged: (val) => setState(() => newbornPassedStool = val!),
                title: const Text('Newborn Passed Stool'),
              ),
              // Save Discharge Info button
              ElevatedButton(
                onPressed: () async {
                  await addDischargeInfo(
                    widget.patientId,
                    dischargeIdController.text,
                    dischargeDateController.text,
                    lengthOfStayController.text,
                    modeController.text,
                    dischargeDoneByController.text,
                    motherBPController.text,
                    motherTempController.text,
                    motherPulseController.text,
                    passedUrine.toString(),
                    uterusContracted.toString(),
                    lochiaNormal.toString(),
                    specialRecommendationsController.text,
                    selectedProcedure,
                    selectedDiagnosis,
                    postnatalCare.toString(),
                    familyPlanning.toString(),
                    exclusiveBreast.toString(),
                    lowBirthWeight.toString(),
                    dangerSign.toString(),
                    newbornTempController.text,
                    newbornPulseController.text,
                    newbornPassedStool.toString(),
                    newbornPassedUrine.toString(),
                    breastfeedingStatus.toString(),
                    hepatitisBStatus.toString(),
                  );
                },
                child: const Text('Save Discharge Information'),
              ),

              // // Save Newborn Vitals button
              // ElevatedButton(
              //   onPressed: saveNewbornVitals,
              //   child: const Text('Save Newborn Vitals'),
              // ),
              const Divider(),
              // StreamBuilder to display previous deliveries
              const SizedBox(height: 20),
              const Text(
                'Previous Deliveries',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    _databaseService.getPreviousDeliveries(widget.patientId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No Previous Deliveries Found'));
                  }

                  return ListView(
                    shrinkWrap: true, // Ensures that the list does not overflow
                    children: snapshot.data!.docs.map((doc) {
                      return ListTile(
                        title: Text('Delivery Info ${doc.id}'),
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
                            // return ListView(
                            //   children: snapshot.data!.docs.map((doc) {
                            //     // Create TextEditingControllers and checkbox values
                            //     var controllers = {
                            //       'year':
                            //           TextEditingController(text: doc['year']),
                            //       'type':
                            //           TextEditingController(text: doc['type']),
                            //       'location': TextEditingController(
                            //           text: doc['location']),
                            //       'lengthOfStay': TextEditingController(
                            //           text: doc['lengthOfStay']),
                            //       'mode':
                            //           TextEditingController(text: doc['mode']),
                            //       'dischargeDoneBy': TextEditingController(
                            //           text: doc['dischargeDoneBy']),
                            //       'motherBP': TextEditingController(
                            //           text: doc['motherBP']),
                            //       'motherTemp': TextEditingController(
                            //           text: doc['motherTemp']),
                            //       'motherPulse': TextEditingController(
                            //           text: doc['motherPulse']),
                            //       'specialRecommendations': TextEditingController(
                            //           text: doc['specialRecommendations']),
                            //       'newbornTemp': TextEditingController(
                            //           text: doc['newbornTemp']),
                            //       'newbornPulse': TextEditingController(
                            //           text: doc['newbornPulse']),
                            //     };

                            //     var checkboxes = {
                            //       'outcome': doc['outcome'],
                            //       'postnatalCare': doc['postnatalCare'],
                            //       'familyPlanning': doc['familyPlanning'],
                            //       'exclusiveBreast': doc['exclusiveBreast'],
                            //       'lowBirthWeight': doc['lowBirthWeight'],
                            //       'dangerSign': doc['dangerSign'],
                            //       'newbornPassedStool': doc['newbornPassedStool'],
                            //       'newbornPassedUrine': doc['newbornPassedUrine'],
                            //       'breastfeedingStatus':
                            //           doc['breastfeedingStatus'],
                            //     };

                            //     return ListTile(
                            //       title: Text('Delivery Info ${doc.id}'),
                            //     );
                            //   }).toList(),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
