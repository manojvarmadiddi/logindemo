// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/password_validator.dart';
import '../components/reusable_text.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  var signupkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    return Form(
      key: signupkey,
      child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                // padding: EdgeInsets.all(8), // Border width
                decoration: BoxDecoration(
                    color: Colors.white, shape: BoxShape.rectangle),
                child: Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * .02,
              ),
              TextWidget(
                controller: username,
                label: 'User Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username required';
                  } else if (value.length != 10) {
                    return 'username must be 10 charecters ';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: screenHeight * .02,
              ),
              TextWidget(
                controller: password,
                label: 'Password',
                validator: (value) {
                  bool passValid = passwordRegex.hasMatch(value!);

                  if (value.isEmpty) {
                    return 'Password required';
                  } else if (!passValid)
                    return 'Password should contain atleast 1-Special Symbol,1-Uppercase,1-Lowercase';
                },
              ),
              SizedBox(
                height: screenHeight * .02,
              ),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * .07,
                    width: screenWidth * .44,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black)),
                      onPressed: () async {
                        if (signupkey.currentState!.validate()) {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: username.text + '@gmail.com',
                                  password: password.text)
                              .then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${error.toString()}')));
                            print(error.toString());
                          });
                        }
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * .03,
              ),
            
          ],
          )),
    );
  }
}
