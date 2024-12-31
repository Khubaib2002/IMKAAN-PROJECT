import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PsychDetailsScreen extends StatefulWidget {
  final String clientId;

  const PsychDetailsScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  _PsychDetailsScreenState createState() => _PsychDetailsScreenState();
}

class _PsychDetailsScreenState extends State<PsychDetailsScreen> {
  final Map<String, TextEditingController> tableControllers = {
    'Psych_Medication': TextEditingController(),
    'Other_Illnesses': TextEditingController(),
    'Other_Medication': TextEditingController(),
    'Alcohol_Drug_Use': TextEditingController(),
    'Informant_Name': TextEditingController(),
    'Informant_Relation': TextEditingController(),
    'Source_of_Referral': TextEditingController(),
    'Nature_of_Problem': TextEditingController(),
    'Mental_Health_Check_Date': TextEditingController(),
    'Outcomes': TextEditingController(),
    'Suicidal_Thoughts_Details': TextEditingController(),
  };

  bool suicidalThoughts = false;

  @override
  void initState() {
    super.initState();
    fetchPsychData();
  }

  Future<void> fetchPsychData() async {
    try {
      DocumentSnapshot psychData = await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('psych')
          .doc('details')
          .get();

      if (psychData.exists) {
        Map<String, dynamic> data = psychData.data() as Map<String, dynamic>;
        setState(() {
          tableControllers.forEach((key, controller) {
            controller.text = data[key]?.toString() ?? '';
          });
          suicidalThoughts = data['Suicidal_Thoughts'] ?? false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> savePsychData() async {
    Map<String, dynamic> updatedData = {
      for (var entry in tableControllers.entries) entry.key: entry.value.text,
      'Suicidal_Thoughts': suicidalThoughts,
    };

    try {
      await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('psych')
          .doc('details')
          .set(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  Widget buildPsychTable() {
    return Column(
      children: [
        for (var entry in tableControllers.entries)
          if (entry.key != 'Suicidal_Thoughts_Details' || suicidalThoughts)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key.replaceAll('_', ' '),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
        Row(
          children: [
            const Text("Suicidal Thoughts"),
            Switch(
              value: suicidalThoughts,
              onChanged: (value) {
                setState(() {
                  suicidalThoughts = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psych Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildPsychTable(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: savePsychData,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in tableControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
