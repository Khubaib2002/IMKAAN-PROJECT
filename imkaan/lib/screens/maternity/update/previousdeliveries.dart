import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Previousdeliveries extends StatefulWidget {
  final String patientId, name;
  const Previousdeliveries({required this.patientId, required this.name});

  @override
  State<Previousdeliveries> createState() => _PreviousdeliveriesState();
}

class _PreviousdeliveriesState extends State<Previousdeliveries> {
  // Previous deliveries
  bool isUpdating = false;
  String docid = '';
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
        'Date of Delivery': age,
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

  void toggleMode(bool updating) {
    setState(() {
      isUpdating = updating;
      // clearFields();
    });
  }

  void clearFields() {
    setState(() {
      docid = '';
      dateController.clear();
      typeController.clear();
      LocationController.clear();
      prevbabyalive = false;
    });
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
        'Date of Delivery': age,
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
          title: const Text('Medical Records'),
        ),
        body: const Center(
          child: Text(
            'Please select a patient to add or update previous deliveries.',
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
                Text(
                  'Patient Name: ${widget.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 20),
                Text(isUpdating ? 'Update Delivery File' : 'Add Delivery File',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
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
                    if (widget.patientId.isEmpty ||
                        dateController.text.isEmpty ||
                        typeController.text.isEmpty ||
                        LocationController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Please fill in all required fields before saving.')));
                      return;
                    }
                    if (isUpdating) {
                      updatepreviousdelivery(
                          widget.patientId,
                          docid,
                          dateController.text,
                          typeController.text,
                          LocationController.text,
                          prevbabyalive.toString());
                    } else {
                      addprevdelivery(
                        widget.patientId,
                        dateController.text,
                        typeController.text,
                        LocationController.text,
                        prevbabyalive.toString(),
                      );
                    }
                    clearFields();
                    toggleMode(false);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                    child: Text(isUpdating ? 'Update' : 'Add',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Previous deliveries',
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
                        docid = document.id;
                        final data = document.data() as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            title: Text(document['Date of Delivery']),
                            subtitle: Text(document['Type']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    toggleMode(true);
                                    dateController.text =
                                        document['Date of Delivery'];
                                    typeController.text = document['Type'];
                                    LocationController.text =
                                        document['Location'];
                                    prevbabyalive =
                                        document['Baby Alive'] == 'true'
                                            ? true
                                            : false;
                                  },
                                ),
                                const Text('Edit'),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    deletePreviousDelivery(
                                        widget.patientId, document.id);
                                    clearFields();
                                  },
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
            )),
      ),
    );
  }
}
