import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  startauthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;

    try {
      if (isLoginPage) {
        // Sign in the user
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // Sign up the user
        final UserCredential authResult =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String uid = authResult.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
          'password': password,
        });
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          // ignore: avoid_unnecessary_containers
          Container(
            height: 200,
            child: Image(image: AssetImage('assets/icon.png')),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.name,
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect Username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(),
                        ),
                        labelText: "Enter Username",
                        labelStyle: GoogleFonts.roboto(),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Incorrect Password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(),
                      ),
                      labelText: "Enter password",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      onPressed: () {
                        startauthentication();
                      },
                      child: isLoginPage
                          ? const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          : const Text(
                              'SignUp',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoginPage
                          ? const Text('Not a member ?')
                          : const Text('Already a member ?'),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: isLoginPage
                            ? Text(
                                'Signup',
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Center(child: Text('Made With ❤️ By Ali Yasin',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
          )
        ],
      ),
    );
  }
}