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
  TextEditingController dischargeIdController = TextEditingController();
  TextEditingController dischargeDateController = TextEditingController();
  TextEditingController lengthOfStayController = TextEditingController();
  TextEditingController modeController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  bool uterusContracted = false;
  bool lochiaNormal = false;
  bool hepatitisBStatus = false;

  _selectDate(BuildContext context) async {
    // Function for selecting date (for discharge date or delivery year)
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

  Future<void> addDischargeInfo(
      // Saving discharge info to Firestore (under deliveryfiles subcollection)
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
      String ferrousSulphate,
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
        'ferrousSulphate': ferrousSulphate,
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

  Future<void> updateDischargeInfo(
      String patientid,
      String docid,
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
      String ferrousSulphate,
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
          .doc(docid)
          .set({
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
        'ferrousSulphate': ferrousSulphate,
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
                TextField(
                  controller: dischargeIdController,
                  decoration: const InputDecoration(labelText: 'Discharge ID'),
                ),
                TextField(
                  controller: lengthOfStayController,
                  decoration:
                      const InputDecoration(labelText: 'Length of Stay'),
                ),
                TextField(
                  controller: modeController,
                  decoration: const InputDecoration(labelText: 'Mode'),
                ),

                CheckboxListTile(
                  value: hepatitisBStatus,
                  onChanged: (val) => setState(() => hepatitisBStatus = val!),
                  title: const Text('Hepatitis B Status'),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     await addDischargeInfo(
                //       widget.patientId,
                //       dischargeIdController.text,
                //       dischargeDateController.text,
                //       lengthOfStayController.text,
                //       modeController.text,
                //       hepatitisBStatus.toString(),
                //     );
                //   },
                //   child: const Text('Save Discharge Information'),
                // ),
                const Divider(),
                const Text(
                  'Previous Deliveries',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _databaseService
                      .getPreviousDeliveryFiles(widget.patientId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('No Previous Deliveries Found'));
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!.docs.map((doc) {
                          // Local state for checkbox and controllers
                          String docid = doc.id;
                          var controllers = {
                            'dischargedate': TextEditingController(
                                text: doc['dischargeDate']),
                            'dischargeId':
                                TextEditingController(text: doc['dischargeId']),
                            'lengthOfStay': TextEditingController(
                                text: doc['lengthOfStay']),
                            'mode': TextEditingController(text: doc['mode']),
                            'dischargeDoneBy': TextEditingController(
                                text: doc['dischargeDoneBy']),
                            'motherBP':
                                TextEditingController(text: doc['motherBP']),
                            'motherTemp':
                                TextEditingController(text: doc['motherTemp']),
                            'motherPulse':
                                TextEditingController(text: doc['motherPulse']),
                            'specialRecommendations': TextEditingController(
                                text: doc['specialRecommendations']),
                            'newbornTemp':
                                TextEditingController(text: doc['newbornTemp']),
                            'newbornPulse': TextEditingController(
                                text: doc['newbornPulse']),
                          };

                          String selectedProcedureupdate =
                              doc['selectedProcedure'];
                          String selectedDiagnosisupdate =
                              doc['selectedDiagnosis'];

                          var checkboxes = <String, bool>{
                            'passedUrine': doc['passedUrine'] ==
                                'true', // Convert 'true' or 'false' string to boolean
                            'uterusContracted':
                                doc['uterusContracted'] == 'true',
                            'lochiaNormal': doc['lochiaNormal'] == 'true',
                            'postnatalCare': doc['postnatalCare'] == 'true',
                            'ferrousSulphate': doc['ferrousSulphate'] == 'true',
                            'familyPlanning': doc['familyPlanning'] == 'true',
                            'exclusiveBreast': doc['exclusiveBreast'] == 'true',
                            'lowBirthWeight': doc['lowBirthWeight'] == 'true',
                            'dangerSign': doc['dangerSign'] == 'true',
                            'newbornPassedStool':
                                doc['newbornPassedStool'] == 'true',
                            'newbornPassedUrine':
                                doc['newbornPassedUrine'] == 'true',
                            'breastfeedingStatus':
                                doc['breastfeedingStatus'] == 'true',
                            'hepatitisBStatus':
                                doc['hepatitisBStatus'] == 'true',
                          };

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: controllers['dischargedate'],
                                      decoration: const InputDecoration(
                                          labelText: 'Date of Delivery'),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: controllers['dischargeId'],
                                      decoration: const InputDecoration(
                                          labelText: 'Discharge ID'),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: controllers['lengthOfStay'],
                                      decoration: const InputDecoration(
                                          labelText: 'Length of Stay'),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: controllers['mode'],
                                      decoration: const InputDecoration(
                                          labelText: 'Mode'),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller:
                                          controllers['dischargeDoneBy'],
                                      decoration: const InputDecoration(
                                          labelText: 'Discharge Done By'),
                                    ),
                                    const Divider(),
                                    const Text('Mother Information',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    TextField(
                                      controller: controllers['motherBP'],
                                      decoration: const InputDecoration(
                                          labelText: 'Blood Pressure'),
                                    ),
                                    TextField(
                                      controller: controllers['motherTemp'],
                                      decoration: const InputDecoration(
                                          labelText: 'Temperature'),
                                    ),
                                    TextField(
                                      controller: controllers['motherPulse'],
                                      decoration: const InputDecoration(
                                          labelText: 'Pulse Rate'),
                                    ),
                                    buildCheckboxListTile(
                                      value: checkboxes['passedUrine'] ?? false,
                                      label: 'Passed Urine',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['passedUrine'] = val!),
                                    ),
                                    buildCheckboxListTile(
                                      value: checkboxes['uterusContracted'] ??
                                          false,
                                      label: 'Uterus Contracted',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['uterusContracted'] =
                                              val!),
                                    ),
                                    buildCheckboxListTile(
                                      value:
                                          checkboxes['lochiaNormal'] ?? false,
                                      label: 'Lochia Normal',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['lochiaNormal'] = val!),
                                    ),
                                    const Divider(),
                                    const Text('Health Education',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    buildCheckboxListTile(
                                      value:
                                          checkboxes['postnatalCare'] ?? false,
                                      label: 'Postnatal Care',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['postnatalCare'] = val!),
                                    ),
                                    buildCheckboxListTile(
                                      value:
                                          checkboxes['familyPlanning'] ?? false,
                                      label: 'Family Planning',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['familyPlanning'] = val!),
                                    ),
                                    buildCheckboxListTile(
                                      value: checkboxes['exclusiveBreast'] ??
                                          false,
                                      label: 'Exclusive Breastfeeding',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['exclusiveBreast'] = val!),
                                    ),
                                    buildCheckboxListTile(
                                      value:
                                          checkboxes['lowBirthWeight'] ?? false,
                                      label: 'Low Birth Weight',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['lowBirthWeight'] = val!),
                                    ),
                                    buildCheckboxListTile(
                                      value: checkboxes['dangerSign'] ?? false,
                                      label: 'Danger Sign',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['dangerSign'] = val!),
                                    ),
                                    TextField(
                                      controller:
                                          controllers['specialRecommendations'],
                                      decoration: const InputDecoration(
                                          labelText: 'Special Recommendations'),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text('Performed Procedure',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    // Dropdown for Procedure

                                    const Divider(),
                                    const Text('Treatment at Home',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    TextField(
                                      controller:
                                          controllers['ferrousSulphate'],
                                      decoration: const InputDecoration(
                                          labelText: 'Ferrous Sulphate'),
                                    ),
                                    const Divider(),
                                    const Text('Newborn Vitals',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    // Newborn vitals
                                    TextField(
                                      controller: controllers['newbornTemp'],
                                      decoration: const InputDecoration(
                                          labelText: 'Newborn Temperature'),
                                    ),
                                    TextField(
                                      controller: controllers['newbornPulse'],
                                      decoration: const InputDecoration(
                                          labelText: 'Newborn Pulse'),
                                    ),
                                    // Checkbox rows for Newborn info
                                    buildCheckboxListTile(
                                      value: checkboxes['newbornPassedUrine'] ??
                                          false,
                                      label: 'Newborn Passed Urine',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['newbornPassedUrine'] =
                                              val!),
                                    ),
                                    buildCheckboxListTile(
                                      value: checkboxes['newbornPassedStool'] ??
                                          false,
                                      label: 'Newborn Passed Stool',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['newbornPassedStool'] =
                                              val!),
                                    ),
                                    buildCheckboxListTile(
                                      value: checkboxes['hepatitisBStatus'] ??
                                          false,
                                      label: 'Hepatitis B Status',
                                      onChanged: (val) => setState(() =>
                                          checkboxes['hepatitisBStatus'] =
                                              val!),
                                    ),

                                    ElevatedButton(
                                      onPressed: () async {
                                        await updateDischargeInfo(
                                          widget.patientId,
                                          docid,
                                          controllers['dischargeId']?.text ??
                                              '',
                                          controllers['dischargedate']?.text ??
                                              '',
                                          controllers['lengthOfStay']?.text ??
                                              '',
                                          controllers['mode']?.text ?? '',
                                          controllers['dischargeDoneBy']
                                                  ?.text ??
                                              '',
                                          controllers['motherBP']?.text ?? '',
                                          controllers['motherTemp']?.text ?? '',
                                          controllers['motherPulse']?.text ??
                                              '',
                                          (checkboxes['passedUrine'] ?? false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['uterusContracted'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['lochiaNormal'] ?? false)
                                              ? 'true'
                                              : 'false',
                                          controllers['specialRecommendations']
                                                  ?.text ??
                                              '',
                                          selectedProcedureupdate,
                                          selectedDiagnosisupdate,
                                          (checkboxes['postnatalCare'] ?? false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['ferrousSulphate'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['familyPlanning'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['exclusiveBreast'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['lowBirthWeight'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['dangerSign'] ?? false)
                                              ? 'true'
                                              : 'false',
                                          controllers['newbornTemp']?.text ??
                                              '',
                                          controllers['newbornPulse']?.text ??
                                              '',
                                          (checkboxes['newbornPassedStool'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['newbornPassedUrine'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['breastfeedingStatus'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                          (checkboxes['hepatitisBStatus'] ??
                                                  false)
                                              ? 'true'
                                              : 'false',
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Previous Delivery File Updated Successfully!')),
                                        );
                                      },
                                      child: const Text('Update Delivery'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }
}

Widget buildCheckboxListTile({
  required bool value,
  required String label,
  required ValueChanged<bool?> onChanged,
}) {
  return CheckboxListTile(
    value: value,
    onChanged: onChanged,
    title: Text(label),
  );
}

Widget _buildDropdown(String selectedValue, String label, List<String> items,
    Function onChanged) {
  return DropdownButtonFormField<String>(
    value: selectedValue.isEmpty ? null : selectedValue,
    items: items
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList(),
    onChanged: (value) {
      onChanged(value);
    },
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}
