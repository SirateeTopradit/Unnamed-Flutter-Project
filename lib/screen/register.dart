import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:borrow_plz/model/profile.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: ' ', password: ' ');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    String? passwordCheck;
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: SafeArea(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "??????????????????????????????????????????????????????????????????"),
                                EmailValidator(
                                    errorText: "???????????????????????????????????????????????????????????????")
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (String? email) {
                                profile.email = email!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              validator: RequiredValidator(
                                  errorText: "???????????????????????????????????????????????????????????????????????????"),
                              obscureText: true,
                              onChanged: (val) => passwordCheck = val,
                              onSaved: (String? password) {
                                profile.password = password!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm password',
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => MatchValidator(
                                      errorText: 'passwords do not match')
                                  .validateMatch(val!, passwordCheck!),
                              obscureText: true,
                              onSaved: (String? password) {
                                profile.password = password!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: const Text("???????????????????????????",
                                    style: TextStyle(fontSize: 20)),
                                onPressed: () async {
                                  if (formKey.currentState!.validate) {
                                    formKey.currentState!.save();
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: profile.email,
                                              password: profile.password)
                                          .then((value) {
                                        formKey.currentState?.reset();
                                        Fluttertoast.showToast(
                                            msg:
                                                "???????????????????????????????????????????????????????????????????????????????????????",
                                            gravity: ToastGravity.TOP);
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return HomeScreen();
                                        }));
                                      });
                                    } on FirebaseAuthException catch (e) {
                                      print(e.code);
                                      String? message;
                                      if (e.code == 'email-already-in-use') {
                                        message =
                                            "???????????????????????????????????????????????????????????????????????? ?????????????????????????????????????????????????????????";
                                      } else if (e.code == 'weak-password') {
                                        message =
                                            "??????????????????????????????????????????????????????????????? 6 ??????????????????????????????????????????";
                                      } else {
                                        message = e.message;
                                      }
                                      Fluttertoast.showToast(
                                          msg:
                                              "${message}", //?????????????????????????????????????????????????????????????????? "${}" ???????????? e.message
                                          gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  // Widget buildUsername() => TextFormField(
  //       decoration: InputDecoration(
  //         labelText: 'Username',
  //         border: OutlineInputBorder(),
  //         // errorBorder:
  //         //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
  //         // focusedErrorBorder:
  //         //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
  //         // errorStyle: TextStyle(color: Colors.purple),
  //       ),
  //       validator: (value) {
  //         if (value.length < 4) {
  //           return 'Enter at least 4 characters';
  //         } else {
  //           return null;
  //         }
  //       },
  //       maxLength: 30,
  //       onSaved: (value) => setState(() => username = value),
  //     );

  // Widget buildEmail() => TextFormField(
  //       decoration: InputDecoration(
  //         labelText: 'Email',
  //         border: OutlineInputBorder(),
  //       ),
  //       validator: (value) {
  //         final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
  //         final regExp = RegExp(pattern);

  //         if (value!.isEmpty) {
  //           return 'Enter an email';
  //         } else if (!regExp.hasMatch(value!)) {
  //           return 'Enter a valid email';
  //         } else {
  //           return null;
  //         }
  //       },
  //       keyboardType: TextInputType.emailAddress,
  //       onSaved: (value) => setState(() => profile.email = value!),
  //     );

  // Widget buildPassword() => TextFormField(
  //       decoration: InputDecoration(
  //         labelText: 'Password',
  //         border: OutlineInputBorder(),
  //       ),
  //       validator: (value) {
  //         if (value!.length < 7) {
  //           return 'Password must be at least 7 characters long';
  //         } else {
  //           return null;
  //         }
  //       },
  //       onSaved: (value) => setState(() => profile.password = value!),
  //       keyboardType: TextInputType.visiblePassword,
  //       obscureText: true,
  //     );

  // Widget buildSubmit() => Builder(
  //       builder: (context) => ButtonWidget(
  //         text: 'Submit',
  //         onClicked: () {
  //           final isValid = _formKey.currentState.validate();
  //           // FocusScope.of(context).unfocus();

  //           if (isValid) {
  //             formKey.currentState!.save();

  //             final message =
  //                 'Username: $profile.username\nPassword: $profile.password\nEmail: $profile.email';
  //             final snackBar = SnackBar(
  //               content: Text(
  //                 message,
  //                 style: TextStyle(fontSize: 20),
  //               ),
  //               backgroundColor: Colors.green,
  //             );
  //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //           }
  //         },
  //       ),
  //     );

}
