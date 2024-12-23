import 'package:flutter/material.dart';
import 'package:imkaan/screens/authenticate/authenticate.dart';
import 'package:imkaan/screens/home/homepage.dart';
import 'package:provider/provider.dart';
import 'package:imkaan/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_?>(context);
    //return either home or authenticate
    if (user == null) {
      return const Authenticate();
    } else {
      return HomePage();
    }
  }
}
