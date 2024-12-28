import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imkaan/screens/mental.dart';
import 'package:imkaan/screens/maternity/searchorupdate.dart';
import 'package:imkaan/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Flexible(
            //   flex: 3,
            //   child: Image.asset(
            //     'logo.png',
            //     height: 60,
            //     fit: BoxFit.contain,
            //     errorBuilder: (context, error, stackTrace) {
            //       return const Icon(Icons.broken_image, color: Colors.black);
            //     },
            //   ),
            // ),
            const SizedBox(width: 10),
            Flexible(
              flex: 3,
              child: Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  // decoration:
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFCA03),
        elevation: 4.0,
        actions: <Widget>[
          TextButton.icon(
            label: const Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await _auth.SignOut();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('logo.png'),
                scale: 1,
                filterQuality: FilterQuality.high)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Welcome to Imkaan Database Management System!',
                style: GoogleFonts.poppins(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 230),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildDashboardCard(
                  context,
                  label: 'Maternity Clinic',
                  icon: Icons.local_hospital,
                  color: Colors.pinkAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Searchorupdate(),
                      ),
                    );
                  },
                ),
                _buildDashboardCard(
                  context,
                  label: 'Mental Health Clinic',
                  icon: Icons.psychology,
                  color: Colors.teal,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MentalHealth(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
