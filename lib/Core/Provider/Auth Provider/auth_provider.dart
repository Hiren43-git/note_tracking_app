import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_tracking_app/Core/Database%20Service/Auth%20Database%20Service/auth_database_service.dart';
import 'package:note_tracking_app/Core/Model/Auth%20Model/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthModel? currentUser;

  final AuthDatabaseService authDatabaseService = AuthDatabaseService();

  AuthModel? get getCurrentUser => currentUser;

  Future<void> signUp(AuthModel user) async {
    if (user.email.isNotEmpty && user.password.isNotEmpty) {
      await authDatabaseService.addUser(user);
    }
  }

  Future<bool> login(String email, String password) async {
    final user = await authDatabaseService.loginUser(email, password);
    if (user != null) {
      currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    currentUser = null;
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
  }

  final key = GlobalKey<FormState>();
  void register()
  {
    if(key.currentState!.validate())
    {
      if(AuthProvider().image ==null)
      {

      }
      else
      {

      }
      
    }
  }
}
