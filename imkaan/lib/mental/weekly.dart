
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PsychDScreen extends StatefulWidget {
  final String clientId;

  const PsychDScreen({super.key, required this.clientId});

  @override
  _PsychDScreenState createState() => _PsychDScreenState();
}

class _PsychDScreenState extends State<PsychDScreen> with SingleTickerProviderStateMixin {
  // Controllers for Psych Details

  final Map<String, TextEditingController> lifeControllers = {
    'Economic_Problems': TextEditingController(),
    'Difficulty_accessing_healthcare': TextEditingController(),
    'Legal_issues_OR_crime': TextEditingController(),
    'Cultural_issues': TextEditingController(),
    'Family_issues': TextEditingController(),
    'Social_problems': TextEditingController(),
    'Educational_or_Occupational_issues': TextEditingController(),
    'Housing_problems': TextEditingController(),
    'Grief': TextEditingController(),
    'Others': TextEditingController(),
  };
 
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
    'Psych_visit': TextEditingController(),
  };

  bool suicidalThoughts = false;
  // Weekly Assessment fields
  final Map<String, dynamic> weeklyAssessmentData = {
    "I have felt tense, anxious, or nervous": 1,
    "I have felt I have someone to turn to for support when needed": 1,
    "I have felt able to cope when things go wrong": 1,
    "Talking to people has felt too much for me": 1,
    "I have felt panic or terror": 1,
    "I made plans to end my life": 1,
    "I have had difficulty getting to sleep or staying asleep": 1,
    "I have felt despairing or hopeless": 1,
    "I have felt unhappy": 1,
    "Unwanted images or memories have been distressing me": 1,
  };

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs now
    fetchWeeklyData();
    fetchPsychData();
    fetchLifeData();
  }

  @override
  void dispose() {
    for (var controller in lifeControllers.values) {
      controller.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }


  Future<void> fetchLifeData() async {
    try {
      DocumentSnapshot lifeData = await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('life')
          .doc('details')
          .get();

      if (lifeData.exists) {
        Map<String, dynamic> data = lifeData.data() as Map<String, dynamic>;
        setState(() {
          lifeControllers.forEach((key, controller) {
            controller.text = data[key]?.toString() ?? '';
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching life data: $e')),
      );
    }
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

  Future<void> fetchWeeklyData() async {
    try {
      DocumentSnapshot weeklyData = await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('Weekly')
          .doc('1') // Document ID '1'
          .get();

      if (weeklyData.exists) {
        Map<String, dynamic> data = weeklyData.data() as Map<String, dynamic>;
        setState(() {
          weeklyAssessmentData.clear();
          weeklyAssessmentData.addAll(data);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No document found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> saveLifeData() async {
    Map<String, dynamic> updatedData = {
      for (var entry in lifeControllers.entries) entry.key: entry.value.text,
    };

    try {
      await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('life')
          .doc('details')
          .set(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Life data updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving life data: $e')),
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

  Future<void> saveWeeklyData() async {
    try {
      await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('Weekly')
          .doc('1') // Updated to save to document with ID '1'
          .set(weeklyAssessmentData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CORE 10 data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }


  Widget buildLifeDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ...lifeControllers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key.replaceAll('_', ' '),
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveLifeData,
            child: const Text('Save Life Data'),
          ),
        ],
      ),
    );
  }

  Widget buildPsychTable() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
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

        // Suicidal Thoughts Toggle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Suicidal Thoughts", style: TextStyle(fontSize: 16)),
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
        ),

        // Suicidal Thoughts Details (conditionally visible)
        if (suicidalThoughts)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextField(
              controller: tableControllers['Suicidal_Thoughts_Details'],
              decoration: const InputDecoration(
                labelText: 'Suicidal Thoughts Details',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
        

      const SizedBox(height: 20),
          ElevatedButton(
            onPressed: savePsychData,
            child: const Text('Save Medical Data'),
          ),

      ],
    ),
  );
}


  Widget buildWeeklyAssessment() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ...weeklyAssessmentData.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text(entry.key),
                  const Spacer(),
                  DropdownButton<int>(
                    value: entry.value,
                    onChanged: (newValue) {
                      setState(() {
                        weeklyAssessmentData[entry.key] = newValue!;
                      });
                    },
                    items: [1, 2, 3, 4]
                        .map((value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveWeeklyData,
            child: const Text('Save CORE 10 Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(), // Pushes the logo to the right
            Text(
              'Patient Management',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 70, 61, 1),
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(), // Balances space on both sides
            Image.asset(
              'logo.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 30);
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFFCA03),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Life Details'),
            Tab(text: 'Medical Details'),
            Tab(text: 'CORE 10 Assessment'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildLifeDetails(),
          buildPsychTable(),
          buildWeeklyAssessment(),
        ],
      ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Weekly extends StatefulWidget {
//   final String clientId;

//   const Weekly({super.key, required this.clientId});

//   @override
//   _WeeklyScreenState createState() => _WeeklyScreenState();
// }

// class _WeeklyScreenState extends State<Weekly> {
//   List<Map<String, dynamic>> weeklyData = [];
//   TextEditingController newDocIdController = TextEditingController();
//   int? expandedIndex;

//   @override
//   void initState() {
//     super.initState();
//     fetchWeeklyData();
//   }

//   Future<void> fetchWeeklyData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('Mental')
//           .doc(widget.clientId)
//           .collection('Weekly')
//           .get();

//       setState(() {
//         weeklyData = querySnapshot.docs
//             .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
//             .toList();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching weekly data: $e')),
//       );
//     }
//   }

//   Future<void> saveWeeklyData(String docId, Map<String, dynamic> data) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Mental')
//           .doc(widget.clientId)
//           .collection('Weekly')
//           .doc(docId)
//           .set(data);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Weekly data saved successfully!')),
//       );
//       fetchWeeklyData();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving weekly data: $e')),
//       );
//     }
//   }

//   Widget buildDocBlock(Map<String, dynamic> weeklyDoc, int index) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: ListTile(
//         title: Text('Data of Week: ${weeklyDoc['id']}'),
//         onTap: () {
//           setState(() {
//             expandedIndex = index;
//           });
//         },
//       ),
//     );
//   }

//   Widget buildWeeklyForm(Map<String, dynamic> weeklyDoc, int index) {
//     List<String> fields = [
//       "I have felt tense, anxious, or nervous",
//       "I have felt I have someone to turn to for support when needed",
//       "I have felt able to cope when things go wrong",
//       "Talking to people has felt too much for me",
//       "I have felt panic or terror",
//       "I made plans to end my life",
//       "I have had difficulty getting to sleep or staying asleep",
//       "I have felt despairing or hopeless",
//       "I have felt unhappy",
//       "Unwanted images or memories have been distressing me"
//     ];

//     int totalScore = 0;
//     weeklyData[index].forEach((key, value) {
//       if (fields.contains(key)) {
//         totalScore += (value is int ? value : 0);
//       }
//     });

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ...fields.asMap().entries.map((entry) {
//               int fieldIndex = entry.key;
//               String field = entry.value;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(field, style: const TextStyle(fontSize: 16)),
//                   const SizedBox(height: 5),
//                   TextField(
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       int? intValue = int.tryParse(value);
//                       if (intValue != null && intValue >= 1 && intValue <= 4) {
//                         setState(() {
//                           weeklyData[index][field] = intValue;
//                         });
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Please enter a value between 1 and 4.')),
//                         );
//                       }
//                     },
//                     decoration: InputDecoration(
//                       hintText: weeklyDoc[field]?.toString() ?? '',
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//               );
//             }),
//             Text('Total Score: $totalScore', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 saveWeeklyData(weeklyDoc['id'], weeklyData[index]);
//               },
//               child: const Text('Save Changes'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   expandedIndex = null;
//                 });
//               },
//               child: const Text('Back to Block View'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildAddDocumentSection() {
//     return Column(
//       children: [
//         const Text(
//           'Add New Weekly Document',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         TextField(
//           controller: newDocIdController,
//           decoration: const InputDecoration(
//             labelText: 'Document ID',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () {
//             if (newDocIdController.text.isNotEmpty) {
//               setState(() {
//                 weeklyData.add({
//                   'id': newDocIdController.text,
//                 });
//                 expandedIndex = weeklyData.length - 1;
//               });
//               newDocIdController.clear();
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Please enter a valid document ID.')),
//               );
//             }
//           },
//           child: const Text('Add Document'),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Weekly Assessment'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (weeklyData.isEmpty) buildAddDocumentSection(),
//               if (weeklyData.isNotEmpty) ...[
//                 const Text(
//                   'Scale: 1 = Not at all, 2 = Rarely, 3 = Sometimes, 4 = Most of the time',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 ...weeklyData.asMap().entries.map((entry) {
//                   int index = entry.key;
//                   Map<String, dynamic> weeklyDoc = entry.value;
//                   return expandedIndex == index
//                       ? buildWeeklyForm(weeklyDoc, index)
//                       : buildDocBlock(weeklyDoc, index);
//                 }),
//                 const SizedBox(height: 20),
//                 buildAddDocumentSection(),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Weekly extends StatefulWidget {
//   final String clientId;

//   const Weekly({Key? key, required this.clientId}) : super(key: key);

//   @override
//   _WeeklyScreenState createState() => _WeeklyScreenState();
// }

// class _WeeklyScreenState extends State<Weekly> {
//   List<Map<String, dynamic>> weeklyData = [];
//   TextEditingController newDocIdController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchWeeklyData();
//   }

//   Future<void> fetchWeeklyData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('Mental')
//           .doc(widget.clientId)
//           .collection('Weekly')
//           .get();

//       setState(() {
//         weeklyData = querySnapshot.docs
//             .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
//             .toList();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching weekly data: $e')),
//       );
//     }
//   }

//   Future<void> saveWeeklyData(String docId, Map<String, dynamic> data) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Mental')
//           .doc(widget.clientId)
//           .collection('Weekly')
//           .doc(docId)
//           .set(data);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Weekly data saved successfully!')),
//       );
//       fetchWeeklyData();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving weekly data: $e')),
//       );
//     }
//   }

//   Widget buildWeeklyForm(Map<String, dynamic> weeklyDoc, int index) {
//     List<String> fields = [
//       "I have felt tense, anxious, or nervous",
//       "I have felt I have someone to turn to for support when needed",
//       "I have felt able to cope when things go wrong",
//       "Talking to people has felt too much for me",
//       "I have felt panic or terror",
//       "I made plans to end my life",
//       "I have had difficulty getting to sleep or staying asleep",
//       "I have felt despairing or hopeless",
//       "I have felt unhappy",
//       "Unwanted images or memories have been distressing me"
//     ];

//     int totalScore = 0;
//     weeklyData[index].forEach((key, value) {
//       if (fields.contains(key)) {
//         totalScore += (value is int ? value : 0);
//       }
//     });

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ...fields.asMap().entries.map((entry) {
//               int fieldIndex = entry.key;
//               String field = entry.value;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(field, style: const TextStyle(fontSize: 16)),
//                   const SizedBox(height: 5),
//                   TextField(
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       int? intValue = int.tryParse(value);
//                       if (intValue != null && intValue >= 1 && intValue <= 4) {
//                         setState(() {
//                           weeklyData[index][field] = intValue;
//                         });
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Please enter a value between 1 and 4.')),
//                         );
//                       }
//                     },
//                     decoration: InputDecoration(
//                       hintText: weeklyDoc[field]?.toString() ?? '',
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//               );
//             }).toList(),
//             Text('Total Score: $totalScore', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 saveWeeklyData(weeklyDoc['id'], weeklyData[index]);
//               },
//               child: const Text('Save Changes'),
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
//         title: const Text('Weekly Assessment'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Text(
//                 'Scale: 1 = Not at all, 2 = Rarely, 3 = Sometimes, 4 = Most of the time',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               ...weeklyData.asMap().entries.map((entry) => buildWeeklyForm(entry.value, entry.key)).toList(),
//               const SizedBox(height: 20),
//               const Text(
//                 'Add New Weekly Document',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 controller: newDocIdController,
//                 decoration: const InputDecoration(
//                   labelText: 'Document ID',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   if (newDocIdController.text.isNotEmpty) {
//                     setState(() {
//                       weeklyData.add({
//                         'id': newDocIdController.text,
//                       });
//                     });
//                     newDocIdController.clear();
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Please enter a valid document ID.')),
//                     );
//                   }
//                 },
//                 child: const Text('Add Document'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
