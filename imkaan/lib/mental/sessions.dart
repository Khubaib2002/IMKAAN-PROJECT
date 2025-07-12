import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Weekly extends StatefulWidget {
  final String clientId;

  const Weekly({super.key, required this.clientId});

  @override
  _WeeklyScreenState createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<Weekly> {
  List<Map<String, dynamic>> weeklyData = [];
  TextEditingController newDocIdController = TextEditingController();
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    fetchWeeklyData();
  }

  Future<void> fetchWeeklyData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('sessions')
          .get();

      setState(() {
        weeklyData = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weekly data: $e')),
      );
    }
  }

  Future<void> saveWeeklyData(String docId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('sessions')
          .doc(docId)
          .set(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session data saved successfully!')),
      );
      fetchWeeklyData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  Widget buildDocBlock(Map<String, dynamic> weeklyDoc, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text('Data of Session: ${weeklyDoc['id']}'),
        onTap: () {
          setState(() {
            expandedIndex = index;
          });
        },
      ),
    );
  }

  Widget buildWeeklyForm(Map<String, dynamic> weeklyDoc, int index) {
    List<String> fields = [
      "Purpose_of_visit",
      "Nature_of_session",
      "Pre_Session",
      "Talking to people has felt too much for me",
      "Post_Session",
      "Next_Step",
      "Sign_Name",
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...fields.asMap().entries.map((entry) {
              // int fieldIndex = entry.key;
              String field = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(field, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  TextField(
                    keyboardType: TextInputType.text, // Allow text input
                    onChanged: (value) {
                      setState(() {
                        weeklyData[index][field] = value; // Store as text
                      });
                    },
                    decoration: InputDecoration(
                      hintText: weeklyDoc[field]?.toString() ?? '',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveWeeklyData(weeklyDoc['id'], weeklyData[index]);
                  },
                  child: const Text('Save Changes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      expandedIndex = null;
                    });
                  },
                  child: const Text('Back to Block View'),
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     saveWeeklyData(weeklyDoc['id'], weeklyData[index]);
            //   },
            //   child: const Text('Save Changes'),
            // ),
            const SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       expandedIndex = null;
            //     });
            //   },
            //   child: const Text('Back to Block View'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildAddDocumentSection() {
    return Column(
      children: [
        const Text(
          'Add New Session Log',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: newDocIdController,
          decoration: const InputDecoration(
            labelText: 'Document ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (newDocIdController.text.isNotEmpty) {
              setState(() {
                weeklyData.add({
                  'id': newDocIdController.text,
                });
                expandedIndex = weeklyData.length - 1;
              });
              newDocIdController.clear();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid document ID.')),
              );
            }
          },
          child: const Text('Add session data'),
        ),
      ],
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
              'Session Logs',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (weeklyData.isEmpty) buildAddDocumentSection(),
              if (weeklyData.isNotEmpty) ...[
                const SizedBox(height: 20),
                ...weeklyData.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> weeklyDoc = entry.value;
                  return expandedIndex == index
                      ? buildWeeklyForm(weeklyDoc, index)
                      : buildDocBlock(weeklyDoc, index);
                }),
                const SizedBox(height: 20),
                buildAddDocumentSection(),
              ],
            ],
          ),
        ),
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
//           .collection('sessions')
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
//           .collection('sessions')
//           .doc(docId)
//           .set(data);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Session data saved successfully!')),
//       );
//       fetchWeeklyData();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving data: $e')),
//       );
//     }
//   }

//   Widget buildDocBlock(Map<String, dynamic> weeklyDoc, int index) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: ListTile(
//         title: Text('Data of Session: ${weeklyDoc['id']}'),
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
//       "Purpose_of_visit",
//       "Nature_of_session",
//       "Pre_Session",
//       "Talking to people has felt too much for me",
//       "Post_Session",
//       "Next_Step",
//       "Sign_Name",
//     ];

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
//           'Add New Session Log',
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
//           child: const Text('Add session data'),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Session Logs'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (weeklyData.isEmpty) buildAddDocumentSection(),
//               if (weeklyData.isNotEmpty) ...[
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