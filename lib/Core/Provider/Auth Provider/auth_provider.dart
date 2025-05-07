import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_tracking_app/Core/Database%20Service/Auth%20Database%20Service/auth_database_service.dart';
import 'package:note_tracking_app/Core/Model/Auth%20Model/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  // AuthModel? currentUser;

  final AuthDatabaseService authDatabaseService = AuthDatabaseService();

  // AuthModel? get getCurrentUser => currentUser;

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
      // currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool passwordShow = false;
  bool conPasswordShow = false;

  void showPassword() {
    if (passwordShow == true) {
      passwordShow = false;
      notifyListeners();
    } else {
      passwordShow = true;
      notifyListeners();
    }
  }

  void showConfirmPassword() {
    if (conPasswordShow == true) {
      conPasswordShow = false;
      notifyListeners();
    } else {
      conPasswordShow = true;
      notifyListeners();
    }
  }

  bool validEmail(String value) {
    final email = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return email.hasMatch(value);
  }

  bool validPassword(String value) {
    final password = RegExp(r"(?=.*[a-z])(?=.*[0-9]).{6,}$");
    return password.hasMatch(value);
  }

  void errorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  int? currentUserId = 1;
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
