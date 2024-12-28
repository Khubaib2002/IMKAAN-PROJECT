import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ANCVisits extends StatefulWidget {
  final String patientId, name, cardid;

  const ANCVisits(
      {required this.patientId, required this.name, required this.cardid});

  @override
  State<ANCVisits> createState() => _ANCVisitsState();
}

class _ANCVisitsState extends State<ANCVisits> {
  // examination
  final TextEditingController dateController = TextEditingController();
  final TextEditingController gestationalAgeController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController fundalHeightController = TextEditingController();
  final TextEditingController fetalHeartBeatController =
      TextEditingController();
  final TextEditingController ConjunctivitisController =
      TextEditingController();
  final TextEditingController OedemaController = TextEditingController();

  final TextEditingController otherComplaintsController =
      TextEditingController();
  final TextEditingController haemoglobinController =
      TextEditingController(); // lab tests
  final TextEditingController antihcvController = TextEditingController();
  final TextEditingController hbsagController = TextEditingController();
  final TextEditingController pregtestController = TextEditingController();
  final TextEditingController urineanalysisController = TextEditingController();
  final TextEditingController bloodgroupController = TextEditingController();
  final TextEditingController othertestController = TextEditingController();
  final TextEditingController ferrousfolicController =
      TextEditingController(); // medication
  final TextEditingController albendazoleController = TextEditingController();
  final TextEditingController utitreatmentController = TextEditingController();
  final TextEditingController vitamincController = TextEditingController();
  final TextEditingController othermedsController = TextEditingController();
  final TextEditingController nextAppointmentController =
      TextEditingController();

  String fetalmovement = '';
  final List<String> fetalmovements = ['Positive', 'Negative'];
  String position = '';
  final List<String> positions = ['Longitudinal', 'Transverse', 'Oblique'];
  String presentation = '';
  final List<String> presentations = ['Cephalic', 'Breech'];

  bool isUpdating = false;
  String currentVisitId = '';

  void clearFields() {
    dateController.clear();
    gestationalAgeController.clear();
    weightController.clear();
    bloodPressureController.clear();
    fundalHeightController.clear();
    fetalHeartBeatController.clear();
    fetalmovement = '';
    position = '';
    presentation = '';
    ConjunctivitisController.clear();
    OedemaController.clear();
    otherComplaintsController.clear();
    haemoglobinController.clear();
    antihcvController.clear();
    hbsagController.clear();
    pregtestController.clear();
    urineanalysisController.clear();
    bloodPressureController.clear();
    othertestController.clear();
    ferrousfolicController.clear();
    albendazoleController.clear();
    utitreatmentController.clear();
    vitamincController.clear();
    othermedsController.clear();
    nextAppointmentController.clear();
  }

  void toggleMode(bool updating) {
    setState(() {
      isUpdating = updating;
      // clearFields();
    });
  }

