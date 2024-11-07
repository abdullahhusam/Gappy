import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gappy/features/auth/components/custom_divider.dart';
import 'package:gappy/features/feed/views/home_screen.dart';
import 'package:gappy/features/shared/colors/colors.dart';
import 'package:gappy/features/shared/components/auth_button.dart';
import 'package:gappy/features/shared/components/custom_button.dart';
import 'package:gappy/features/shared/components/custom_text.dart';
import 'package:gappy/features/shared/components/custom_text_field.dart';
import 'package:gappy/features/shared/entry_screen.dart';
import 'package:gappy/utils/constants.dart';
import 'package:gappy/utils/routes.dart';
import 'package:gappy/utils/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../controllers/user_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IsValid _validEmail = IsValid.none;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userController = ref.read(userControllerProvider);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  marginBottom: 40,
                  text: "Gappy",
                  style: GoogleFonts.lobster(fontSize: 60),
                ),
                CustomTextField(
                  onChanged: (value) {
                    setState(() {
                      if (_validEmail != IsValid.none) {
                        if (validateEmail(value)) {
                          _validEmail = IsValid.valid;
                        } else {
                          _validEmail = IsValid.notValid;
                        }
                      }
                    });
                  },
                  labelText: 'Email',
                  controller: emailController,
                  type: Type.email,
                  isValid: _validEmail,
                ),
                CustomTextField(
                  marginTop: 15,
                  type: Type.password,
                  onChanged: (value) {
                    setState(() {});
                  },
                  labelText: 'Password',
                  controller: passwordController,
                ),
                CustomButton(
                  marginTop: 40,
                  onPressed: emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty
                      ? () async {
                          FocusScope.of(context).unfocus();
                          if (!validateEmail(emailController.text)) {
                            setState(() {
                              _validEmail = IsValid.notValid;
                            });
                          } else {
                            final success = await userController.loginUser(
                              emailController.text,
                              passwordController.text,
                            );

                            if (success) {
                              context.go(entryPath);
                            } else {
                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: snackBarErrorColor,
                                    content: Text('Invalid email or password')),
                              );
                            }
                          }
                        }
                      : null,
                  text: "Login",
                ),
                CustomDivider(
                  marginTop: 6.h,
                  marginBottom: 1.5.h,
                ),
                AuthButton(
                  text: "Sign Up Now!",
                  onPressed: () {
                    context.go(signUpPath);
                  },
                ),
                // Form(
                //   key: _formKey,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       TextFormField(
                //         controller: emailController,
                //         decoration: InputDecoration(labelText: 'Email'),
                //         keyboardType: TextInputType.emailAddress,
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return 'Please enter your email';
                //           }
                //           return null;
                //         },
                //       ),
                //       TextFormField(
                //         controller: passwordController,
                //         decoration: InputDecoration(labelText: 'Password'),
                //         obscureText: true,
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return 'Please enter your password';
                //           }
                //           return null;
                //         },
                //       ),
                //       SizedBox(height: 20),
                //       ElevatedButton(
                //         onPressed: () async {
                //           if (_formKey.currentState?.validate() ?? false) {
                //             final success = await userController.loginUser(
                //               emailController.text,
                //               passwordController.text,
                //             );
                //
                //             if (success) {
                //               context.go(entryPath);
                //             } else {
                //               // Show error message
                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 SnackBar(
                //                     content: Text('Invalid email or password')),
                //               );
                //             }
                //           }
                //         },
                //         child: Text('Login'),
                //       ),
                //
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
