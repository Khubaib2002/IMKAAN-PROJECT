// import 'package:flutter/material.dart';
// import 'package:imkaan/mental/psych.dart';
// import 'package:imkaan/mental/family.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MentalHealthDatabaseService {
//   final CollectionReference clients =
//       FirebaseFirestore.instance.collection('Mental');

//   Future<DocumentSnapshot?> getClientData(String clientId) async {
//     try {
//       DocumentSnapshot snapshot = await clients.doc(clientId).get();
//       return snapshot.exists ? snapshot : null;
//     } catch (e) {
//       debugPrint('Error fetching client data: $e');
//       return null;
//     }
//   }
// }

// class UpdateUser extends StatefulWidget {
//   const UpdateUser({super.key});

//   @override
//   _ClientManagementState createState() => _ClientManagementState();
// }

// class _ClientManagementState extends State<UpdateUser> {
//   final MentalHealthDatabaseService _databaseService =
//       MentalHealthDatabaseService();

//   // Main form controllers
//   final TextEditingController clientIDController = TextEditingController();
//   final TextEditingController cnicController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController altPhoneNumberController = TextEditingController();
//   final TextEditingController educationController = TextEditingController();
//   final TextEditingController occupationController = TextEditingController();
//   final TextEditingController numberOfMarriagesController = TextEditingController();
//   final TextEditingController numberOfChildrenController = TextEditingController();

//   bool psychVisit = false;
//   String clientID = '';

//   String selectedGender = 'M';
//   String selectedMaritalStatus = 'Single';

//   void populateFields(Map<String, dynamic> data) {
//     setState(() {
//       cnicController.text = data['CNIC'].toString();
//       nameController.text = data['Name'];
//       dobController.text = data['DOB'];
//       selectedGender = data['Gender'];
//       phoneNumberController.text = data['Phone_Number'].toString();
//       altPhoneNumberController.text = data['Alt_Phone_Number'].toString();
//       selectedMaritalStatus = data['Marital_Status'];
//       educationController.text = data['Education'];
//       occupationController.text = data['Occupation'];
//       numberOfMarriagesController.text = data['Number_of_Marriages'].toString();
//       numberOfChildrenController.text = data['Number_of_Children'].toString();
//       psychVisit = data['psychVisit'] ?? false;
//     });
//   }

//   Future<void> searchClient() async {
//     clientID = clientIDController.text.trim();
//     if (clientID.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a Client ID')),
//       );
//       return;
//     }

//     DocumentSnapshot? client = await _databaseService.getClientData(clientID);
//     if (client == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Client ID not found')),
//       );
//     } else {
//       populateFields(client.data() as Map<String, dynamic>);
//     }
//   }

//   Future<void> updateClientData() async {
//     if (clientID.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No Client ID selected')),
//       );
//       return;
//     }

//     try {
//       await _databaseService.clients.doc(clientID).update({
//         'CNIC': cnicController.text.trim(),
//         'Name': nameController.text.trim(),
//         'DOB': dobController.text.trim(),
//         'Gender': selectedGender,
//         'Phone_Number': phoneNumberController.text.trim(),
//         'Alt_Phone_Number': altPhoneNumberController.text.trim(),
//         'Marital_Status': selectedMaritalStatus,
//         'Education': educationController.text.trim(),
//         'Occupation': occupationController.text.trim(),
//         'Number_of_Marriages': int.tryParse(numberOfMarriagesController.text.trim()) ?? 0,
//         'Number_of_Children': int.tryParse(numberOfChildrenController.text.trim()) ?? 0,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Data updated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update data: $e')),
//       );
//     }
//   }

//   Future<void> updatePsychVisit(bool value) async {
//     if (clientID.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No Client ID selected')),
//       );
//       return;
//     }
//     try {
//       await _databaseService.clients.doc(clientID).update({'psychVisit': value});
//       setState(() {
//         psychVisit = value;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Psych Visit updated successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to update Psych Visit')),
//       );
//     }
//   }

