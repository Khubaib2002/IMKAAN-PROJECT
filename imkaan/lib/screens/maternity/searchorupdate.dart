import 'package:flutter/material.dart';
import 'package:imkaan/screens/maternity/search/searchpatient.dart';
import 'package:imkaan/services/db.dart';

class Searchorupdate extends StatelessWidget {
  const Searchorupdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDashboardButton(
              context,
              label: 'Search Patient',
              icon: Icons.local_hospital,
              color: Colors.pinkAccent,
              highlightColor: const Color.fromARGB(252, 252, 216, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchPatientPage()),
                );
              },
            ),
            _buildDashboardButton(
              context,
              label: 'Update Patient',
              icon: Icons.local_hospital,
              color: Colors.pinkAccent,
              highlightColor: const Color.fromARGB(252, 252, 216, 0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateUserPage()),
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
