import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imkaan/services/db.dart';
import 'package:intl/intl.dart';

class PreviousDeliveryPage extends StatefulWidget {
  final String patientId;

  const PreviousDeliveryPage({super.key, required this.patientId});

  @override
  State<PreviousDeliveryPage> createState() => _PreviousDeliveryPageState();
}

class _PreviousDeliveryPageState extends State<PreviousDeliveryPage> {
  final DatabaseService _databaseService = DatabaseService();

  final TextEditingController yearController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool outcome = false;

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        yearController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Deliveries'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Delivery:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: yearController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectYear(context),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Outcome:'),
                    Checkbox(
                      value: outcome,
                      onChanged: (value) {
                        setState(() {
                          outcome = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _databaseService.insertPreviousDelivery(
                      widget.patientId,
                      DateTime.parse(yearController.text),
                      typeController.text,
                      locationController.text,
                      outcome,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('New Delivery Added Successfully!')),
                    );
                    setState(() {
                      yearController.clear();
                      typeController.clear();
                      locationController.clear();
                      outcome = false;
                    });
                  },
                  child: const Text('Add Delivery'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _databaseService.getPreviousDeliveries(widget.patientId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Previous Deliveries Found'),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    TextEditingController yearUpdateController =
                        TextEditingController(text: doc['year']);
                    TextEditingController typeUpdateController =
                        TextEditingController(text: doc['type']);
                    TextEditingController locationUpdateController =
                        TextEditingController(text: doc['location']);
                    bool outcomeUpdate = doc['outcome'];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextField(
                            controller: yearUpdateController,
                            decoration:
                                const InputDecoration(labelText: 'Year'),
                          ),
                          TextField(
                            controller: typeUpdateController,
                            decoration:
                                const InputDecoration(labelText: 'Type'),
                          ),
                          TextField(
                            controller: locationUpdateController,
                            decoration:
                                const InputDecoration(labelText: 'Location'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Outcome:'),
                              Checkbox(
                                value: outcomeUpdate,
                                onChanged: (value) {
                                  outcomeUpdate = value ?? false;
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _databaseService.updatePreviousDelivery(
                                doc.id,
                                widget.patientId,
                                DateTime.parse(yearUpdateController.text),
                                typeUpdateController.text,
                                locationUpdateController.text,
                                outcomeUpdate,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Previous Delivery Updated Successfully!')),
                              );
                            },
                            child: const Text('Update Delivery'),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
