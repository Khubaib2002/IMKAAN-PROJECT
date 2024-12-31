import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FamilyScreen extends StatefulWidget {
  final String clientId;

  const FamilyScreen({Key? key, required this.clientId}) : super(key: key);

  @override
  _FamilyScreenState createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  Map<String, dynamic> familyData = {};
  List<Map<String, dynamic>> childrenData = [];
  TextEditingController newChildNameController = TextEditingController();
  TextEditingController newChildDobController = TextEditingController();
  TextEditingController newChildSexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFamilyData();
  }

  Future<void> fetchFamilyData() async {
    try {
      DocumentSnapshot familyDoc = await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('Family')
          .doc('details')
          .get();

      if (familyDoc.exists) {
        setState(() {
          familyData = familyDoc.data() as Map<String, dynamic>;
          childrenData = List<Map<String, dynamic>>.from(familyData['Children'] ?? []);
        });
      } else {
        setState(() {
          familyData = {};
          childrenData = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching family data: $e')),
      );
    }
  }

  Future<void> saveFamilyData() async {
    try {
      familyData['Children'] = childrenData;
      await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('Family')
          .doc('details')
          .set(familyData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Family data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving family data: $e')),
      );
    }
  }

  Widget buildFamilyForm(String label, String key, {bool isNumeric = false}) {
    return TextField(
      controller: TextEditingController(text: familyData[key]?.toString() ?? ''),
      onChanged: (value) => familyData[key] = isNumeric ? int.tryParse(value) : value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildChildForm(Map<String, dynamic> child, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: child['name']),
              onChanged: (value) => childrenData[index]['name'] = value,
              decoration: const InputDecoration(
                labelText: 'Child Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: TextEditingController(text: child['dob']),
              onChanged: (value) => childrenData[index]['dob'] = value,
              decoration: const InputDecoration(
                labelText: 'Child DOB',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: TextEditingController(text: child['sex']),
              onChanged: (value) => childrenData[index]['sex'] = value,
              decoration: const InputDecoration(
                labelText: 'Child Sex',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  childrenData.removeAt(index);
                });
              },
              child: const Text('Remove Child'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Parent Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buildFamilyForm('Father Name', 'Father_name'),
              const SizedBox(height: 10),
              buildFamilyForm('Father DOB', 'Father_dob'),
              const SizedBox(height: 10),
              buildFamilyForm('Father Education', 'Father_education'),
              const SizedBox(height: 10),
              buildFamilyForm('Father Marital Status', 'Father_MaritalStatus'),
              const SizedBox(height: 10),
              buildFamilyForm('Father Number of Marriages', 'Father_numberofmarriages', isNumeric: true),
              const SizedBox(height: 20),
              buildFamilyForm('Mother Name', 'Mother_name'),
              const SizedBox(height: 10),
              buildFamilyForm('Mother DOB', 'Mother_dob'),
              const SizedBox(height: 10),
              buildFamilyForm('Mother Education', 'Mother_education'),
              const SizedBox(height: 10),
              buildFamilyForm('Mother Marital Status', 'Mother_MaritalStatus'),
              const SizedBox(height: 10),
              buildFamilyForm('Mother Number of Marriages', 'Mother_numberofmarriages', isNumeric: true),
              const SizedBox(height: 20),

              const Text(
                'Spouse Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              buildFamilyForm('Spouse Name', 'Spouse_name'),
              const SizedBox(height: 10),
              buildFamilyForm('Spouse DOB', 'Spouse_dob'),
              const SizedBox(height: 10),
              buildFamilyForm('Spouse Education', 'Spouse_education'),
              const SizedBox(height: 10),
              buildFamilyForm('Spouse Number of Marriages', 'Spouse_numberofmarriages', isNumeric: true),
              const SizedBox(height: 20),

              const Text(
                'Children Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...childrenData.asMap().entries.map((entry) => buildChildForm(entry.value, entry.key)).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    childrenData.add({'name': '', 'dob': '', 'sex': ''});
                  });
                },
                child: const Text('Add Child'),
              ),
              const SizedBox(height: 20),
              buildFamilyForm('Family Structure', 'Family_structure'),
              const SizedBox(height: 10),
              buildFamilyForm('Languages Spoken (comma-separated)', 'Languages_spoken'),
              const SizedBox(height: 10),
              buildFamilyForm('Monthly Income (PKR)', 'Monthly_income_pkr', isNumeric: true),
              const SizedBox(height: 10),
              buildFamilyForm('Number of Siblings', 'Number_of_siblings', isNumeric: true),
              const SizedBox(height: 10),
              buildFamilyForm('Number of Step Siblings', 'Number_of_step_siblings', isNumeric: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveFamilyData,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FamilyScreen extends StatefulWidget {
//   final String clientId;

//   const FamilyScreen({Key? key, required this.clientId}) : super(key: key);

//   @override
//   _FamilyScreenState createState() => _FamilyScreenState();
// }

// class _FamilyScreenState extends State<FamilyScreen> {
//   List<Map<String, dynamic>> familyMembers = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchFamilyData();
//   }

//   Future<void> fetchFamilyData() async {
//     try {
//       QuerySnapshot familySnapshot = await FirebaseFirestore.instance
//           .collection('Mental')
//           .doc(widget.clientId)
//           .collection('Family')
//           .get();

//       List<Map<String, dynamic>> filteredFamily = familySnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();

//       setState(() {
//         familyMembers = filteredFamily;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching family data: $e')),
//       );
//     }
//   }

//   Future<void> saveFamilyData() async {
//     try {
//       WriteBatch batch = FirebaseFirestore.instance.batch();

//       for (var member in familyMembers) {
//         DocumentReference docRef = FirebaseFirestore.instance
//             .collection('Mental')
//             .doc(widget.clientId)
//             .collection('Family')
//             .doc(member['FamilyMember_ID'].toString());
//         batch.set(docRef, member);
//       }

//       await batch.commit();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Family data saved successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving family data: $e')),
//       );
//     }
//   }

//   Widget buildFamilyMemberCard(Map<String, dynamic> member) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: TextEditingController(
//                   text: member['F_name']?.toString() ?? ''),
//               onChanged: (value) => member['F_name'] = value,
//               decoration: const InputDecoration(
//                 labelText: 'Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: TextEditingController(
//                   text: member['F_education']?.toString() ?? ''),
//               onChanged: (value) => member['F_education'] = value,
//               decoration: const InputDecoration(
//                 labelText: 'Education',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: TextEditingController(
//                   text: member['F_Occupation']?.toString() ?? ''),
//               onChanged: (value) => member['F_Occupation'] = value,
//               decoration: const InputDecoration(
//                 labelText: 'Occupation',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: TextEditingController(
//                   text: member['F_marital_Status']?.toString() ?? ''),
//               onChanged: (value) => member['F_marital_Status'] = value,
//               decoration: const InputDecoration(
//                 labelText: 'Marital Status',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Relationship to Client: ${member['Relationship_to_Client']?.toString() ?? ''}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Family Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ...familyMembers.map(buildFamilyMemberCard).toList(),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: saveFamilyData,
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
