import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imkaan/screens/wrapper.dart';
import 'package:imkaan/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:imkaan/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDrp31XaewPCD5tscblq0L5_xUaKNgiivQ",
          appId: "1:712573298315:android:2e804121fade4b940c968e",
          messagingSenderId: "712573298315",
          projectId: "khidmat-de554"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User_?>.value(
      initialData: null,
      value: AuthService().user,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: LoginPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(1, 235, 235, 235),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/imkaan.png',
//                 height: 360,
//               ),
//               const SizedBox(height: 20),
//               const Center(
//                 child: SizedBox(
//                   width: 400, // Set the desired width
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         decoration: InputDecoration(
//                           labelText: 'Username',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.person),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       TextField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.lock),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const HomePage()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey,
//                   foregroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: const Padding(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
//                   child: Text('Login', style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
