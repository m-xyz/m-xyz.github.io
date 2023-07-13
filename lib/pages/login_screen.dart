import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_page.dart';

//ten_admin123
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailCtrlr = TextEditingController();
  final _passwordCtrlr = TextEditingController();
  bool obscurePassword = true;

  void userLogin() async {
    showDialog(
        context: context,
        builder: ((context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrlr.text, password: _passwordCtrlr.text);

      Navigator.pop(context);
    } on FirebaseAuthException {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset('lib/images/login_error_32.png'),
                  Text(
                    "Invalid credentials!",
                    style: GoogleFonts.bebasNeue(fontSize: 24),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }
  }

  @override
  void dispose() {
    _emailCtrlr.dispose();
    _passwordCtrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[1000],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(children: [
              const SizedBox(
                height: 50,
                width: 50,
              ),
              Image.asset(
                'lib/images/business_logo.png',
                height: 300,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailCtrlr,
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: Icon(Icons.email_sharp),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter E-mail";
                          }
                          final bool emailValidation = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);

                          if (!emailValidation) {
                            return "Invalid E-mail";
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextFormField(
                        obscureText: obscurePassword,
                        keyboardType: TextInputType.emailAddress,
                        controller: _passwordCtrlr,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: const Icon(Icons.key_sharp),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            child: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_sharp
                                  : Icons.visibility_sharp,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: (() {
                          if (_formKey.currentState!.validate()) {
                            userLogin();
                          }
                        }),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Text('Account recovery'),
                            ),
                            const VerticalDivider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: const Text(
                                'Sign-up',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
