import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String name;
  final String gender;
  final int age;

  Person({
    required this.name,
    required this.gender,
    required this.age,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
    };
  }

  factory Person.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Person(
      name: data?['name'] ?? '',
      gender: data?['gender'] ?? '',
      age: data?['age'] ?? 0,
    );
  }
}
