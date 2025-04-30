import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Model/Auth%20Model/auth_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Screens/login_screen.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Widget/button_widget.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Widget/divider_widget.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/image_widget.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_field.dart';
import 'package:note_tracking_app/Module/Welcome/Widget/text_widget.dart';
import 'package:note_tracking_app/Utils/Constant/Color/colors.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AuthProvider().name.dispose();
    AuthProvider().email.dispose();
    AuthProvider().password.dispose();
    AuthProvider().confirmPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    final provider = Provider.of<NoteProvider>(context);

    final key = GlobalKey<FormState>();
    void register() async {
      if (key.currentState!.validate()) {
        if (AuthProvider().image == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please select image !',
              ),
            ),
          );
        }
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        final user = AuthModel(
          name: authProvider.name.text,
          email: authProvider.email.text,
          password: authProvider.password.text,
          image: (authProvider.image != null) ? authProvider.image!.path : '',
        );
        final result = await authProvider.signUp(user);

        if (result == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Signup Successfully !',
              ),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result,
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: (provider.edit == true)
          ? AppBar(
              surfaceTintColor: AppColors.background,
              backgroundColor: AppColors.background,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.title,
                    size: 26,
                  ),
                ),
              ),
              centerTitle: true,
              title: TextWidget(
                color: AppColors.title,
                size: 24,
                text: AppStrings.editProfile,
                weight: FontWeight.w600,
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 26.0,
            right: 26,
          ),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: (provider.edit == false) ? 60 : 40,
                  ),
                  if (provider.edit == false) ...[
                    TextWidget(
                      color: AppColors.title,
                      size: 46,
                      text: AppStrings.remind,
                      weight: FontWeight.bold,
                    ),
                    TextWidget(
                      color: AppColors.noteTaking,
                      size: 16,
                      text: AppStrings.notetaking,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: height * 0.09,
                    ),
                  ],
                  ImageWidget(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFieldWidget(
                    controller: authProvider.name,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your name'
                        : null,
                    text: AppStrings.name,
                    hint: AppStrings.name,
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
                  if (provider.edit == false) ...[
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
                      height: 16,
                    ),
                    TextFieldWidget(
                      validator: (value) => value != authProvider.password.text
                          ? 'Password do not match'
                          : null,
                      controller: authProvider.confirmPassword,
                      text: AppStrings.repeatPassword,
                      hint: AppStrings.passwordText,
                    ),
                  ],
                  SizedBox(
                    height: 38,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (provider.edit == false) {
                        register();
                        authProvider.password.clear();
                        authProvider.name.clear();
                        authProvider.confirmPassword.clear();
                        authProvider.email.clear();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: ButtonWidget(
                      text: (provider.edit == false)
                          ? AppStrings.start
                          : AppStrings.save,
                    ),
                  ),
                  if (provider.edit == false) ...[
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
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Builder(
                        builder: (context) {
                          return ButtonWidget(
                            text: AppStrings.login,
                          );
                        },
                      ),
                    ),
                  ],
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
