import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imkaan/screens/maternity/search/searchpatient.dart';
import 'package:imkaan/services/db.dart';

class Searchorupdate extends StatelessWidget {
  const Searchorupdate({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Spacer(), // Pushes the logo to the right
            Text(
              'Patient Management',
              style: GoogleFonts.poppins(
                fontSize: 20,
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
                    'Manage Patients',
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.026),
                  Text(
                    'Search or Update Patient Information',
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.035,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                      shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Colors.grey.shade400,
                          offset: const Offset(1.5, 1.5),
                        ),
                      ],
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
                    label: 'Search Patient',
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPatientPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 30),
                  HoverableDashboardCard(
                    label: 'Update Patient',
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateUserPage(),
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
  final Icon icon;
  final VoidCallback onPressed;

  const HoverableDashboardCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenHeight * 0.045,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        widget.icon.icon,
                        size: 50,
                        color: const Color.fromARGB(255, 103, 89, 1),
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
        ));
  }

  void _updateCardColor(Color color) {
    setState(() {
      _cardColor = color;
    });
  }
}
