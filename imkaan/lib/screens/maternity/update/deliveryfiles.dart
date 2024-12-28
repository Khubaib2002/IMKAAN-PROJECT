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
  final DatabaseService _databaseService = DatabaseService();
// basic info
  TextEditingController filenoController = TextEditingController();
  TextEditingController admissiondateController = TextEditingController();
  TextEditingController admissiontimeController = TextEditingController();
// discharge info
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
  TextEditingController consultationdateController = TextEditingController();
  TextEditingController othermedsController = TextEditingController();
// Examination on Admission
  TextEditingController weekofpregController = TextEditingController();
  TextEditingController fundalheightController = TextEditingController();
  TextEditingController fhrController = TextEditingController();
  String selectedfm = '';
  final List<String> fms = [
    'Positive',
    'Negative',
  ];
  TextEditingController lieController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bpController = TextEditingController();
  TextEditingController pulseController = TextEditingController();
  TextEditingController tempController = TextEditingController();
  TextEditingController conjunctivitisController = TextEditingController();
  TextEditingController bloodgroupController = TextEditingController();
  TextEditingController hcvController = TextEditingController();
  TextEditingController hbvController = TextEditingController();
  TextEditingController hbController = TextEditingController();
  TextEditingController compaintsdiagnosisController = TextEditingController();
