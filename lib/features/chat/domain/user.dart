import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;

  const User({required this.id, required this.name});

  String get initials {
    if (name.isEmpty) return "?";
    final parts = name.trim().split(" ");
    if (parts.length > 1) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  List<Object?> get props => [id, name];
}
