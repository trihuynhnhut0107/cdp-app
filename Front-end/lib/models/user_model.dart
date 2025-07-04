/// User model representing user data from the API
/// Contains user's id, name, email, and point count
class UserModel {
  final String id;
  final String name;
  final String email;
  final int point;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.point,
  });

  /// Creates a UserModel from JSON data
  /// Handles various possible JSON structures from the API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      point: json['point']?.toInt() ?? 0,
    );
  }

  /// Converts UserModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'point': point,
    };
  }

  /// Creates a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? point,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      point: point ?? this.point,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, point: $point}';
  }
}
