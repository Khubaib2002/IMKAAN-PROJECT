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
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/logo.png',
                height: 40,
                color: Colors.black,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFCA03),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: const Color(0xFFFFCA03),
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 80),
            _buildDashboardButton(
              context,
              label: 'Maternity Clinic',
              icon: Icons.local_hospital,
              color: Colors.pinkAccent,
              highlightColor: const Color(0xFFFFCA03),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Searchorupdate(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildDashboardButton(
              context,
              label: 'Mental Health Clinic',
              icon: Icons.psychology,
              color: Colors.teal,
              highlightColor: const Color(0xFFFFCA03),
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
        style: GoogleFonts.poppins(
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
