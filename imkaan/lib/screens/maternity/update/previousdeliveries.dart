import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Previousdeliveries extends StatefulWidget {
  final String patientId;
  const Previousdeliveries({required this.patientId});

  @override
  State<Previousdeliveries> createState() => _PreviousdeliveriesState();
}

class _PreviousdeliveriesState extends State<Previousdeliveries> {
  // Previous deliveries
  TextEditingController dateController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  bool prevbabyalive = false;

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
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> addprevdelivery(
    // Saving discharge info to Firestore (under deliveryfiles subcollection)
    String patientid,
    String age,
    String type,
    String location,
    String prevbabyalive,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientid)
          .collection('prevdeliveries')
          .add({
        'Age': age,
        'Type': type,
        'Location': location,
        'Baby Alive': prevbabyalive,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Previous delivery saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> updatepreviousdelivery(String patientid, String prevdeliveryid,
      String age, String type, String location, String prevbabyalive) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientid)
          .collection('prevdeliveries')
          .doc(prevdeliveryid)
          .set({
        'Age': age,
        'Type': type,
        'Location': location,
        'Baby Alive': prevbabyalive,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Previous Delivery information updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> deletePreviousDelivery(
      String patientid, String prevdeliveryid) async {
    try {
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientid)
          .collection('prevdeliveries')
          .doc(prevdeliveryid)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Previous Delivery deleted successfully!')));
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
          title: const Text('Delivery Files'),
        ),
        body: const Center(
          child: Text(
            'Please select a patient or add a patient to add or update previous deliveries information.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Or Update Previous Deliveries'),
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
                const SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: typeController,
                  decoration:
                      const InputDecoration(labelText: 'Mode/Type of Birth'),
                ),
                TextField(
                  controller: LocationController,
                  decoration:
                      const InputDecoration(labelText: 'Location of Birth'),
                ),
                CheckboxListTile(
                  value: prevbabyalive,
                  onChanged: (val) => setState(() => prevbabyalive = val!),
                  title: const Text('Baby Alive'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    addprevdelivery(
                      widget.patientId,
                      dateController.text,
                      typeController.text,
                      LocationController.text,
                      prevbabyalive.toString(),
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
                  'Saved previous deliveries',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Patients')
                      .doc(widget.patientId)
                      .collection('prevdeliveries')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('No Previous Delivery Files Found'));
                    }
                    return Column(
                      children: snapshot.data!.docs.map<Widget>((document) {
                        return Card(
                          child: ListTile(
                            title: Text(document['Age']),
                            subtitle: Text(document['Type']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    dateController.text = document['Age'];
                                    typeController.text = document['Type'];
                                    LocationController.text =
                                        document['Location'];
                                    prevbabyalive = document['Baby Alive'];
                                    updatepreviousdelivery(
                                      widget.patientId,
                                      document.id,
                                      dateController.text,
                                      typeController.text,
                                      LocationController.text,
                                      prevbabyalive.toString(),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    deletePreviousDelivery(
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
            )),
      ),
    );
  }
}
