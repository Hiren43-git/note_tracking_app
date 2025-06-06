// ignore_for_file: non_constant_identifier_names

class AuthModel {
  int? id;
  int? is_logged;
  final String name;
  final String email;
  final String password;
  final String image;

  AuthModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    this.is_logged = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'image': image,
      'is_logged': is_logged,
    };
  }

  factory AuthModel.fromMap(Map m1) {
    return AuthModel(
      id: m1['id'],
      name: m1['name'],
      email: m1['email'],
      password: m1['password'],
      image: m1['image'],
      is_logged: m1['is_logged'] ?? 0,
    );
  }
}
