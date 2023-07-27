// import 'package:cbsbeta01/auth/customer_signup.dart';
// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:cbsapperals/providers/auth_repo.dart';
import 'package:cbsapperals/widgets/auth_widgets.dart';
import 'package:cbsapperals/widgets/snackbar.dart';
import 'package:cbsapperals/widgets/yellow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';


class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String email;
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;
  bool sendEmailVeridication = false;

  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);

        await AuthRepo.reloadUserData();
        if (await AuthRepo.checkEmailVerification()) {
          _formKey.currentState!.reset();
          User user = FirebaseAuth.instance.currentUser!;
          final SharedPreferences pref= await _prefs;
          pref.setString('supplierid', user.uid);

          await Future.delayed(const Duration(milliseconds: 100))
              .whenComplete(() {
            Navigator.of(context).pushReplacementNamed('/supplier_home');
          });
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please check your inbox');
          setState(() {
            processing = false;
            sendEmailVeridication = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });

        MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(headerLabel: 'Log In'),
                      SizedBox(
                        height: 50,
                        child: sendEmailVeridication == true
                            ? Center(
                          child: YellowButton(
                              label: 'Resend Email Verification',
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();
                                } catch (e) {
                                  print(e);
                                }
                                Future.delayed(const Duration(seconds: 3))
                                    .whenComplete(() {
                                  setState(() {
                                    sendEmailVeridication = false;
                                  });
                                });
                              },
                              width: 0.6),
                        )
                            : const SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email ';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.purple,
                                )),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            /*       Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword())); */
                          },
                          child: const Text(
                            'Forget Password ?',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )),
                      HaveAccount(
                        haveAccount: 'Don\'t Have Account? ',
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_signup');
                        },
                      ),
                      processing == true
                          ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                          ))
                          : AuthMainButton(
                        mainButtonLabel: 'Log In',
                        onPressed: () {
                          logIn();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class SupplierLogin extends StatefulWidget {
//   const SupplierLogin({Key? key}) : super(key: key);
//
//   @override
//   State<SupplierLogin> createState() => _SupplierLoginState();
// }
//
// class _SupplierLoginState extends State<SupplierLogin> {
//   late String email;
//   late String password;
//   bool processing = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();
//   bool passwordVisible = true;
//   bool sendEmailVerification = false;
//
//   void login() async {
//     setState(() {
//       processing = true;
//     });
//     if (_formKey.currentState!.validate()) {
//       try {
//         await AuthRepo.signInWithEmailAndPassword(email, password);
//
//         await AuthRepo.reloadUserData();
//
//         if (await AuthRepo.checkEmailVerification()) {
//           _formKey.currentState!.reset();
//
//           Navigator.pushReplacementNamed(context, '/supplier_home');
//         } else {
//           MyMessageHandler.showSnackBar(
//               _scaffoldKey, 'Please check your inbox');
//           setState(() {
//             processing = false;
//             sendEmailVerification = true;
//           });
//         }
//       } on FirebaseAuthException catch (e) {
//         setState(() {
//           processing = false;
//         });
//         MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
//       }
//     } else {
//       setState(() {
//         processing = false;
//       });
//       MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: _scaffoldKey,
//       child: Scaffold(
//         body: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//               reverse: true,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const AuthHeaderLabel(
//                         headerLabel: 'Log In',
//                       ),
//                       SizedBox(
//                         height: 50,
//                         child: sendEmailVerification == true
//                             ? Center(
//                                 child: YellowButton(
//                                     label: 'Resend Email Verification',
//                                     onPressed: () async {
//                                       try {
//                                         await FirebaseAuth.instance.currentUser!
//                                             .sendEmailVerification();
//                                       } catch (e) {
//                                         print(e);
//                                       }
//                                       Future.delayed(const Duration(seconds: 3))
//                                           .whenComplete(() {
//                                         setState(() {
//                                           sendEmailVerification = false;
//                                         });
//                                       });
//                                     },
//                                     width: 0.6),
//                               )
//                             : const SizedBox(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'please enter your email';
//                             } else if (value.isValidEmail() == false) {
//                               return 'invalid email';
//                             } else if (value.isValidEmail() == true) {
//                               return null;
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {
//                             email = value;
//                           },
//                           // controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: textFormDecoration.copyWith(
//                               labelText: 'Email Address',
//                               hintText: 'Enter your email'),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: TextFormField(
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'please enter your password';
//                             } else {
//                               return null;
//                             }
//                           },
//                           onChanged: (value) {
//                             password = value;
//                           },
//                           // controller: _passwordController,
//                           obscureText: passwordVisible,
//                           decoration: textFormDecoration.copyWith(
//                               suffixIcon: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       passwordVisible = !passwordVisible;
//                                     });
//                                   },
//                                   icon: Icon(
//                                     passwordVisible
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                     color: Colors.purple,
//                                   )),
//                               labelText: 'Password',
//                               hintText: 'Enter your Password'),
//                         ),
//                       ),
//                       TextButton(
//                           onPressed: () {},
//                           child: const Text(
//                             'Forgot Password?',
//                             style: TextStyle(
//                                 fontSize: 18, fontStyle: FontStyle.italic),
//                           )),
//                       HaveAccount(
//                         haveAccount: 'Don\'t have Account? ',
//                         actionLabel: 'Sign Up',
//                         onPressed: () {
//                           Navigator.pushReplacementNamed(
//                               context, '/supplier_signup');
//                         },
//                       ),
//                       processing == true
//                           ? const Center(
//                               child: CircularProgressIndicator(
//                               color: Colors.purple,
//                             ))
//                           : AuthMainButton(
//                               mainButtonLabel: 'Log In',
//                               onPressed: () {
//                                 login();
//                               },
//                             )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }