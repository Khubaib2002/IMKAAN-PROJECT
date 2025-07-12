import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:imkaan/mental/details.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchPatientState();
}

class _SearchPatientState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  String searchKey = "";

  Stream<List<DocumentSnapshot>> _searchPatients() {
    if (searchKey.isEmpty) {
      // Return all patients if no search key is provided
      return FirebaseFirestore.instance
          .collection('Mental') //
          .snapshots()
          .map((snapshot) => snapshot.docs);
    } else {
      // Perform search on `Name` and `Client_ID` fields
      final nameQuery = FirebaseFirestore.instance
          .collection('Mental') // A
          .where('Name', isGreaterThanOrEqualTo: searchKey)
          .where('Name', isLessThan: '$searchKey\uf8ff')
          .snapshots();

      final clientIdQuery = FirebaseFirestore.instance
          .collection('Mental') //
          .where('Client_ID', isGreaterThanOrEqualTo: searchKey)
          .where('Client_ID', isLessThan: '$searchKey\uf8ff')
          .snapshots();

      // Combine the results of the two queries (Name and Client_ID)
      return Rx.combineLatest2<QuerySnapshot, QuerySnapshot,
          List<DocumentSnapshot>>(
        nameQuery,
        clientIdQuery,
        (nameResult, clientIdResult) {
          final allDocs = [
            ...nameResult.docs,
            ...clientIdResult.docs,
          ];
          // Remove duplicates by document ID to avoid redundancy
          return allDocs.toSet().toList();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(),
            Text(
              'Search Patients',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 70, 61, 1),
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'logo.png',
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 30);
                },
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFFCA03),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 249, 246, 220),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Name or ID',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchKey = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter a name or patient ID to search',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _searchPatients(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Patients Found',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    );
                  }

                  return ListView(
                    children: snapshot.data!.map((doc) {
                      final data = doc.data() as Map<String, dynamic>?;
                      if (data == null) return const SizedBox.shrink();

                      final name = data['Name'] ?? 'Unknown';
                      final patientId = doc.id;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                  documentId: patientId, patientName: name),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10.0),
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            subtitle: Text(
                              "ID: $patientId",
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 70, 61, 1),
                              foregroundColor:
                                  const Color.fromARGB(255, 249, 246, 220),
                              child: Text(
                                name[0].toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:flutter/material.dart';

// class Search extends StatefulWidget {
//   const Search({super.key});

//   @override
//   State<Search> createState() => _SearchPatientState();
// }

// class _SearchPatientState extends State<Search> {
//   final TextEditingController searchController = TextEditingController();
//   String searchKey = "";

//   Stream<List<DocumentSnapshot>> _searchPatients() {
//     if (searchKey.isEmpty) {
//       // Return all patients if no search key is provided
//       return FirebaseFirestore.instance
//           .collection('Patients')
//           .snapshots()
//           .map((snapshot) => snapshot.docs);
//     } else {
//       // Perform search on `name`, `Name`, or `Patient_1`
//       final nameQuery = FirebaseFirestore.instance
//           .collection('Patients')
//           .where('name', isGreaterThanOrEqualTo: searchKey)
//           .where('name', isLessThan: '$searchKey\uf8ff')
//           .snapshots();

//       final capitalNameQuery = FirebaseFirestore.instance
//           .collection('Patients')
//           .where('Name', isGreaterThanOrEqualTo: searchKey)
//           .where('Name', isLessThan: '$searchKey\uf8ff')
//           .snapshots();

//       final patientIdQuery = FirebaseFirestore.instance
//           .collection('Patients')
//           .where(FieldPath.documentId, isGreaterThanOrEqualTo: searchKey)
//           .where(FieldPath.documentId, isLessThan: '$searchKey\uf8ff')
//           .snapshots();

//       // Combine the results of the three queries
//       return Rx.combineLatest3<QuerySnapshot, QuerySnapshot, QuerySnapshot,
//           List<DocumentSnapshot>>(
//         nameQuery,
//         capitalNameQuery,
//         patientIdQuery,
//         (nameResult, capitalNameResult, patientIdResult) {
//           final allDocs = [
//             ...nameResult.docs,
//             ...capitalNameResult.docs,
//             ...patientIdResult.docs
//           ];
//           // Remove duplicates by ID
//           return allDocs.toSet().toList();
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             const Spacer(),
//             Text(
//               'Search Patients',
//               style: GoogleFonts.poppins(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 color: const Color.fromARGB(255, 70, 61, 1),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const Spacer(),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Image.asset(
//                 'logo.png',
//                 height: 50,
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Icon(Icons.broken_image, size: 30);
//                 },
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color(0xFFFFCA03),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 249, 246, 220),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       labelText: 'Search by Name or ID',
//                       labelStyle: GoogleFonts.poppins(
//                         fontSize: 16.0,
//                         color: Colors.black54,
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         searchKey = value.trim();
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Enter a name or patient ID to search',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14.0,
//                       color: Colors.black54,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: StreamBuilder<List<DocumentSnapshot>>(
//                 stream: _searchPatients(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No Patients Found',
//                         style: TextStyle(fontSize: 16.0),
//                       ),
//                     );
//                   }

//                   return ListView(
//                     children: snapshot.data!.map((doc) {
//                       final data = doc.data() as Map<String, dynamic>?;
//                       if (data == null) return const SizedBox.shrink();

//                       final name = data['name'] ?? data['Name'] ?? 'Unknown';
//                       final patientId = doc.id;

//                       return GestureDetector(
//                         onTap: () {
//                         },
//                         child: Card(
//                           margin: const EdgeInsets.all(10.0),
//                           // color: Colors.amber,
//                           elevation: 8.0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: ListTile(
//                             title: Text(
//                               name,
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16.0,
//                               ),
//                             ),
//                             subtitle: Text(
//                               "ID: $patientId",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 14.0,
//                               ),
//                             ),
//                             leading: CircleAvatar(
//                               backgroundColor: Color.fromARGB(255, 70, 61, 1),
//                               foregroundColor:
//                                   Color.fromARGB(255, 249, 246, 220),
//                               child: Text(
//                                 name[0].toUpperCase(),
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

