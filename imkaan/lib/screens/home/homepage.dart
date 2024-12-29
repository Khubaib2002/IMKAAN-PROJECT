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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'logo.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, size: 30);
              },
            ),
            const Spacer(),
            const SizedBox(
              width: 45,
            ),
            Text(
              'Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 70, 61, 1),
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
        ),
        backgroundColor: const Color(0xFFFFCA03),
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
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 249, 246, 220)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * .05,
                  ),
                  Text(
                    'Welcome to',
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.037,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.026),
                  Text(
                    'Imkaan Database Management System',
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.045,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 44, 44, 44),
                      // shadows: [
                      //   Shadow(
                      //     blurRadius: 6.0,
                      //     color: Colors.grey.shade400,
                      //     offset: const Offset(1.5, 1.5),
                      //   ),
                      // ],
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.09),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HoverableDashboardCard(
                    label: 'Maternity Clinic',
                    imagePath: 'maternity.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Searchorupdate(),
                        ),
                      );
                    },
                  ),
                  // spacing b/w cards
                  const SizedBox(width: 30),
                  HoverableDashboardCard(
                    label: 'Mental Health Clinic',
                    imagePath: 'mentalhealth.png',
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
          ],
        ),
      ),
    );
  }
}

class HoverableDashboardCard extends StatefulWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  const HoverableDashboardCard({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<HoverableDashboardCard> createState() => _HoverableDashboardCardState();
}

class _HoverableDashboardCardState extends State<HoverableDashboardCard> {
  Color _cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MouseRegion(
      onEnter: (_) => _updateCardColor(Colors.grey[300]!),
      onExit: (_) => _updateCardColor(Colors.white),
      child: GestureDetector(
        onTap: () {
          _updateCardColor(Colors.grey[400]!);
          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Card(
            color: _cardColor,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              width: screenWidth * 0.4,
              height: screenHeight * 0.27,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: screenHeight * 0.045,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 30);
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    widget.label,
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateCardColor(Color color) {
    setState(() {
      _cardColor = color;
    });
  }
}
