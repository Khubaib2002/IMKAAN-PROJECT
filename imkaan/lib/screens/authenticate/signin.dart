import 'package:flutter/material.dart';
import 'package:imkaan/shared/inputdecor.dart';
import 'package:imkaan/shared/loading.dart';
import 'package:imkaan/shared/styledbody.dart';
import 'package:imkaan/services/auth.dart';

class Signin extends StatefulWidget {
  final toggleview;
  const Signin({super.key, required this.toggleview});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //text field state
  var email = '';
  var pass = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
                backgroundColor: Colors.yellow,
                elevation: 0,
                title: const StyledBodyText('Sign in to Imkaan DBMS', 18),
                actions: <Widget>[
                  TextButton.icon(
                    label: const StyledBodyText("Register", 13),
                    onPressed: () async {
                      widget.toggleview();
                    },
                    style: TextButton.styleFrom(
                      // backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      // shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.elliptical(5, 3))),
                    ),
                    icon: const Icon(Icons.person,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  )
                ]),
            resizeToAvoidBottomInset:
                true, // This prevents overflow when the keyboard appears
            body: SingleChildScrollView(
              // Wrap with SingleChildScrollView
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/imkaan.png',
                        height: 360,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 20),
                            TextFormField(
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                              decoration:
                                  textinputdecor.copyWith(hintText: 'Email'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter a password' : null,
                                obscureText: true,
                                onChanged: (val) {
                                  setState(() => pass = val);
                                },
                                decoration: textinputdecor.copyWith(
                                    hintText: 'Password')),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signin_wenp(email, pass);
                                  print('valid');
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          'Could not sign in with given credentials';
                                    });
                                  }
                                }
                                // dynamic result = await _auth.signInAnon();
                                // if (result == null) {
                                //   print('error signing in');
                                // } else {
                                //   print('signed in');
                                //   print(result.uid);
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: const Color(0xFFFFCA03),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0, vertical: 12.0),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 30.0),
                                child: Text('Login',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          );
  }
}


// (child: Column(
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
// )