import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imkaan/screens/mental.dart';
import 'package:imkaan/screens/maternity/searchorupdate.dart';
// import 'package:imkaan/screens/home/maternity.dart';
import 'package:imkaan/services/auth.dart';
// import 'package:imkaan/services/db.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService _auth = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text(
//             'Dashboard',
//             style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w500,
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 fontStyle: FontStyle.italic,
//                 fontFamily: 'Raleway'),
//           ),
//           backgroundColor: Colors.grey[850],
//           actions: <Widget>[
//             TextButton.icon(
//               label: const Text(
//                 "Log Out",
//                 style: TextStyle(color: Color.fromARGB(255, 241, 235, 183)),
//               ),
//               onPressed: () async {
//                 await _auth.SignOut();
//               },
//               icon: const Icon(Icons.person,
//                   color: Color.fromARGB(255, 241, 235, 183)),
//             )
//           ]),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildStylizedButton(
//                 context: context,
//                 label: 'Maternity Clinic Data',
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const UpdateUserPage()),
//                         // builder: (context) => const UpdatePatientPage()),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildStylizedButton(
//                 context: context,
//                 label: 'Legal Aid Data',
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const LegalAidPage()),
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               _buildStylizedButton(
//                 context: context,
//                 label: 'Admin Settings',
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const AdminSettingsPage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStylizedButton({
//     required BuildContext context,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         width: 500,
//         padding: const EdgeInsets.symmetric(vertical: 36.0),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Colors.blueGrey, Colors.grey],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(40),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 4),
//               blurRadius: 8.0,
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: const TextStyle(
//                 fontSize: 35,
//                 fontWeight: FontWeight.w500,
//                 color: Color.fromARGB(255, 0, 0, 0),
//                 fontStyle: FontStyle.italic,
//                 fontFamily: 'Raleway'),
//           ),
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 53, 58, 0),
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(252, 252, 216, 0),
          elevation: 4.0,
          actions: <Widget>[
            TextButton.icon(
              label: const Text(
                "Log Out",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onPressed: () async {
                await _auth.SignOut();
              },
              icon: const Icon(Icons.person,
                  color: Color.fromARGB(255, 255, 255, 255)),
            )
          ]),
      body: Container(
        width: double.infinity,
        // color: const Color.fromARGB(255, 132, 121, 0), // Black background

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color.fromARGB(248, 0, 0, 0),
              Color.fromARGB(249, 255, 255, 255),
              Color.fromARGB(252, 252, 216, 0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Imkaan Database Management System!',
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 43, 47, 0),
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.yellow,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 110),
            _buildDashboardButton(
              context,
              label: 'Maternity Clinic',
              icon: Icons.local_hospital,
              color: Colors.pinkAccent,
              highlightColor: const Color.fromARGB(252, 252, 216, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Searchorupdate()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildDashboardButton(
              context,
              label: 'Mental Health Clinic',
              icon: Icons.psychology,
              color: Colors.teal,
              highlightColor: const Color.fromARGB(252, 252, 216, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MentalHealth()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required Color highlightColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: highlightColor, width: 2),
        ),
        shadowColor: Colors.black26,
        elevation: 6.0,
      ),
    );
  }
}
