// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/database_service.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Home/Screens/home_screen.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Widget/button_widget.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Widget/divider_widget.dart';
import 'package:note_tracking_app/Module/Welcome/Screens/welcome_screen.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_field.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    DbHelper.helper.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final provider = Provider.of<NoteProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 26.0, right: 26, top: 40),
          child: Form(
            key: authProvider.key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  color: AppColors.title,
                  size: 46,
                  text: AppStrings.login,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldWidget(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      if (authProvider.validEmail(value)) {
                        authProvider.validEmail(value);
                      } else {
                        authProvider.errorMessage(
                            context, AppStrings.invalidEmail);
                      }
                    } else {
                      return AppStrings.enterEmail;
                    }
                    return null;
                  },
                  focus: authProvider.emailFocus,
                  controller: authProvider.email,
                  text: AppStrings.email,
                  hint: AppStrings.emailText,
                  onSubmitted: (value) {
                    FocusScope.of(context)
                        .requestFocus(authProvider.passwordFocus);
                  },
                  onChange: (value) {
                    if (value != null && value.endsWith(' ')) {
                      final trimmed = value.trimRight();
                      authProvider.email.text = trimmed;
                      authProvider.email.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: authProvider.email.text.length,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFieldWidget(
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      if (authProvider.validPassword(value)) {
                        authProvider.validPassword(value);
                      } else {
                        authProvider.errorMessage(
                            context, AppStrings.invalidPassword);
                        return AppStrings.passwordRequire;
                      }
                    } else {
                      return AppStrings.enterPassword;
                    }
                    return null;
                  },
                  focus: authProvider.passwordFocus,
                  controller: authProvider.password,
                  text: AppStrings.password,
                  hint: AppStrings.passwordText,
                  hide: true,
                  onChange: (value) {
                    if (value != null && value.endsWith(' ')) {
                      final trimmed = value.trimRight();
                      authProvider.password.text = trimmed;
                      authProvider.password.selection =
                          TextSelection.fromPosition(
                        TextPosition(
                          offset: authProvider.password.text.length,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 38,
                ),
                GestureDetector(
                  onTap: () async {
                    if (authProvider.key.currentState!.validate()) {
                      if (authProvider.validEmail(authProvider.email.text) &&
                          authProvider
                              .validPassword(authProvider.password.text)) {
                        final result = await authProvider.login(
                          authProvider.email.text,
                          authProvider.password.text,
                          context,
                        );
                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppStrings.loginSuccess,
                              ),
                            ),
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppStrings.emailNotExist,
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: ButtonWidget(
                    text: AppStrings.login,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                DividerWidget(),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    provider.edit = false;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                    );
                    authProvider.email.clear();
                    authProvider.password.clear();
                    authProvider.confirmPassword.clear();
                    authProvider.name.clear();
                  },
                  child: Builder(
                    builder: (context) {
                      return ButtonWidget(
                        text: AppStrings.signUp,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
