import 'package:flutter/material.dart';
import 'package:imkaan/mental/psych.dart';
import 'package:imkaan/mental/family.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MentalHealthDatabaseService {
  final CollectionReference clients =
      FirebaseFirestore.instance.collection('Mental');

  Future<DocumentSnapshot?> getClientData(String clientId) async {
    try {
      DocumentSnapshot snapshot = await clients.doc(clientId).get();
      return snapshot.exists ? snapshot : null;
    } catch (e) {
      debugPrint('Error fetching client data: $e');
      return null;
    }
  }
}

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  _ClientManagementState createState() => _ClientManagementState();
}

class _ClientManagementState extends State<UpdateUser> {
  final MentalHealthDatabaseService _databaseService =
      MentalHealthDatabaseService();

  // Main form controllers
  final TextEditingController clientIDController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController altPhoneNumberController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController numberOfMarriagesController = TextEditingController();
  final TextEditingController numberOfChildrenController = TextEditingController();

  bool psychVisit = false;
  String clientID = '';

  String selectedGender = 'M';
  String selectedMaritalStatus = 'Single';

  void populateFields(Map<String, dynamic> data) {
    setState(() {
      cnicController.text = data['CNIC'].toString();
      nameController.text = data['Name'];
      dobController.text = data['DOB'];
      selectedGender = data['Gender'];
      phoneNumberController.text = data['Phone_Number'].toString();
      altPhoneNumberController.text = data['Alt_Phone_Number'].toString();
      selectedMaritalStatus = data['Marital_Status'];
      educationController.text = data['Education'];
      occupationController.text = data['Occupation'];
      numberOfMarriagesController.text = data['Number_of_Marriages'].toString();
      numberOfChildrenController.text = data['Number_of_Children'].toString();
      psychVisit = data['psychVisit'] ?? false;
    });
  }

  Future<void> searchClient() async {
    clientID = clientIDController.text.trim();
    if (clientID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Client ID')),
      );
      return;
    }

    DocumentSnapshot? client = await _databaseService.getClientData(clientID);
    if (client == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client ID not found')),
      );
    } else {
      populateFields(client.data() as Map<String, dynamic>);
    }
  }

  Future<void> updateClientData() async {
    if (clientID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Client ID selected')),
      );
      return;
    }

    try {
      await _databaseService.clients.doc(clientID).update({
        'CNIC': cnicController.text.trim(),
        'Name': nameController.text.trim(),
        'DOB': dobController.text.trim(),
        'Gender': selectedGender,
        'Phone_Number': phoneNumberController.text.trim(),
        'Alt_Phone_Number': altPhoneNumberController.text.trim(),
        'Marital_Status': selectedMaritalStatus,
        'Education': educationController.text.trim(),
        'Occupation': occupationController.text.trim(),
        'Number_of_Marriages': int.tryParse(numberOfMarriagesController.text.trim()) ?? 0,
        'Number_of_Children': int.tryParse(numberOfChildrenController.text.trim()) ?? 0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update data: $e')),
      );
    }
  }


  Future<void> updatePsychVisit(bool value) async {
    if (clientID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Client ID selected')),
      );
      return;
    }
    try {
      await _databaseService.clients.doc(clientID).update({'psychVisit': value});
      setState(() {
        psychVisit = value;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Psych Visit updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update Psych Visit')),
      );
    }
  }

  Widget buildClientIDField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: clientIDController,
            decoration: const InputDecoration(
              labelText: 'Client ID',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: searchClient,
          child: const Text('Search'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Clinic - Client Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildClientIDField(),
              const SizedBox(height: 20),
              TextField(
                controller: cnicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CNIC',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: altPhoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Alternate Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: educationController,
                decoration: const InputDecoration(
                  labelText: 'Education',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: numberOfMarriagesController,
                decoration: const InputDecoration(
                  labelText: 'Number Of Marriages',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: numberOfChildrenController,
                decoration: const InputDecoration(
                  labelText: 'Number Of Children',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Psych Visit"),
                  Switch(
                    value: psychVisit,
                    onChanged: (value) async {
                      await updatePsychVisit(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (psychVisit)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PsychDetailsScreen(clientId: clientID),
                      ),
                    );
                  },
                  child: const Text('Go to Psych Details'),
                ),
              const SizedBox(height: 20),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FamilyScreen(clientId: clientID),
                      ),
                    );
                  },
                  child: const Text('Family Information'),
                ),
              const SizedBox(height: 20),

              ElevatedButton(
                  onPressed: () async {
                    await updateClientData(); // Call the update function
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data Saved!')), // Show confirmation snackbar
                    );
                  },
                  child: const Text('Save'),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
