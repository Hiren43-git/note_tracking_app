// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_tracking_app/Core/Database%20Service/Auth%20Database%20Service/auth_database_service.dart';
import 'package:note_tracking_app/Core/Model/Auth%20Model/auth_model.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Screens/login_screen.dart';
import 'package:note_tracking_app/Utils/Constant/Strings/strings.dart';
import 'package:path_provider/path_provider.dart';

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
      currentUserId = user.id;
      currentUserImage = File(user.image);
      currentUserEmail = user.email;
      currentUserName = user.name;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> checkLogin() async {
    final user = await authDatabaseService.getUserById();
    if (user != null) {
      currentUserId = user.id;
      currentUserImage = File(user.image);
      currentUserEmail = user.email;
      currentUserName = user.name;
      notifyListeners();
    }
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
      name.text = name.text.trimRight();
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
        passwordShow = false;
        conPasswordShow = false;
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
    if (name.text.isNotEmpty) {
      currentUserName = name.text;
      currentUserImage = tempImage;
      print(currentUserImage.path);
      final update = AuthModel(
        id: currentUserId,
        name: currentUserName,
        email: email.text,
        password: password.text,
        image: currentUserImage.path,
        is_logged: 1,
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
  String currentUserName = '';
  String currentUserEmail = '';
  File currentUserImage = File('');
  File tempImage = File('');

  void getCurrentUserData(
      int id, String name, String email, String image) async {
    currentUserId = id;
    currentUserName = name;
    currentUserEmail = email;
    if (image == 'assets/Images/manager.png') {
      final byteData = await rootBundle.load(image);

      final file = File('${(await getTemporaryDirectory()).path}/$image');
      await file.create(recursive: true);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      currentUserImage = File(file.path);
    } else {
      currentUserImage = File(image);
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    if (currentUserId != null || currentUserId != 0) {
      await authDatabaseService.logoutUser(currentUserId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.logOutSuccess,
          ),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
      name.clear();
      password.clear();
      email.clear();
      confirmPassword.clear();
      image = null;
    }
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

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  File? image;

  bool isLoading = false;
  Future<void> pickImage() async {
    isLoading = true;
    notifyListeners();

    final pick = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pick != null) {
      image = File(
        pick.path,
      );
      tempImage = image!;
    }
    isLoading = false;
    notifyListeners();
  }

  final key = GlobalKey<FormState>();
}