//   Widget buildClientIDField() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: clientIDController,
//             decoration: const InputDecoration(
//               labelText: 'Client ID',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         ElevatedButton(
//           onPressed: searchClient,
//           child: const Text('Search'),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mental Health Clinic - Client Management'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               buildClientIDField(),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: cnicController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'CNIC',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: dobController,
//                 decoration: const InputDecoration(
//                   labelText: 'Date of Birth',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: phoneNumberController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: altPhoneNumberController,
//                 decoration: const InputDecoration(
//                   labelText: 'Alternate Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: educationController,
//                 decoration: const InputDecoration(
//                   labelText: 'Education',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: occupationController,
//                 decoration: const InputDecoration(
//                   labelText: 'Occupation',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: numberOfMarriagesController,
//                 decoration: const InputDecoration(
//                   labelText: 'Number Of Marriages',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: numberOfChildrenController,
//                 decoration: const InputDecoration(
//                   labelText: 'Number Of Children',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   const Text("Psych Visit"),
//                   Switch(
//                     value: psychVisit,
//                     onChanged: (value) async {
//                       await updatePsychVisit(value);
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               if (psychVisit)
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PsychDetailsScreen(clientId: clientID),
//                       ),
//                     );
//                   },
//                   child: const Text('Go to Psych Details'),
//                 ),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => FamilyScreen(clientId: clientID),
//                       ),
//                     );
//                   },
//                   child: const Text('Family Information'),
//                 ),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                   onPressed: () async {
//                     await updateClientData(); // Call the update function
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Data Saved!')), // Show confirmation snackbar
//                     );
//                   },
//                   child: const Text('Save'),
//                 ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
// import 'package:imkaan/mental/psych.dart';
import 'package:imkaan/mental/family.dart';
import 'package:imkaan/mental/sessions.dart';
import 'package:imkaan/mental/weekly.dart';
import 'package:imkaan/mental/psychlogs.dart';
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
  final TextEditingController altPhoneNumberController =
      TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController numberOfMarriagesController =
      TextEditingController();
  final TextEditingController numberOfChildrenController =
      TextEditingController();

  // bool psychVisit = false;
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
      // psychVisit = data['psychVisit'] ?? false;
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
        'Number_of_Marriages':
            int.tryParse(numberOfMarriagesController.text.trim()) ?? 0,
        'Number_of_Children':
            int.tryParse(numberOfChildrenController.text.trim()) ?? 0,
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

  // Future<void> updatePsychVisit(bool value) async {
  //   if (clientID.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No Client ID selected')),
  //     );
  //     return;
  //   }
  //   try {
  //     await _databaseService.clients.doc(clientID).update({'psychVisit': value});
  //     setState(() {
  //       psychVisit = value;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Psych Visit updated successfully')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to update Psych Visit')),
  //     );
  //   }
  // }

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

              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Light background color
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    border: Border.all(
                        color: Colors.blueAccent,
                        width: 2), // Border color and width
                  ),
                  child: DropdownButton<String>(
                    value: selectedGender,
                    isExpanded: true, // Makes the dropdown expand fully
                    dropdownColor: Colors.white, // Dropdown menu background
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    icon: Icon(Icons.arrow_drop_down,
                        color: Colors.blueAccent), // Custom dropdown icon
                    items: [
                      DropdownMenuItem(
                        value: 'M',
                        child: Row(
                          children: [
                            Icon(Icons.male,
                                color: Colors.blue), // Icon for Male
                            SizedBox(width: 10), // Space between icon and text
                            Text('Male',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'F',
                        child: Row(
                          children: [
                            Icon(Icons.female,
                                color: Colors.pink), // Icon for Female
                            SizedBox(width: 10), // Space between icon and text
                            Text('Female',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Other',
                        child: Row(
                          children: [
                            Icon(Icons.person,
                                color: Colors.grey), // Icon for Other
                            SizedBox(width: 10), // Space between icon and text
                            Text('Other',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
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
              // const SizedBox(height: 20),
              // Row(
              //   children: [
              //     const Text("Psych Visit"),
              //     Switch(
              //       value: psychVisit,
              //       onChanged: (value) async {
              //         await updatePsychVisit(value);
              //       },
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: clientID.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PsychDScreen(clientId: clientID),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter a valid Client ID first')),
                            );
                          },
                    child: const Text('Medical History'),
                  ),
                  ElevatedButton(
                    onPressed: clientID.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FamilyScreen(clientId: clientID),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter a valid Client ID first')),
                            );
                          },
                    child: const Text('Family Information'),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: clientID.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Weekly(clientId: clientID),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter a valid Client ID first')),
                            );
                          },
                    child: const Text('View Weekly Data'),
                  ),
                  ElevatedButton(
                    onPressed: clientID.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Logs(clientId: clientID),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter a valid Client ID first')),
                            );
                          },
                    child: const Text('Psychologist Visits'),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: clientID.isNotEmpty
                    ? () async {
                        await updateClientData(); // Call the update function
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Data Saved!')), // Show confirmation snackbar
                        );
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please enter a valid Client ID first')),
                        );
                      },
                child: const Text('Save'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
