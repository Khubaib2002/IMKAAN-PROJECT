import 'package:flutter/material.dart';
import 'package:imkaan/admin.dart';
import 'package:imkaan/legal.dart';
import 'package:imkaan/maternity.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 255, 255),
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'
            ),
          ),
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStylizedButton(
                context: context,
                label: 'Maternity Clinic Data',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MaternityClinicPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildStylizedButton(
                context: context,
                label: 'Legal Aid Data',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LegalAidPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildStylizedButton(
                context: context,
                label: 'Admin Settings',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminSettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStylizedButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 500,
        padding: const EdgeInsets.symmetric(vertical: 36.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueGrey, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 0, 0, 0),
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'
            ),
          ),
        ),
      ),
    );
  }
}




