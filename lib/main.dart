import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:note_tracking_app/Core/Provider/note_provider.dart';
import 'package:note_tracking_app/Module/Login%20Screen/Screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NoteProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