  Future<void> saveVisit() async {
    try {
      if (dateController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a date.')),
        );
        return;
      }

      if (isUpdating) {
        await FirebaseFirestore.instance
            .collection('Patients')
            .doc(widget.patientId)
            .collection('AntenatalRecords')
            .doc(widget.cardid)
            .collection('Visits')
            .doc(currentVisitId)
            .set({
          'Date': dateController.text,
          'Gestational Age': gestationalAgeController.text,
          'Weight': weightController.text,
          'Blood Pressure': bloodPressureController.text,
          'Fundal Height': fundalHeightController.text,
          'Fetal Heart Beat': fetalHeartBeatController.text,
          'Fetal Movement': fetalmovement,
          'Position': position,
          'Presentation': presentation,
          'Conjunctivitis': ConjunctivitisController.text,
          'Oedema': OedemaController.text,
          'Other Complaints': otherComplaintsController.text,
          'Haemoglobin': haemoglobinController.text,
          'AntihCV': antihcvController.text,
          'HBSAG': hbsagController.text,
          'Pregtest': pregtestController.text,
          'Urine Analysis': urineanalysisController.text,
          'Blood Group': bloodgroupController.text,
          'Other Test': othertestController.text,
          'Ferrous Sulphate/Folic Acid': ferrousfolicController.text,
          'Albendazole': albendazoleController.text,
          'Uti Treatment': utitreatmentController.text,
          'Vitamin C': vitamincController.text,
          'Other Meds': othermedsController.text,
          'Next Appointment': nextAppointmentController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visit updated successfully!')),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('Patients')
            .doc(widget.patientId)
            .collection('AntenatalRecords')
            .doc(widget.cardid)
            .collection('Visits')
            .add({
          'Date': dateController.text,
          'Gestational Age': gestationalAgeController.text,
          'Weight': weightController.text,
          'Blood Pressure': bloodPressureController.text,
          'Fundal Height': fundalHeightController.text,
          'Fetal Heart Beat': fetalHeartBeatController.text,
          'Fetal Movement': fetalmovement,
          'Position': position,
          'Presentation': presentation,
          'Conjunctivitis': ConjunctivitisController.text,
          'Oedema': OedemaController.text,
          'Other Complaints': otherComplaintsController.text,
          'Haemoglobin': haemoglobinController.text,
          'AntihCV': antihcvController.text,
          'HBSAG': hbsagController.text,
          'Pregtest': pregtestController.text,
          'Urine Analysis': urineanalysisController.text,
          'Blood Group': bloodgroupController.text,
          'Other Test': othertestController.text,
          'Ferrous Sulphate/Folic Acid': ferrousfolicController.text,
          'Albendazole': albendazoleController.text,
          'Uti Treatment': utitreatmentController.text,
          'Vitamin C': vitamincController.text,
          'Other Meds': othermedsController.text,
          'Next Appointment': nextAppointmentController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visit added successfully!')),
        );
      }

      setState(() {
        isUpdating = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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

  Future<void> deleteVisit(String visitId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(widget.patientId)
          .collection('AntenatalRecords')
          .doc(widget.cardid)
          .collection('Visits')
          .doc(visitId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visit deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.patientId.isEmpty || widget.cardid.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Visits Info'),
        ),
        body: const Center(
          child: Text(
            'Please select an ANC Card to add or update visits.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ANC Visits for ${widget.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Examination',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date of visit',
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectDate(context, controller: dateController),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: gestationalAgeController,
              decoration: const InputDecoration(labelText: 'Gestational Age'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bloodPressureController,
              decoration: const InputDecoration(labelText: 'Blood Pressure'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fundalHeightController,
              decoration:
                  const InputDecoration(labelText: 'Fundal Height (cm)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fetalHeartBeatController,
              decoration: const InputDecoration(
                  labelText: 'Fetal Heart Beat (beats/minutes)'),
            ),
            const SizedBox(height: 10),
            _buildDropdown(fetalmovement, 'Fetal Movements', fetalmovements,
                (value) {
              setState(() {
                fetalmovement = value ?? '';
              });
            }),
            const SizedBox(height: 10),
            _buildDropdown(position, 'Position', positions, (value) {
              setState(() {
                position = value ?? '';
              });
            }),
            const SizedBox(height: 10),
            _buildDropdown(presentation, 'Presentation', presentations,
                (value) {
              setState(() {
                presentation = value ?? '';
              });
            }),
            const SizedBox(height: 10),
            TextField(
              controller: ConjunctivitisController,
              decoration: const InputDecoration(labelText: 'Conjunctivita'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: OedemaController,
              decoration: const InputDecoration(labelText: 'Oedema'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: otherComplaintsController,
              decoration: const InputDecoration(labelText: 'Other Complaints'),
            ),
            const Divider(),
            const Text(
              'Laboratory Tests',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: haemoglobinController,
              decoration: const InputDecoration(labelText: 'Haemoglobin'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: antihcvController,
              decoration: const InputDecoration(labelText: 'Anti-HCV'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: hbsagController,
              decoration: const InputDecoration(labelText: 'HbsAg'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pregtestController,
              decoration: const InputDecoration(labelText: 'Pregnancy Test'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: urineanalysisController,
              decoration: const InputDecoration(labelText: 'Urine Analysis'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bloodgroupController,
              decoration: const InputDecoration(labelText: 'Blood Group'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: othertestController,
              decoration: const InputDecoration(labelText: 'Other Tests'),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const Text(
              'Medication',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ferrousfolicController,
              decoration: const InputDecoration(
                  labelText: 'Ferrous Sulphate/Folic Acid'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: albendazoleController,
              decoration: const InputDecoration(labelText: 'Albendazole'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: utitreatmentController,
              decoration: const InputDecoration(labelText: 'UTI Treatment'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: vitamincController,
              decoration: const InputDecoration(labelText: 'Vitamin C'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: othermedsController,
              decoration: const InputDecoration(labelText: 'Other Medications'),
            ),
            const Divider(),
            const SizedBox(height: 10),
            TextField(
              controller: nextAppointmentController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Next Appointment',
                border: OutlineInputBorder(),
              ),
              onTap: () =>
                  _selectDate(context, controller: nextAppointmentController),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveVisit,
              child: Text(isUpdating ? 'Update Visit' : 'Add Visit'),
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Patients')
                  .doc(widget.patientId)
                  .collection('AntenatalRecords')
                  .doc(widget.cardid)
                  .collection('Visits')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No Visits Found');
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text('Date: ${data['Date']}'),
                        subtitle: Text(
                            'Weight: ${data['Weight']}, BP: ${data['Blood Pressure']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  currentVisitId = doc.id;
                                  dateController.text = data.containsKey('Date')
                                      ? data['Date']
                                      : '';
                                  gestationalAgeController.text =
                                      data.containsKey('Gestational Age')
                                          ? data['Gestational Age']
                                          : '';
                                  weightController.text =
                                      data.containsKey('Weight')
                                          ? data['Weight']
                                          : '';
                                  bloodPressureController.text =
                                      data.containsKey('Blood Pressure')
                                          ? data['Blood Pressure']
                                          : '';
                                  fundalHeightController.text =
                                      data.containsKey('Fundal Height')
                                          ? data['Fundal Height']
                                          : '';
                                  fetalHeartBeatController.text =
                                      data.containsKey('Fetal Heart Beat')
                                          ? data['Fetal Heart Beat']
                                          : '';
                                  fetalmovement =
                                      data.containsKey('Fetal Movement')
                                          ? data['Fetal Movement']
                                          : '';
                                  position = data.containsKey('Position')
                                      ? data['Position']
                                      : '';
                                  presentation =
                                      data.containsKey('Presentation')
                                          ? data['Presentation']
                                          : '';
                                  ConjunctivitisController.text =
                                      data.containsKey('Conjunctivitis')
                                          ? data['Conjunctivitis']
                                          : '';
                                  OedemaController.text =
                                      data.containsKey('Oedema')
                                          ? data['Oedema']
                                          : '';
                                  otherComplaintsController.text =
                                      data.containsKey('Other Complaints')
                                          ? data['Other Complaints']
                                          : '';
                                  haemoglobinController.text =
                                      data.containsKey('Haemoglobin')
                                          ? data['Haemoglobin']
                                          : '';
                                  // lab
                                  antihcvController.text =
                                      data.containsKey('AntihCV')
                                          ? data['AntihCV']
                                          : '';
                                  hbsagController.text =
                                      data.containsKey('HBSAG')
                                          ? data['HBSAG']
                                          : '';
                                  pregtestController.text =
                                      data.containsKey('Pregtest')
                                          ? data['Pregtest']
                                          : '';
                                  urineanalysisController.text =
                                      data.containsKey('Urine Analysis')
                                          ? data['Urine Analysis']
                                          : '';
                                  bloodgroupController.text =
                                      data.containsKey('Blood Group')
                                          ? data['Blood Group']
                                          : '';
                                  othertestController.text =
                                      data.containsKey('Other Test')
                                          ? data['Other Test']
                                          : '';
                                  ferrousfolicController.text =
                                      data.containsKey(
                                              'Ferrous Sulphate/Folic Acid')
                                          ? data['Ferrous Sulphate/Folic Acid']
                                          : ''; // meds
                                  albendazoleController.text =
                                      data.containsKey('Albendazole')
                                          ? data['Albendazole']
                                          : '';
                                  utitreatmentController.text =
                                      data.containsKey('Uti Treatment')
                                          ? data['Uti Treatment']
                                          : '';
                                  vitamincController.text =
                                      data.containsKey('Vitamin C')
                                          ? data['Vitamin C']
                                          : '';
                                  othermedsController.text =
                                      data.containsKey('Other Meds')
                                          ? data['Other Meds']
                                          : '';
                                  nextAppointmentController.text =
                                      data.containsKey('Next Appointment')
                                          ? data['Next Appointment']
                                          : '';
                                  toggleMode(true);
                                });
                              },
                            ),
                            const Text('Edit'),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteVisit(doc.id),
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
