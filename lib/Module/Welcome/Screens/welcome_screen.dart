import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
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
  void initState() {
    if (Provider.of<NoteProvider>(context, listen: false).edit == true) {
      Provider.of<AuthProvider>(context, listen: false).name.text =
          Provider.of<AuthProvider>(context, listen: false).currentUserName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);
    final provider = Provider.of<NoteProvider>(context);

    final key = GlobalKey<FormState>();
    final ScrollController singleController = ScrollController();

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: (provider.edit == true)
          ? AppBar(
              surfaceTintColor: AppColors.background,
              backgroundColor: AppColors.background,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: () {
                    authProvider.tempImage = authProvider.currentUserImage;
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
            child: Consumer(
              builder: (context, value, child) {
                if (authProvider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.title,
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    controller: singleController,
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
                          SizedBox(
                            height: height * 0.02,
                          ),
                          ImageWidget(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (authProvider.image != null)
                                  ? FileImage(authProvider.image!)
                                  : AssetImage(
                                      AppStrings.image,
                                    ),
                            ),
                          ),
                        ],
                        if (provider.edit == true)
                          ImageWidget(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (authProvider.tempImage.path ==
                                        AppStrings.image)
                                    ? AssetImage(AppStrings.image)
                                    : FileImage(
                                        authProvider.tempImage,
                                      )),
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFieldWidget(
                          controller: authProvider.name,
                          validator: (value) => value == null || value.isEmpty
                              ? AppStrings.enterName
                              : null,
                          text: AppStrings.name,
                          hint: AppStrings.name,
                          focus: authProvider.nameFocus,
                          onSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(authProvider.emailFocus);
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        if (provider.edit == true) ...[
                          TextFieldWidget(
                            hint: authProvider.currentUserEmail,
                            controller: authProvider.email,
                            text: AppStrings.email,
                            read: true,
                          ),
                        ],
                        if (provider.edit == false) ...[
                          TextFieldWidget(
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (authProvider.validEmail(value)) {
                                  authProvider.validEmail(value);
                                } else {
                                  authProvider.errorMessage(
                                    context,
                                    AppStrings.invalidEmail,
                                  );
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
                                authProvider.email.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                    offset: authProvider.email.text.length,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                        if (provider.edit == false) ...[
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
                                    context,
                                    AppStrings.invalidPassword,
                                  );
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
                            onSubmitted: (value) {
                              FocusScope.of(context).requestFocus(
                                authProvider.confirmPasswordFocus,
                              );
                            },
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
                            height: 16,
                          ),
                          TextFieldWidget(
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                value != authProvider.password.text
                                    ? authProvider.errorMessage(
                                        context,
                                        AppStrings.passwordNotMatch,
                                      )
                                    : AppStrings.passwordRequire;
                              } else {
                                return AppStrings.enterRepeatPassword;
                              }
                              return null;
                            },
                            controller: authProvider.confirmPassword,
                            text: AppStrings.repeatPassword,
                            hint: AppStrings.passwordText,
                            conHide: true,
                            focus: authProvider.confirmPasswordFocus,
                            onChange: (value) {
                              if (value != null && value.endsWith(' ')) {
                                final trimmed = value.trimRight();
                                authProvider.confirmPassword.text = trimmed;
                                authProvider.confirmPassword.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                    offset: authProvider
                                        .confirmPassword.text.length,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                        SizedBox(
                          height: 38,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (provider.edit == false) {
                              if (key.currentState!.validate()) {
                                authProvider.validForSignUp(context);
                              }
                            } else {
                              if (key.currentState!.validate()) {
                                authProvider.validForEditProfile(context);
                              }
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
                              authProvider.email.clear();
                              authProvider.password.clear();
                              authProvider.confirmPassword.clear();
                              authProvider.passwordShow = false;
                              authProvider.conPasswordShow = false;
                              authProvider.name.clear();
                              authProvider.image = null;
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
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
