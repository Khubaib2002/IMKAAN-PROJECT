import 'package:flutter/material.dart';
import 'package:imkaan/services/db.dart';
import 'package:intl/intl.dart';

class DischargeInformationPage extends StatefulWidget {
  final String patientId;

  const DischargeInformationPage({super.key, required this.patientId});

  @override
  _DischargeInformationPageState createState() =>
      _DischargeInformationPageState();
}

class _DischargeInformationPageState extends State<DischargeInformationPage> {
  final DatabaseService _dischargeService = DatabaseService();

  // Discharge Information Controllers
  final TextEditingController dischargeIdController = TextEditingController();
  final TextEditingController dischargeDateController = TextEditingController();
  final TextEditingController lengthOfStayController = TextEditingController();
  final TextEditingController modeController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController dischargeDoneByController =
      TextEditingController();
  final TextEditingController motherBPController = TextEditingController();
  final TextEditingController motherTempController = TextEditingController();
  final TextEditingController motherPulseController = TextEditingController();
  final TextEditingController specialRecommendationsController =
      TextEditingController();

  // Dropdown options for Procedures and Diagnosis
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

  // Booleans for Discharge Information
  bool uterusContracted = false;
  bool passedUrine = false;
  bool lochiaNormal = false;
  bool postnatalCare = false;
  bool familyPlanning = false;
  bool exclusiveBreast = false;
  bool lowBirthWeight = false;
  bool dangerSign = false;
  bool ferrousSulphate = false;
  bool amoxicillin = false;

  // Newborn Vitals Controllers
  final TextEditingController newbornTempController = TextEditingController();
  final TextEditingController newbornPulseController = TextEditingController();
  bool newbornPassedStool = false;
  bool newbornPassedUrine = false;
  bool breastfeedingStatus = false;
  bool hepatitisBStatus = false;

  // Procedure Controller
  final TextEditingController procedureController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dischargeDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void saveDischargeInfo() async {
    if (dischargeIdController.text.isEmpty ||
        dischargeDateController.text.isEmpty ||
        lengthOfStayController.text.isEmpty ||
        diagnosisController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('All required fields in Discharge Info are missing.')),
      );
      return;
    }

    Map<String, dynamic> dischargeData = {
      'discharge_id': dischargeIdController.text.trim(),
      'DischargeDate': dischargeDateController.text.trim(),
      'LengthOfStay': int.tryParse(lengthOfStayController.text.trim()) ?? 0,
      'mode': modeController.text.trim(),
      'DiagnosisAtExit': selectedDiagnosis,
      'DischargeDoneBy': dischargeDoneByController.text.trim(),
      'Mother_BP': motherBPController.text.trim(),
      'Mother_temp': motherTempController.text.trim(),
      'Mother_Pulse': motherPulseController.text.trim(),
      'UterusContracted': uterusContracted,
      'PassedUrine': passedUrine,
      'LochiaNormal': lochiaNormal,
      'PostnatalCare': postnatalCare,
      'FamilyPlanning': familyPlanning,
      'ExclusiveBreast': exclusiveBreast,
      'LowBirthWeight': lowBirthWeight,
      'DangerSign': dangerSign,
      'FerrousSulphate': ferrousSulphate,
      'Amoxicillin': amoxicillin,
      'SpecialRecommendations': specialRecommendationsController.text.trim(),
      'PerformedProcedure': selectedProcedure,
    };

    try {
      await _dischargeService.addOrUpdateDischargeInfo(
          widget.patientId, dischargeIdController.text.trim(), dischargeData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Discharge Information Saved.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save discharge information: $e')),
      );
    }
  }

  // void saveProcedure() async {
  //   if (procedureController.text.isEmpty ||
  //       dischargeIdController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Procedure details are required.')),
  //     );
  //     return;
  //   }

  //   Map<String, dynamic> procedureData = {
  //     'PerformedProcedure': procedureController.text.trim(),
  //     'discharge_id': dischargeIdController.text.trim(),
  //   };

  //   try {
  //     await _dischargeService.addProcedure(
  //         widget.patientId, dischargeIdController.text.trim(), procedureData);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Procedure Saved.')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to save procedure: $e')),
  //     );
  //   }
  // }

  void saveNewbornVitals() async {
    if (newbornTempController.text.isEmpty ||
        newbornPulseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Newborn Vitals are required.')),
      );
      return;
    }

    Map<String, dynamic> vitalsData = {
      'NewbornTemperature': newbornTempController.text.trim(),
      'NewbornPulse': newbornPulseController.text.trim(),
      'Newborn_PassedStool': newbornPassedStool,
      'Newborn_PassedUrine': newbornPassedUrine,
      'breast_feeding_status': breastfeedingStatus,
      'Hepatitis_B_status': hepatitisBStatus,
    };

    try {
      await _dischargeService.addNewbornVitals(
          widget.patientId, dischargeIdController.text.trim(), vitalsData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Newborn Vitals Saved.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save newborn vitals: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discharge Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Discharge Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: dischargeIdController,
              decoration: const InputDecoration(labelText: 'Discharge ID'),
            ),
            TextField(
              controller: dischargeDateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Discharge Date'),
              onTap: () => _selectDate(context),
            ),
            TextField(
              controller: lengthOfStayController,
              decoration: const InputDecoration(labelText: 'Length of Stay'),
            ),
            TextField(
              controller: modeController,
              decoration: const InputDecoration(labelText: 'Mode'),
            ),
            TextField(
              controller: dischargeDoneByController,
              decoration: const InputDecoration(labelText: 'Discharge Done By'),
            ),
            const Divider(),
            const Text(
              'Mother Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
            CheckboxListTile(
              value: ferrousSulphate,
              onChanged: (val) => setState(() => ferrousSulphate = val!),
              title: const Text('Ferrous Sulphate'),
            ),
            CheckboxListTile(
              value: amoxicillin,
              onChanged: (val) => setState(() => amoxicillin = val!),
              title: const Text('Amoxicillin'),
            ),
            ElevatedButton(
              onPressed: saveDischargeInfo,
              child: const Text('Save Discharge Information'),
            ),
            const Divider(),
            const Text(
              'Newborn Vitals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: newbornTempController,
              decoration:
                  const InputDecoration(labelText: 'Newborn Temperature'),
            ),
            TextField(
              controller: newbornPulseController,
              decoration: const InputDecoration(labelText: 'Newborn Pulse'),
            ),
            CheckboxListTile(
              value: newbornPassedStool,
              onChanged: (val) => setState(() => newbornPassedStool = val!),
              title: const Text('Newborn Passed Stool'),
            ),
            CheckboxListTile(
              value: newbornPassedUrine,
              onChanged: (val) => setState(() => newbornPassedUrine = val!),
              title: const Text('Newborn Passed Urine'),
            ),
            CheckboxListTile(
              value: breastfeedingStatus,
              onChanged: (val) => setState(() => breastfeedingStatus = val!),
              title: const Text('Breastfeeding Status'),
            ),
            CheckboxListTile(
              value: hepatitisBStatus,
              onChanged: (val) => setState(() => hepatitisBStatus = val!),
              title: const Text('Hepatitis B Status'),
            ),
            ElevatedButton(
              onPressed: saveNewbornVitals,
              child: const Text('Save Newborn Vitals'),
            ),
          ],
        ),
      ),
    );
  }
}
