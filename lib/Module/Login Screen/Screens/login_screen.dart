import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/database_service.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 26.0, right: 26, top: 40),
          child: Form(
            key: authProvider.key,
            child: SingleChildScrollView(
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
                    validator: (value) =>
                        value == null || !value.contains('@gmail.com')
                            ? 'Enter valid email'
                            : null,
                    controller: authProvider.email,
                    text: AppStrings.email,
                    hint: AppStrings.emailText,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFieldWidget(
                    validator: (value) => value == null || value.length < 6
                        ? 'Password too short'
                        : null,
                    controller: authProvider.password,
                    text: AppStrings.password,
                    hint: AppStrings.passwordText,
                  ),
                  SizedBox(
                    height: 38,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (authProvider.key.currentState!.validate()) {
                        final result = await authProvider.login(
                            authProvider.email.text,
                            authProvider.password.text);

                        if (result == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Login Successfully !',
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
                                'Login canceled !',
                              ),
                            ),
                          );
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
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
      ),
    );
  }
}
