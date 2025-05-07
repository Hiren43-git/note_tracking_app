import 'package:flutter/material.dart';
import 'package:note_tracking_app/Core/Database%20Service/database_service.dart';
import 'package:note_tracking_app/Core/Model/Auth%20Model/auth_model.dart';
import 'package:note_tracking_app/Core/Provider/Auth%20Provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthDatabaseService {
  final dbHelper = DbHelper.helper;

  Future<void> addUser(AuthModel user) async {
    final dbClient = await dbHelper.database;
    if (user.email.isNotEmpty && user.password.isNotEmpty) {
      await dbClient?.insert('users', user.toMap());
    }
  }

  Future<AuthModel?> loginUser(
      String email, String password, BuildContext context) async {
    final dbClient = await dbHelper.database;
    List<Map<String, dynamic>> result = await dbClient!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [
        email,
        password,
      ],
    );
    if (result.isNotEmpty) {
      final userId = result.first['id'] as int;
      final name = result.first['name'] as String;
      Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUserId(userId);
      Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUserName(name);
      return AuthModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateUser(AuthModel user) async {
    final dbClient = await dbHelper.database;
    await dbClient!.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final dbClient = await dbHelper.database;
    await dbClient!.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<AuthModel?> getUserById(String email) async {
    final dbClient = await dbHelper.database;
    List<Map<String, dynamic>> result = await dbClient!.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return AuthModel.fromMap(result.first);
    }
    return null;
  }
}
