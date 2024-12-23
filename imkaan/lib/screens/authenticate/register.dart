import 'package:flutter/material.dart';
import 'package:imkaan/shared/inputdecor.dart';
import 'package:imkaan/shared/loading.dart';
import 'package:imkaan/shared/styledbody.dart';
import 'package:imkaan/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleview;
  const Register({super.key, required this.toggleview});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

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
                title: const StyledBodyText('Register to Imkaan DBMS', 18),
                actions: <Widget>[
                  TextButton.icon(
                    label: const StyledBodyText('Sign in here', 13),
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
                                obscureText: true,
                                validator: (val) =>
                                    val!.isEmpty ? 'Enter a password' : null,
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
                                      await _auth.register_wenp(email, pass);
                                  print('valid');
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          'Please provide valid email & password';
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
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
