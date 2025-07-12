import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logs extends StatefulWidget {
  final String clientId; // Correct type

  const Logs({super.key, required this.clientId});

  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<Logs> {
  List<Map<String, dynamic>> weeklyData = [];
  TextEditingController newDocIdController = TextEditingController();
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Mental')
          .doc(widget.clientId)
          .collection('logs')
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
          .collection('logs')
          .doc(docId)
          .set(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session data saved successfully!')),
      );
      fetchData();
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
        title: Text('Session: ${weeklyDoc['id']}'),
        onTap: () {
          setState(() {
            expandedIndex = index;
          });
        },
      ),
    );
  }


Widget buildWeeklyForm(Map<String, dynamic> weeklyDoc, int index) {
  // Define the categories and their corresponding chec

  final Map<String, List<String>> checkboxFields = {
  "Depression": [
    "Low mood for >2 weeks",
    "Sleep",
    "Interest",
    "Guilt/worthlessness",
    "Energy",
    "Concentration",
    "Appetite/weight Δ",
    "Psychomotor slowing",
    "Suicide",
    "Hopelessness/Plan/Access",
  ],
  "Mania": [
    "Grandiose",
    "Increased activity",
    "Goal-directed/high risk",
    "Decreased judgment",
    "Distractible",
    "Irritability",
    "Need less sleep",
    "Elevated mood",
    "Speedy talking",
    "Speedy thoughts",
  ],
  "Psychosis": [
    "Hallucinations/illusions",
    "Delusions",
    "Self-reference (e.g., people watching you, messages from media)",
    "Thought blocking/insertion",
    "Disorganization: speech/behavior",
  ],
  "Panic Attacks": [
    "Trembling",
    "Palpitations",
    "Nausea/chills",
    "Choking/chest pain",
    "Sweating",
    "Fear (dying/going crazy)",
    "Anticipatory anxiety",
    "Avoidance",
    "Agoraphobia",
  ],
  "Generalized Anxiety": [
    "Excess worry",
    "Restlessness/edgy",
    "Easily fatigued",
    "Muscle tension",
    "↓ Sleep",
    "↓ Concentration",
  ],
  "Obsessive-Compulsive Disorder": [
    "Intrusive/persistent thoughts",
    "Recognized as excessive/irrational",
    "Repetitive behaviors: Washing/cleaning",
    "Repetitive behaviors: Counting/checking",
    "Repetitive behaviors: Organizing/praying",
  ],
  "PTSD": [
    "Experienced/witnessed event",
    "Persistent re-experiencing",
    "Dreams/flashbacks",
    "Avoidance behavior",
    "Hyper-arousal: ↑ vigilance/↑ startle",
  ],
  "Social Phobia": [
    "Fear of embarrassment",
    "Fear of humiliation",
    "Fear of criticism",
    "Performance situations",
  ],
  "Borderline Personality": [
    "Fear of abandonment/rejection",
    "Unstable relationships",
    "Chronic emptiness",
    "↓ Self-esteem",
    "Intense anger/outbursts",
    "Self-damaging behavior",
    "Labile mood and impulsivity",
  ],
  "Antisocial Personality": [
    "Forensic history: arrests/imprisonment",
    "Aggressiveness/violence",
    "Lack of empathy/remorse",
    "Lack of concern for safety (self or others)",
    "Childhood conduct disorder",
  ],
  "Specific Phobias": [
    "Heights",
    "Crowds",
    "Animals",
  ],
  "Body Dysmorphic Disorder": [
    "Excess concern with appearance or certain part of body",
    "Avoidance behavior",
  ],
  "Eating Disorders": [
    "Binging/purging/restriction/amenorrhea",
    "Perception of body image or weight",
  ],
};



  // Define text fields
  final List<String> textFields = [
    "Why_present_now",
    "When_did_it_start",
    "How_long_it_lasts",
    "Impact_on_life",
    "Previous_psychiatric_Hx",
    "Previous_diagnoses",
    "Medications_Tx",
    "Fam_Psychiatric_Dx",
    "Fam_Substance_use",
    "Fam_Suicide",
    "Previous_illnesses",
    "Surgeries_hospitalizations",
    "Head_injury",
    "Medications",
    "Alcohol_use",
    "Substance_use",
    "Background",
    "MMSE_Total_Score",
    "INVESTIGATION_OUTCOME",
  ];

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Form',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Generate checkbox fields for each category
            ...checkboxFields.entries.map((entry) {
              String category = entry.key;
              List<String> options = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  ...options.map((option) {
                    bool isChecked = weeklyDoc[category]?.contains(option) ?? false;

                    return CheckboxListTile(
                      title: Text(option),
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            weeklyDoc[category] = (weeklyDoc[category] ?? [])..add(option);
                          } else {
                            weeklyDoc[category]?.remove(option);
                          }
                          weeklyData[index][category] = weeklyDoc[category];
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),

            // Generate text fields
            ...textFields.map((field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(field, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  TextFormField(
                    initialValue: weeklyDoc[field] ?? '',
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter $field',
                    ),
                    onChanged: (value) {
                      setState(() {
                        weeklyDoc[field] = value;
                        weeklyData[index][field] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }).toList(),

            // Buttons
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
                  child: const Text('Back'),
                ),
              ],
            ),
          ],
        ),
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
          child: const Text('Add visit data'),
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
            const Spacer(),
            Text(
              'Visit Logs',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 70, 61, 1),
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
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






  // Widget buildWeeklyForm(Map<String, dynamic> weeklyDoc, int index) {
  //   List<String> fields = [
  //     "Why_present_now",
  //     "When_did_it_start",
  //     "How_long_it_lasts",
  //     "Impact_on_life",
  //     "Depression",
  //     "Mania",
  //     "Psychosis",
  //     "Panic_Attacks",
  //     "Generalized_Anxiety",
  //     "Obsessive_Compulsive_Disorder",
  //     "PTSD",
  //     "Social_Phobia",
  //     "Borderline_Personality",
  //     "Antisocial_Personality",
  //     "Specific_Phobias",
  //     "Body_Dysmorphia",
  //     "Eating_Disorders",
  //     "Previous_psychiatric_Hx",
  //     "Previous_diagnoses",
  //     "Medications_Tx",
  //     "Fam_Psychiatric_Dx",
  //     "Fam_Substance_use",
  //     "Fam_Suicide",
  //     "Previous_illnesses",
  //     "Surgeries_hospitalizations",
  //     "Head_injury",
  //     "Medications",
  //     "Alcohol_use",
  //     "Substance_use",
  //     "Background",
  //     "MMSE_Total_Score",
  //     "INVESTIGATION_OUTCOME",
  //   ];

  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     child: Padding(
  //       padding: const EdgeInsets.all(15.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ...fields.map((field) {
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(field, style: const TextStyle(fontSize: 16)),
  //                 const SizedBox(height: 5),
  //                 TextField(
  //                   keyboardType: TextInputType.text,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       weeklyData[index][field] = value;
  //                     });
  //                   },
  //                   decoration: InputDecoration(
  //                     hintText: weeklyDoc[field]?.toString() ?? '',
  //                     border: const OutlineInputBorder(),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //               ],
  //             );
  //           }).toList(),
  //           const SizedBox(height: 10),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               ElevatedButton(
  //                 onPressed: () {
  //                   saveWeeklyData(weeklyDoc['id'], weeklyData[index]);
  //                 },
  //                 child: const Text('Save Changes'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     expandedIndex = null;
  //                   });
  //                 },
  //                 child: const Text('Back'),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }