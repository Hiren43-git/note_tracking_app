import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_tracking_app/Core/Database%20Service/Auth%20Database%20Service/auth_database_service.dart';
import 'package:note_tracking_app/Core/Model/Auth%20Model/auth_model.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Screens/login_screen.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';

class AuthProvider extends ChangeNotifier {
  final AuthDatabaseService authDatabaseService = AuthDatabaseService();

  Future<String> signUp(AuthModel user) async {
    if (user.email.isNotEmpty && user.password.isNotEmpty) {
      await authDatabaseService.addUser(user);
      return 'success';
    } else {
      return '';
    }
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    final user = await authDatabaseService.loginUser(email, password, context);
    if (user != null) {
      notifyListeners();
      return true;
    }
    return false;
  }

  bool passwordShow = false;
  bool conPasswordShow = false;

  void showPassword() {
    passwordShow = !passwordShow;
    notifyListeners();
  }

  void showConfirmPassword() {
    conPasswordShow = !conPasswordShow;
    notifyListeners();
  }

  bool validEmail(String value) {
    final email = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return email.hasMatch(value);
  }

  bool validPassword(String value) {
    final password = RegExp(r"(?=.*[a-z])(?=.*[0-9]).{6,}$");
    return password.hasMatch(value);
  }

  Future<void> validForSignUp(BuildContext context) async {
    if (validEmail(email.text) &&
        validPassword(password.text) &&
        password.text == confirmPassword.text &&
        name.text.isNotEmpty) {
      final user = AuthModel(
        name: name.text,
        email: email.text,
        password: password.text,
        image: (image != null) ? image!.path : AppStrings.image,
      );
      final result = await signUp(user);

      if (result == AppStrings.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.signUpSuccess,
            ),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
        email.clear();
        password.clear();
        confirmPassword.clear();
        name.clear();
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

  Future<void> validForEditProfile(BuildContext context) async {
    if (validEmail(email.text) && name.text.isNotEmpty) {
      currentUserName = name.text;
      final update = AuthModel(
        id: currentUserId,
        name: currentUserName,
        email: email.text,
        password: password.text,
        image: (image != null) ? image!.path : AppStrings.image,
      );
      await updateUser(update);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.profileUpdate,
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  void errorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  int? currentUserId = 0;
  void getCurrentUserId(int id) {
    currentUserId = id;
    notifyListeners();
  }

  String currentUserName = '';
  void getCurrentUserName(String name) {
    currentUserName = name;
    notifyListeners();
  }

  Future<void> logout() async {
    currentUserId = null;
    notifyListeners();
  }

  Future<void> updateUser(AuthModel user) async {
    await authDatabaseService.updateUser(user);
    notifyListeners();
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  File? image;

  Future<void> pickImage() async {
    final pick = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pick != null) {
      image = File(
        pick.path,
      );
    }
    notifyListeners();
  }

  final key = GlobalKey<FormState>();
}
