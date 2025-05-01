class AuthModel {
  int? id;
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
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'image': image,
    };
  }

  factory AuthModel.fromMap(Map m1) {
    return AuthModel(
      id: m1['id'],
      name: m1['name'],
      email: m1['email'],
      password: m1['password'],
      image: m1['image'],
    );
  }
}