// Vag Exam
  TextEditingController effacementController = TextEditingController();
  TextEditingController consistencyController = TextEditingController();
  TextEditingController dilationController = TextEditingController();
  TextEditingController presentingPartController = TextEditingController();
  TextEditingController engagementController = TextEditingController();
  TextEditingController pvbleedingController = TextEditingController();
  TextEditingController vagdateController = TextEditingController();
  TextEditingController vagtimeController = TextEditingController();

  bool passedUrine = false; // Checkbox values for boolean information
  bool uterusContracted = false;
  bool lochiaNormal = false;
  bool vitaminA = false;
  bool postnatalCare = false;
  bool familyPlanning = false;
  bool lowBirthWeight = false;
  bool dangerSign = false;
  bool newbornPassedStool = false;
  bool newbornPassedUrine = false;
  bool exclusivebreastfeeding = false;
  bool hepatitisBStatus = false;
  bool ferrousSulphate = false;
  bool folicAcid = false;

  String breastfeedingStatus = '';
  String selectedmembrance = '';
  String selectedliqour = '';
  String selectedProcedure = '';
  String selectedDiagnosis = '';

  final List<String> breastfeedingstatuses = ['Feeding Well', 'Difficult'];
  final List<String> membrances = ['Intact', 'Ruptured', 'Other'];
  final List<String> liqours = [
    'Clear',
    'Meconium Stained',
    'Foul Smelling',
    'Blood Stained',
    'Other'
  ];

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

  Future<void> addDischargeInfo(
    // Saving discharge info to Firestore (under deliveryfiles subcollection)
    String patientid,
    String fileno,
    String admissiondate,
    String admissiontime,
    // examination on admission
    String weekofpreg,
    String fundalheight,
    String fhr,
    String selectedfm,
    String lie,
    String weight,
    String bp,
    String pulse,
    String temp,
    String conjunctivitis,
    String bloodgroup,
    String hcv,
    String hbv,
    String hb,
    String compaintsdiagnosis,
    // vag exam
    String effacement,
    String consistency,
    String dilation,
    String presentingPart,
    String engagement,
    String pvbleeding,
    String selectedmembrance,
    String vagdate,
    String vagtime,
    String selectedliqour,
    // discharge info
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
    String vitaminA,
    String specialRecommendations,
    String selectedProcedure,
    String selectedDiagnosis,
    String postnatalCare,
    String ferrousSulphate,
    String folicAcid,
    String othermeds,
    String familyPlanning,
    String lowBirthWeight,
    String dangerSign,
    String newbornTemp,
    String newbornPassedStool,
    String newbornPassedUrine,
    String exclusivebreastfeeding,
    String breastfeedingStatus,
    String hepatitisBStatus,
    String consultationdate,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientid)
          .collection('deliveryfiles')
          .add({
        'fileno': fileno,
        'admissiondate': admissiondate,
        'admissiontime': admissiontime,

        'weekofpreg': weekofpreg,
        'fundalheight': fundalheight,
        'fhr': fhr,
        'selectedfm': selectedfm,
        'lie': lie,
        'weight': weight,
        'bp': bp,
        'pulse': pulse,
        'temp': temp,
        'conjunctivitis': conjunctivitis,
        'bloodgroup': bloodgroup,
        'hcv': hcv,
        'hbv': hbv,
        'hb': hb,
        'compaintsdiagnosis': compaintsdiagnosis,
        // vag
        'effacement': effacement,
        'consistency': consistency,
        'dilation_cm': dilation,
        'presentingPart': presentingPart,
        'engagement': engagement,
        'pvbleeding': pvbleeding,
        'membrances': selectedmembrance,
        'vagdate': vagdate,
        'vagtime': vagtime,
        'liqour': selectedliqour,
        // discharge info
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
        'vitaminA': vitaminA,
        'specialRecommendations': specialRecommendations,
        'selectedProcedure': selectedProcedure,
        'selectedDiagnosis': selectedDiagnosis,
        'postnatalCare': postnatalCare,
        'ferrousSulphate': ferrousSulphate,
        'folicaAcid': folicAcid,
        'othermeds': othermeds,
        'familyPlanning': familyPlanning,
        'lowBirthWeight': lowBirthWeight,
        'dangerSign': dangerSign,
        'newbornTemp': newbornTemp,
        'newbornPassedStool': newbornPassedStool,
        'newbornPassedUrine': newbornPassedUrine,
        'exclusivebreastfeeding': exclusivebreastfeeding,
        'breastfeedingStatus': breastfeedingStatus,
        'hepatitisBStatus': hepatitisBStatus,
        'consultationdate': consultationdate,
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
    String fileno,
    String admissiondate,
    String admissiontime,
    String weekofpreg,
    String fundalheight,
    String fhr,
    String selectedfm,
    String lie,
    String weight,
    String bp,
    String pulse,
    String temp,
    String conjunctivitis,
    String bloodgroup,
    String hcv,
    String hbv,
    String hb,
    String compaintsdiagnosis,
    // vag
    String effacement,
    String consistency,
    String dilation,
    String presentingPart,
    String engagement,
    String pvbleeding,
    String selectedmembrance,
    String vagdate,
    String vagtime,
    String selectedliqour,
    // discharge info
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
    String vitaminA,
    String specialRecommendations,
    String selectedProcedure,
    String selectedDiagnosis,
    String postnatalCare,
    String ferrousSulphate,
    String folicAcid,
    String othermeds,
    String familyPlanning,
    String lowBirthWeight,
    String dangerSign,
    String newbornTemp,
    String newbornPassedStool,
    String newbornPassedUrine,
    String exclusivebreastfeeding,
    String breastfeedingStatus,
    String hepatitisBStatus,
    String consultationdate,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientid)
          .collection('deliveryfiles')
          .doc(docid)
          .set({
        'fileno': fileno,
        'admissiondate': admissiondate,
        'admissiontime': admissiontime,

        'weekofpreg': weekofpreg,
        'fundalheight': fundalheight,
        'fhr': fhr,
        'selectedfm': selectedfm,
        'lie': lie,
        'weight': weight,
        'bp': bp,
        'pulse': pulse,
        'temp': temp,
        'conjunctivitis': conjunctivitis,
        'bloodgroup': bloodgroup,
        'hcv': hcv,
        'hbv': hbv,
        'hb': hb,
        'compaintsdiagnosis': compaintsdiagnosis,
        // vag
        'effacement': effacement,
        'consistency': consistency,
        'dilation_cm': dilation,
        'presentingPart': presentingPart,
        'engagement': engagement,
        'pvbleeding': pvbleeding,
        'membrances': selectedmembrance,
        'vagdate': vagdate,
        'vagtime': vagtime,
        'liqour': selectedliqour,
        // discharge info
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
        'vitaminA': vitaminA,
        'specialRecommendations': specialRecommendations,
        'selectedProcedure': selectedProcedure,
        'selectedDiagnosis': selectedDiagnosis,
        'postnatalCare': postnatalCare,
        'ferrousSulphate': ferrousSulphate,
        'folicaAcid': folicAcid,
        'othermeds': othermeds,
        'familyPlanning': familyPlanning,
        'lowBirthWeight': lowBirthWeight,
        'dangerSign': dangerSign,
        'newbornTemp': newbornTemp,
        'newbornPassedStool': newbornPassedStool,
        'newbornPassedUrine': newbornPassedUrine,
        'exclusivebreastfeeding': exclusivebreastfeeding,
        'breastfeedingStatus': breastfeedingStatus,
        'hepatitisBStatus': hepatitisBStatus,
        'consultationdate': consultationdate,
      }); // Merge ensures existing data is updated

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Delivery information updated successfully!')));
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
          title: const Text('Medical Records'),
        ),
        body: const Center(
          child: Text(
            'Please select a patient to add or update delivery files.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Or Update Delivery Files Information'),
        shadowColor: Colors.amber[100],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Enter new delivery file information here',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 10),
                TextField(
                  controller: filenoController,
                  decoration: const InputDecoration(labelText: 'File no'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: admissiondateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Admission',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () =>
                      _selectDate(context, controller: admissiondateController),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: admissiontimeController,
                  decoration:
                      const InputDecoration(labelText: 'Time of admission'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Examination on Admission',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: weekofpregController,
                  decoration:
                      const InputDecoration(labelText: 'Week of Pregnancy'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fundalheightController,
                  decoration:
                      const InputDecoration(labelText: 'Fundal Height (cm)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fhrController,
                  decoration: const InputDecoration(
                      labelText: 'Fetal Heart Rate (b/m)'),
                ),
                const SizedBox(height: 10),
                _buildDropdown(selectedfm, 'Fetal Movement (FM)', fms, (value) {
                  setState(() {
                    selectedfm = value ?? '';
                  });
                }),
                const SizedBox(height: 10),
                TextField(
                  controller: lieController,
                  decoration: const InputDecoration(labelText: 'Fetal Lie'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bpController,
                  decoration: const InputDecoration(labelText: 'BP'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pulseController,
                  decoration: const InputDecoration(labelText: 'Pulse'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: tempController,
                  decoration: const InputDecoration(labelText: 'Temperature'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: conjunctivitisController,
                  decoration:
                      const InputDecoration(labelText: 'Conjunctivitis'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bloodgroupController,
                  decoration: const InputDecoration(labelText: 'Blood Group'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hcvController,
                  decoration: const InputDecoration(labelText: 'HCV'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hbvController,
                  decoration: const InputDecoration(labelText: 'HBV'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hbController,
                  decoration: const InputDecoration(labelText: 'HB'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Compaints/Diagnosis',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: compaintsdiagnosisController,
                  decoration:
                      const InputDecoration(labelText: 'Compaints/Diagnosis'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Vaginal Examination',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: effacementController,
                  decoration: const InputDecoration(labelText: 'Effacement'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: consistencyController,
                  decoration: const InputDecoration(labelText: 'Consistency'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dilationController,
                  decoration: const InputDecoration(labelText: 'Dilation (cm)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: presentingPartController,
                  decoration:
                      const InputDecoration(labelText: 'Presenting Part'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: engagementController,
                  decoration: const InputDecoration(labelText: 'Engagement'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pvbleedingController,
                  decoration: const InputDecoration(labelText: 'PV Bleeding'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: vagdateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Vaginal Examination',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () =>
                      _selectDate(context, controller: vagdateController),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: vagtimeController,
                  decoration: const InputDecoration(
                      labelText: 'Time of Vaginal Examination'),
                ),
                const SizedBox(height: 10),
                _buildDropdown(selectedmembrance, 'Membrance', membrances,
                    (value) {
                  setState(() {
                    selectedmembrance = value ?? '';
                  });
                }),
                const SizedBox(height: 10),
                _buildDropdown(selectedliqour, 'Liqour', liqours, (value) {
                  setState(() {
                    selectedliqour = value ?? '';
                  });
                }),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Discharge Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dischargeDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Discharge',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () =>
                      _selectDate(context, controller: dischargeDateController),
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
                TextField(
                  controller: dischargeDoneByController,
                  decoration:
                      const InputDecoration(labelText: 'Discharge Done By'),
                ),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Examination at Discharge',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Mother Information',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: motherBPController,
                  decoration:
                      const InputDecoration(labelText: 'Blood Pressure'),
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
                CheckboxListTile(
                  value: vitaminA,
                  onChanged: (val) => setState(() => vitaminA = val!),
                  title: const Text('Vitamin A Given'),
                ),
                const Divider(),
                const Text(
                  'Newborn Vitals',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: newbornTempController,
                  decoration: const InputDecoration(labelText: 'Temperature'),
                ),
                CheckboxListTile(
                  value: newbornPassedStool,
                  onChanged: (val) => setState(() => newbornPassedStool = val!),
                  title: const Text('Passed Stool'),
                ),
                CheckboxListTile(
                  value: newbornPassedUrine,
                  onChanged: (val) => setState(() => newbornPassedUrine = val!),
                  title: const Text('Passed Urine'),
                ),
                _buildDropdown(breastfeedingStatus, 'Breast Feeding Status',
                    breastfeedingstatuses, (value) {
                  setState(() {
                    breastfeedingStatus = value ?? '';
                  });
                }),
                CheckboxListTile(
                  value: hepatitisBStatus,
                  onChanged: (val) => setState(() => hepatitisBStatus = val!),
                  title: const Text('Hepatitis B Status'),
                ),
                const Divider(),
                const Text(
                  'Health Education',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                  value: exclusivebreastfeeding,
                  onChanged: (val) =>
                      setState(() => exclusivebreastfeeding = val!),
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
                  decoration: const InputDecoration(
                      labelText: 'Special Recommendations'),
                ),
                const Divider(),
                const SizedBox(height: 20),
                const Text(
                  'Performed Procedure',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildDropdown(
                    selectedProcedure, 'Select Procedure', procedures, (value) {
                  setState(() {
                    selectedProcedure = value ?? '';
                  });
                }),
                const SizedBox(height: 20),
                const Text(
                  'Diagnosis at Exit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildDropdown(selectedDiagnosis, 'Select Diagnosis', diagnoses,
                    (value) {
                  setState(() {
                    selectedDiagnosis = value ?? '';
                  });
                }),
                const Divider(),
                const Text(
                  'Treatment at Home',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                CheckboxListTile(
                  value: ferrousSulphate,
                  onChanged: (val) => setState(() => ferrousSulphate = val!),
                  title: const Text('Ferrous Sulphate'),
                ),
                CheckboxListTile(
                  value: folicAcid,
                  onChanged: (val) => setState(() => folicAcid = val!),
                  title: const Text('Folic Acid'),
                ),
                TextField(
                  controller: othermedsController,
                  decoration: const InputDecoration(
                      labelText: 'Other Medications Given'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: consultationdateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Post-Natal Consultation Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectDate(context,
                      controller: consultationdateController),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (widget.patientId.isEmpty ||
                        filenoController.text.isEmpty ||
                        dischargeDateController.text.isEmpty ||
                        lengthOfStayController.text.isEmpty ||
                        modeController.text.isEmpty ||
                        dischargeDoneByController.text.isEmpty ||
                        motherBPController.text.isEmpty ||
                        motherTempController.text.isEmpty ||
                        motherPulseController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Please fill in all required fields before saving.')));
                      return;
                    }
                    await addDischargeInfo(
                      widget.patientId,
                      filenoController.text,
                      admissiondateController.text,
                      admissiontimeController.text,
                      weekofpregController.text,
                      fundalheightController.text,
                      fhrController.text,
                      selectedfm,
                      lieController.text,
                      weightController.text,
                      bpController.text,
                      pulseController.text,
                      tempController.text,
                      conjunctivitisController.text,
                      bloodgroupController.text,
                      hcvController.text,
                      hbvController.text,
                      hbController.text,
                      compaintsdiagnosisController.text,
                      // vag
                      effacementController.text,
                      consistencyController.text,
                      dilationController.text,
                      presentingPartController.text,
                      engagementController.text,
                      pvbleedingController.text,
                      selectedmembrance,
                      vagdateController.text,
                      vagtimeController.text,
                      selectedliqour,
                      // discharge
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
                      vitaminA.toString(),
                      specialRecommendationsController.text,
                      selectedProcedure,
                      selectedDiagnosis,
                      postnatalCare.toString(),
                      ferrousSulphate.toString(),
                      folicAcid.toString(),
                      othermedsController.text,
                      familyPlanning.toString(),
                      lowBirthWeight.toString(),
                      dangerSign.toString(),
                      newbornTempController.text,
                      newbornPassedStool.toString(),
                      newbornPassedUrine.toString(),
                      exclusivebreastfeeding.toString(),
                      breastfeedingStatus.toString(),
                      hepatitisBStatus.toString(),
                      consultationdateController.text,
                    );
                  },
                  child: const Text('Save Discharge Information'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Previous Delivery Files',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                StreamBuilder<QuerySnapshot>(
                  stream: _databaseService
                      .getPreviousDeliveryFiles(widget.patientId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('No Previous Delivery Files Found'));
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: snapshot.data!.docs.map((doc) {
                          // Local state for checkbox and controllers
                          String docid = doc.id;
                          final data = doc.data() as Map<String, dynamic>;

                          var controllers = {
                            'fileno': TextEditingController(
                                text: data.containsKey('fileno')
                                    ? data['fileno']
                                    : ''),
                            'admissiondate': TextEditingController(
                                text: data.containsKey('admissiondate')
                                    ? data['admissiondate']
                                    : ''),
                            'admissiontime': TextEditingController(
                                text: data.containsKey('admissiontime')
                                    ? data['admissiontime']
                                    : ''),
                            // Examination on admission
                            'weekofpreg': TextEditingController(
                                text: data.containsKey('weekofpreg')
                                    ? data['weekofpreg']
                                    : ''),
                            'fundalheight': TextEditingController(
                                text: data.containsKey('fundalheight')
                                    ? data['fundalheight']
                                    : ''),
                            'fhr': TextEditingController(
                                text:
                                    data.containsKey('fhr') ? data['fhr'] : ''),
                            'lie': TextEditingController(
                                text:
                                    data.containsKey('lie') ? data['lie'] : ''),
                            'weight': TextEditingController(
                                text: data.containsKey('weight')
                                    ? data['weight']
                                    : ''),
                            'bp': TextEditingController(
                                text: data.containsKey('bp') ? data['bp'] : ''),
                            'pulse': TextEditingController(
                                text: data.containsKey('pulse')
                                    ? data['pulse']
                                    : ''),
                            'temp': TextEditingController(
                                text: data.containsKey('temp')
                                    ? data['temp']
                                    : ''),
                            'conjunctivitis': TextEditingController(
                                text: data.containsKey('conjunctivitis')
                                    ? data['conjunctivitis']
                                    : ''),
                            'bloodgroup': TextEditingController(
                                text: data.containsKey('bloodgroup')
                                    ? data['bloodgroup']
                                    : ''),
                            'hcv': TextEditingController(
                                text:
                                    data.containsKey('hcv') ? data['hcv'] : ''),
                            'hbv': TextEditingController(
                                text:
                                    data.containsKey('hbv') ? data['hbv'] : ''),
                            'hb': TextEditingController(
                                text: data.containsKey('hb') ? data['hb'] : ''),
                            'compaintsdiagnosis': TextEditingController(
                                text: data.containsKey('compaintsdiagnosis')
                                    ? data['compaintsdiagnosis']
                                    : ''),
                            // Vaginal exam
                            'effacement': TextEditingController(
                                text: data.containsKey('effacement')
                                    ? data['effacement']
                                    : ''),
                            'consistency': TextEditingController(
                                text: data.containsKey('consistency')
                                    ? data['consistency']
                                    : ''),
                            'dilation': TextEditingController(
                                text: data.containsKey('dilation_cm')
                                    ? data['dilation_cm']
                                    : ''),
                            'presentingPart': TextEditingController(
                                text: data.containsKey('presentingPart')
                                    ? data['presentingPart']
                                    : ''),
                            'engagement': TextEditingController(
                                text: data.containsKey('engagement')
                                    ? data['engagement']
                                    : ''),
                            'pvbleeding': TextEditingController(
                                text: data.containsKey('pvbleeding')
                                    ? data['pvbleeding']
                                    : ''),
                            'vagdate': TextEditingController(
                                text: data.containsKey('vagdate')
                                    ? data['vagdate']
                                    : ''),
                            'vagtime': TextEditingController(
                                text: data.containsKey('vagtime')
                                    ? data['vagtime']
                                    : ''),
                            // Discharge info
                            'dischargedate': TextEditingController(
                                text: data.containsKey('dischargeDate')
                                    ? data['dischargeDate']
                                    : ''),
                            'lengthOfStay': TextEditingController(
                                text: data.containsKey('lengthOfStay')
                                    ? data['lengthOfStay']
                                    : ''),
                            'mode': TextEditingController(
                                text: data.containsKey('mode')
                                    ? data['mode']
                                    : ''),
                            'dischargeDoneBy': TextEditingController(
                                text: data.containsKey('dischargeDoneBy')
                                    ? data['dischargeDoneBy']
                                    : ''),
                            'motherBP': TextEditingController(
                                text: data.containsKey('motherBP')
                                    ? data['motherBP']
                                    : ''),
                            'motherTemp': TextEditingController(
                                text: data.containsKey('motherTemp')
                                    ? data['motherTemp']
                                    : ''),
                            'motherPulse': TextEditingController(
                                text: data.containsKey('motherPulse')
                                    ? data['motherPulse']
                                    : ''),
                            'specialRecommendations': TextEditingController(
                                text: data.containsKey('specialRecommendations')
                                    ? data['specialRecommendations']
                                    : ''),
                            'newbornTemp': TextEditingController(
                                text: data.containsKey('newbornTemp')
                                    ? data['newbornTemp']
                                    : ''),
                            'consultationdate': TextEditingController(
                                text: data.containsKey('consultationdate')
                                    ? data['consultationdate']
                                    : ''),
                            'othermeds': TextEditingController(
                                text: data.containsKey('othermeds')
                                    ? data['othermeds']
                                    : ''),
                          };

                          String breastfeedingStatusupdate =
                              data.containsKey('breastfeedingStatus')
                                  ? data['breastfeedingStatus']
                                  : '';
                          String selectedfmupdate =
                              data.containsKey('selectedfm')
                                  ? data['selectedfm']
                                  : '';
                          String selectedProcedureupdate =
                              data.containsKey('selectedProcedure')
                                  ? data['selectedProcedure']
                                  : '';
                          String selectedDiagnosisupdate =
                              data.containsKey('selectedDiagnosis')
                                  ? data['selectedDiagnosis']
                                  : '';

                          var checkboxes = <String, bool>{
                            'passedUrine': (data.containsKey('passedUrine')
                                    ? data['passedUrine']
                                    : 'false') ==
                                'true',
                            'uterusContracted':
                                (data.containsKey('uterusContracted')
                                        ? data['uterusContracted']
                                        : 'false') ==
                                    'true',
                            'lochiaNormal': (data.containsKey('lochiaNormal')
                                    ? data['lochiaNormal']
                                    : 'false') ==
                                'true',
                            'vitaminA': (data.containsKey('vitaminA')
                                    ? data['vitaminA']
                                    : 'false') ==
                                'true',
                            'postnatalCare': (data.containsKey('postnatalCare')
                                    ? data['postnatalCare']
                                    : 'false') ==
                                'true',
                            'ferrousSulphate':
                                (data.containsKey('ferrousSulphate')
                                        ? data['ferrousSulphate']
                                        : 'false') ==
                                    'true',
                            'folicAcid': (data.containsKey('folicaAcid')
                                    ? data['folicaAcid']
                                    : 'false') ==
                                'true',
                            'familyPlanning':
                                (data.containsKey('familyPlanning')
                                        ? data['familyPlanning']
                                        : 'false') ==
                                    'true',
                            'lowBirthWeight':
                                (data.containsKey('lowBirthWeight')
                                        ? data['lowBirthWeight']
                                        : 'false') ==
                                    'true',
                            'dangerSign': (data.containsKey('dangerSign')
                                    ? data['dangerSign']
                                    : 'false') ==
                                'true',
                            'newbornPassedStool':
                                (data.containsKey('newbornPassedStool')
                                        ? data['newbornPassedStool']
                                        : 'false') ==
                                    'true',
                            'newbornPassedUrine':
                                (data.containsKey('newbornPassedUrine')
                                        ? data['newbornPassedUrine']
                                        : 'false') ==
                                    'true',
                            'exclusivebreastfeeding':
                                (data.containsKey('exclusivebreastfeeding')
                                        ? data['exclusivebreastfeeding']
                                        : 'false') ==
                                    'true',
                            'hepatitisBStatus':
                                (data.containsKey('hepatitisBStatus')
                                        ? data['hepatitisBStatus']
                                        : 'false') ==
                                    'true',
                          };

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Card(
                                  margin: const EdgeInsets.all(10.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Edit the information and hit \'Update\' to update this delivery file',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['fileno'],
                                          decoration: const InputDecoration(
                                              labelText: 'File no'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['admissiondate'],
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Date of Admission',
                                            border: OutlineInputBorder(),
                                          ),
                                          onTap: () => _selectDate(context,
                                              controller: controllers[
                                                      'admissiondate'] ??
                                                  TextEditingController()),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['admissiontime'],
                                          decoration: const InputDecoration(
                                              labelText: 'Time of admission'),
                                        ),

                                        const SizedBox(height: 10),
                                        const Text(
                                          'Examination on Admission',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['weekofpreg'],
                                          decoration: const InputDecoration(
                                              labelText: 'Week of Pregnancy'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['fundalheight'],
                                          decoration: const InputDecoration(
                                              labelText: 'Fundal Height (cm)'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['fhr'],
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Fetal Heart Rate (b/m)'),
                                        ),
                                        const SizedBox(height: 10),
                                        _buildDropdown(
                                            selectedfmupdate,
                                            'Fetal Movement (FM)',
                                            fms, (value) {
                                          setState(() {
                                            selectedfmupdate = value ?? '';
                                          });
                                        }),
                                        const SizedBox(height: 10),

                                        TextField(
                                          controller: controllers['lie'],
                                          decoration: const InputDecoration(
                                              labelText: 'Fetal Lie'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['weight'],
                                          decoration: const InputDecoration(
                                              labelText: 'Weight (kg)'),
                                        ),
                                        const SizedBox(height: 10),

                                        TextField(
                                          controller: controllers['bp'],
                                          decoration: const InputDecoration(
                                              labelText: 'BP'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['pulse'],
                                          decoration: const InputDecoration(
                                              labelText: 'Pulse'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['temp'],
                                          decoration: const InputDecoration(
                                              labelText: 'Temperature'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['conjunctivitis'],
                                          decoration: const InputDecoration(
                                              labelText: 'Conjunctivitis'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['bloodgroup'],
                                          decoration: const InputDecoration(
                                              labelText: 'Blood Group'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['hcv'],
                                          decoration: const InputDecoration(
                                              labelText: 'HCV'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['hbv'],
                                          decoration: const InputDecoration(
                                              labelText: 'HBV'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['hb'],
                                          decoration: const InputDecoration(
                                              labelText: 'HB'),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Compaints/Diagnosis',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['compaintsdiagnosis'],
                                          decoration: const InputDecoration(
                                              labelText: 'Compaints/Diagnosis'),
                                        ),

                                        const SizedBox(height: 10),
                                        const Text(
                                          'Compaints/Diagnosis',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Vaginal Examination',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['effacement'],
                                          decoration: const InputDecoration(
                                              labelText: 'Effacement'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['consistency'],
                                          decoration: const InputDecoration(
                                              labelText: 'Consistency'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['dilation'],
                                          decoration: const InputDecoration(
                                              labelText: 'Dilation (cm)'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['presentingPart'],
                                          decoration: const InputDecoration(
                                              labelText: 'Presenting Part'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['engagement'],
                                          decoration: const InputDecoration(
                                              labelText: 'Engagement'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['pvbleeding'],
                                          decoration: const InputDecoration(
                                              labelText: 'PV Bleeding'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['vagdate'],
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Date of Vaginal Examination',
                                            border: OutlineInputBorder(),
                                          ),
                                          onTap: () => _selectDate(context,
                                              controller:
                                                  controllers['vagdate'] ??
                                                      TextEditingController()),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: controllers['vagtime'],
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Time of Vaginal Examination'),
                                        ),
                                        const SizedBox(height: 10),
                                        _buildDropdown(selectedmembrance,
                                            'Membrance', membrances, (value) {
                                          setState(() {
                                            selectedmembrance = value ?? '';
                                          });
                                        }),
                                        const SizedBox(height: 10),
                                        _buildDropdown(
                                            selectedliqour, 'Liqour', liqours,
                                            (value) {
                                          setState(() {
                                            selectedliqour = value ?? '';
                                          });
                                        }),
                                        const SizedBox(height: 10),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Discharge Information',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['dischargedate'],
                                          decoration: const InputDecoration(
                                              labelText: 'Date of Discharge'),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['lengthOfStay'],
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
                                                fontSize: 14,
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
                                          controller:
                                              controllers['motherPulse'],
                                          decoration: const InputDecoration(
                                              labelText: 'Pulse Rate'),
                                        ),
                                        buildCheckboxListTile(
                                          value: checkboxes['passedUrine'] ??
                                              false,
                                          label: 'Passed Urine',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['passedUrine'] = val!),
                                        ),
                                        buildCheckboxListTile(
                                          value:
                                              checkboxes['uterusContracted'] ??
                                                  false,
                                          label: 'Uterus Contracted',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['uterusContracted'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value: checkboxes['lochiaNormal'] ??
                                              false,
                                          label: 'Lochia Normal',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['lochiaNormal'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value:
                                              checkboxes['vitaminA'] ?? false,
                                          label: 'Vitamin A Given',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['vitaminA'] = val!),
                                        ),
                                        const Divider(),
                                        const Text('Newborn Vitals',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        // Newborn vitals
                                        TextField(
                                          controller:
                                              controllers['newbornTemp'],
                                          decoration: const InputDecoration(
                                              labelText: 'Temperature'),
                                        ),
                                        // Checkbox rows for Newborn info
                                        buildCheckboxListTile(
                                          value: checkboxes[
                                                  'newbornPassedStool'] ??
                                              false,
                                          label: 'Passed Stool',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['newbornPassedStool'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value: checkboxes[
                                                  'newbornPassedUrine'] ??
                                              false,
                                          label: 'Passed Urine',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['newbornPassedUrine'] =
                                                  val!),
                                        ),
                                        _buildDropdown(
                                            breastfeedingStatusupdate,
                                            'Breast Feeding Status',
                                            breastfeedingstatuses, (value) {
                                          setState(() {
                                            breastfeedingStatusupdate =
                                                value ?? '';
                                          });
                                        }),
                                        buildCheckboxListTile(
                                          value:
                                              checkboxes['hepatitisBStatus'] ??
                                                  false,
                                          label: 'Hepatitis B Status',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['hepatitisBStatus'] =
                                                  val!),
                                        ),
                                        const Divider(),
                                        const Text('Health Education',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        buildCheckboxListTile(
                                          value: checkboxes['postnatalCare'] ??
                                              false,
                                          label: 'Postnatal Care',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['postnatalCare'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value: checkboxes['familyPlanning'] ??
                                              false,
                                          label: 'Family Planning',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['familyPlanning'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value: checkboxes[
                                                  'exclusivebreastfeeding'] ??
                                              false,
                                          label: 'Exclusive Breastfeeding',
                                          onChanged: (val) => setState(() =>
                                              checkboxes[
                                                      'exclusivebreastfeeding'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value: checkboxes['lowBirthWeight'] ??
                                              false,
                                          label: 'Low Birth Weight',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['lowBirthWeight'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value:
                                              checkboxes['dangerSign'] ?? false,
                                          label: 'Danger Sign',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['dangerSign'] = val!),
                                        ),
                                        TextField(
                                          controller: controllers[
                                              'specialRecommendations'],
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Special Recommendations'),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text('Performed Procedure',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        _buildDropdown(
                                            selectedProcedureupdate,
                                            'Select Procedure',
                                            procedures, (value) {
                                          setState(() {
                                            selectedProcedureupdate =
                                                value ?? '';
                                          });
                                        }),
                                        const SizedBox(height: 20),
                                        const Text('Diagnosis at Exit',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        // Dropdown for Diagnosis
                                        _buildDropdown(
                                            selectedDiagnosisupdate,
                                            'Select Diagnosis',
                                            diagnoses, (value) {
                                          setState(() {
                                            selectedDiagnosisupdate =
                                                value ?? '';
                                          });
                                        }),
                                        const Divider(),
                                        const Text('Treatment at Home',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        buildCheckboxListTile(
                                          value:
                                              checkboxes['ferrousSulphate'] ??
                                                  false,
                                          label: 'Ferrous Sulphate',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['ferrousSulphate'] =
                                                  val!),
                                        ),
                                        buildCheckboxListTile(
                                          value:
                                              checkboxes['folicAcid'] ?? false,
                                          label: 'Folic Acid',
                                          onChanged: (val) => setState(() =>
                                              checkboxes['folicAcid'] = val!),
                                        ),
                                        TextField(
                                          controller: controllers['othermeds'],
                                          decoration: const InputDecoration(
                                              labelText:
                                                  'Amount of All Medications Given'),
                                        ),

                                        const SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              controllers['consultationdate'],
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Post-Natal Consultation Date',
                                            border: OutlineInputBorder(),
                                          ),
                                          onTap: () => _selectDate(context,
                                              controller: controllers[
                                                      'consultationdate'] ??
                                                  TextEditingController()),
                                        ),
                                        const SizedBox(height: 10),

                                        ElevatedButton(
                                          onPressed: () async {
                                            await updateDischargeInfo(
                                              widget.patientId,
                                              docid,
                                              controllers['fileno']?.text ?? '',
                                              controllers['admissiondate']
                                                      ?.text ??
                                                  '',
                                              controllers['admissiontime']
                                                      ?.text ??
                                                  '',
// admission
                                              controllers['weekofpreg']?.text ??
                                                  '',
                                              controllers['fundalheight']
                                                      ?.text ??
                                                  '',
                                              controllers['fhr']?.text ?? '',
                                              selectedfmupdate,
                                              controllers['lie']?.text ?? '',
                                              controllers['weight']?.text ?? '',
                                              controllers['bp']?.text ?? '',
                                              controllers['pulse']?.text ?? '',
                                              controllers['temp']?.text ?? '',
                                              controllers['conjunctivitis']
                                                      ?.text ??
                                                  '',
                                              controllers['bloodgroup']?.text ??
                                                  '',
                                              controllers['hcv']?.text ?? '',
                                              controllers['hbv']?.text ?? '',
                                              controllers['hb']?.text ?? '',
                                              controllers['compaintsdiagnosis']
                                                      ?.text ??
                                                  '',
                                              // vag
                                              controllers['effacement']?.text ??
                                                  '',
                                              controllers['consistency']
                                                      ?.text ??
                                                  '',
                                              controllers['dilation']?.text ??
                                                  '',
                                              controllers['presentingPart']
                                                      ?.text ??
                                                  '',
                                              controllers['engagement']?.text ??
                                                  '',
                                              controllers['pvbleeding']?.text ??
                                                  '',
                                              controllers['vagdate']?.text ??
                                                  '',
                                              controllers['vagtime']?.text ??
                                                  '',
                                              selectedmembrance,
                                              selectedliqour,
                                              // discharge
                                              controllers['dischargedate']
                                                      ?.text ??
                                                  '',
                                              controllers['lengthOfStay']
                                                      ?.text ??
                                                  '',
                                              controllers['mode']?.text ?? '',
                                              controllers['dischargeDoneBy']
                                                      ?.text ??
                                                  '',
                                              controllers['motherBP']?.text ??
                                                  '',
                                              controllers['motherTemp']?.text ??
                                                  '',
                                              controllers['motherPulse']
                                                      ?.text ??
                                                  '',
                                              (checkboxes['passedUrine'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['uterusContracted'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['lochiaNormal'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['vitaminA'] ?? false)
                                                  ? 'true'
                                                  : 'false',
                                              controllers['specialRecommendations']
                                                      ?.text ??
                                                  '',
                                              selectedProcedureupdate,
                                              selectedDiagnosisupdate,
                                              (checkboxes['postnatalCare'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['ferrousSulphate'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['folicAcid'] ?? false)
                                                  ? 'true'
                                                  : 'false',
                                              controllers['othermeds']?.text ??
                                                  '',
                                              (checkboxes['familyPlanning'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['lowBirthWeight'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['dangerSign'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              controllers['newbornTemp']
                                                      ?.text ??
                                                  '',

                                              (checkboxes['newbornPassedStool'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['newbornPassedUrine'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              (checkboxes['exclusivebreastfeeding'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              breastfeedingStatusupdate,
                                              (checkboxes['hepatitisBStatus'] ??
                                                      false)
                                                  ? 'true'
                                                  : 'false',
                                              controllers['consultationdate']
                                                      ?.text ??
                                                  '',
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
                                  ));
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

//               const Text(
//                 'Previous Deliveries',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: _databaseService
//                       .getPreviousDeliveryFiles(widget.patientId),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Center(
//                           child: Text('No Previous Deliveries Found'));
//                     }
//                     return ListView(
//                       children: snapshot.data!.docs.map((doc) {
//                         // Local state for checkbox
//                         var controllers = {
//                           'dischargedate':
//                               TextEditingController(text: doc['dischargeDate']),
//                           'dischargeId':
//                               TextEditingController(text: doc['dischargeId']),
//                           'lengthOfStay':
//                               TextEditingController(text: doc['lengthOfStay']),
//                           'mode': TextEditingController(text: doc['mode']),
//                           'dischargeDoneBy': TextEditingController(
//                               text: doc['dischargeDoneBy']),
//                           'motherBP':
//                               TextEditingController(text: doc['motherBP']),
//                           'motherTemp':
//                               TextEditingController(text: doc['motherTemp']),
//                           'motherPulse':
//                               TextEditingController(text: doc['motherPulse']),
//                           'specialRecommendations': TextEditingController(
//                               text: doc['specialRecommendations']),
//                           'newbornTemp':
//                               TextEditingController(text: doc['newbornTemp']),
//                           'newbornPulse':
//                               TextEditingController(text: doc['newbornPulse']),
//                         };
//                         String selectedProcedureupdate =
//                             doc['selectedProcedure'];
//                         String selectedDiagnosisupdate =
//                             doc['selectedDiagnosis'];

//                         var checkboxes = {
//                           'outcome': doc['outcome'],
//                           'passedUrine': doc['passedUrine'],
//                           'uterusContracted': doc['uterusContracted'],
//                           'lochiaNormal': doc['lochiaNormal'],
//                           'postnatalCare': doc['postnatalCare'],
//                           'ferrousSulphate': doc['ferrousSulphate'],
//                           'familyPlanning': doc['familyPlanning'],
//                           'exclusiveBreast': doc['exclusiveBreast'],
//                           'lowBirthWeight': doc['lowBirthWeight'],
//                           'dangerSign': doc['dangerSign'],
//                           'newbornPassedStool': doc['newbornPassedStool'],
//                           'newbornPassedUrine': doc['newbornPassedUrine'],
//                           'breastfeedingStatus': doc['breastfeedingStatus'],
//                           'hepatitisBStatus': doc['hepatitisBStatus'],
//                         };
//                         return StatefulBuilder(
//                           builder: (context, setState) {
//                             return Card(
//                               margin: const EdgeInsets.all(10),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 10),
//                                   TextField(
//                                     controller: controllers['dischargedate'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Date of Delivery'),
//                                   ),
//                                   const SizedBox(height: 10),

//                                   TextField(
//                                     controller: controllers['dischargeId'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Discharge ID'),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   TextField(
//                                     controller: controllers['lengthOfStay'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Length of Stay'),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   TextField(
//                                     controller: controllers['mode'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Mode'),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   TextField(
//                                     controller: controllers['dischargeDoneBy'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Discharge Done By'),
//                                   ),
//                                   const Divider(),
//                                   const Text(
//                                     'Mother Information',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   TextField(
//                                     controller: controllers['motherBP'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Blood Pressure'),
//                                   ),
//                                   TextField(
//                                     controller: controllers['motherTemp'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Temperature'),
//                                   ),
//                                   TextField(
//                                     controller: controllers['motherPulse'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Pulse Rate'),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Passed Urine'),
//                                       Checkbox(
//                                         value: checkboxes['passedUrine'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['passedUrine'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Uterus Contracted'),
//                                       Checkbox(
//                                         value: checkboxes['uterusContracted'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['uterusContracted'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Lochia Normal'),
//                                       Checkbox(
//                                         value: checkboxes['lociaNormal'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['lociaNormal'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   const Divider(),
//                                   const Text(
//                                     'Health Education',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Postnatal Care'),
//                                       Checkbox(
//                                         value: checkboxes['postnatalCare'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['postnatalCare'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Family Planning'),
//                                       Checkbox(
//                                         value: checkboxes['familyPlanning'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['familyPlanning'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Exclusive Breastfeeding'),
//                                       Checkbox(
//                                         value: checkboxes['exclusiveBreast'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['exclusiveBreast'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Low Birth Weight'),
//                                       Checkbox(
//                                         value: checkboxes['lowBirthWeight'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['lowBirthWeight'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Danger Sign'),
//                                       Checkbox(
//                                         value: checkboxes['dangerSign'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['dangerSign'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   TextField(
//                                     controller:
//                                         controllers['specialRecommendations'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Special Recommendations'),
//                                   ),
//                                   const SizedBox(height: 20),
//                                   const Text(
//                                     'Performed Procedure',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   DropdownButtonFormField<String>(
//                                     value: selectedProcedureupdate.isEmpty
//                                         ? null
//                                         : selectedProcedureupdate,
//                                     items: procedures
//                                         .map((procedure) => DropdownMenuItem(
//                                               value: procedure,
//                                               child: Text(procedure),
//                                             ))
//                                         .toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedProcedureupdate = value ?? '';
//                                       });
//                                     },
//                                     decoration: const InputDecoration(
//                                       labelText: 'Select Procedure',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                   const Text(
//                                     'Diagnosis at Exit',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   DropdownButtonFormField<String>(
//                                     value: selectedDiagnosisupdate.isEmpty
//                                         ? null
//                                         : selectedDiagnosisupdate,
//                                     items: diagnoses
//                                         .map((diagnosis) => DropdownMenuItem(
//                                               value: diagnosis,
//                                               child: Text(diagnosis),
//                                             ))
//                                         .toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedDiagnosisupdate = value ?? '';
//                                       });
//                                     },
//                                     decoration: const InputDecoration(
//                                       labelText: 'Select Diagnosis',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                   const Divider(),
//                                   const Text(
//                                     'Treatment at Home',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   TextField(
//                                     controller: controllers['ferrousSulphate'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Ferrous Sulphate'),
//                                   ),
//                                   const Divider(),
//                                   const Text(
//                                     'Health Education',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   const Divider(),
//                                   const Text(
//                                     'Newborn Vitals',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   TextField(
//                                     controller: controllers['type'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Newborn Temperature'),
//                                   ),
//                                   TextField(
//                                     controller: controllers['location'],
//                                     decoration: const InputDecoration(
//                                         labelText: 'Newborn Pulse'),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Newborn Passed Stool'),
//                                       Checkbox(
//                                         value: checkboxes['newbornPassedStool'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['newbornPassedStool'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text('Hepatitis B Status'),
//                                       Checkbox(
//                                         value: checkboxes['hepatitisBStatus'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             checkboxes['hepatitisBStatus'] =
//                                                 value ?? false;
//                                           });
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                   // ElevatedButton(
//                                   //   onPressed: () async {
//                                   //     await updateDischargeInfo(
//                                   //       widget.patientId,
//                                   //       doc.id,
//                                   //       DateTime.parse(yearUpdateController.text),
//                                   //       typeUpdateController.text,
//                                   //       locationUpdateController.text,
//                                   //       outcomeUpdate, // Pass updated outcome
//                                   //     );
//                                   //     ScaffoldMessenger.of(context).showSnackBar(
//                                   //       const SnackBar(
//                                   //           content: Text(
//                                   //               'Previous Delivery File Updated Successfully!')),
//                                   //     );
//                                   //   },
//                                   //   child: const Text('Update Delivery'),
//                                   // ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                         // return ListView(
//                         //   shrinkWrap: true, // Ensures that the list does not overflow
//                         //   children: snapshot.data!.docs.map((doc) {
//                         //     return ListTile(
//                         //       title: Text('Delivery Info ${doc.id}'),
//                         //     );
//                       }).toList(),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


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