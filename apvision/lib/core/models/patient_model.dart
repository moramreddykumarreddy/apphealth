import 'package:flutter/material.dart';

class ScreeningVisit {
  final String date;
  final String doctor;
  final String diagnosis;
  final String iop;
  final String va;
  final String notes;
  final String plan;

  ScreeningVisit({
    required this.date,
    required this.doctor,
    required this.diagnosis,
    required this.iop,
    required this.va,
    required this.notes,
    required this.plan,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'doctor': doctor,
      'diagnosis': diagnosis,
      'iop': iop,
      'va': va,
      'notes': notes,
      'plan': plan,
    };
  }
}

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String village;
  final String phone;
  final String lastVisit;
  final String diagnosis;
  final String status;
  final Color color;
  final List<ScreeningVisit> visits;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.village,
    required this.phone,
    required this.lastVisit,
    required this.diagnosis,
    required this.status,
    required this.color,
    required this.visits,
  });

  Patient copyWith({
    String? status,
    String? lastVisit,
    String? diagnosis,
    List<ScreeningVisit>? visits,
  }) {
    return Patient(
      id: id,
      name: name,
      age: age,
      gender: gender,
      village: village,
      phone: phone,
      lastVisit: lastVisit ?? this.lastVisit,
      diagnosis: diagnosis ?? this.diagnosis,
      status: status ?? this.status,
      color: color,
      visits: visits ?? this.visits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'village': village,
      'phone': phone,
      'lastVisit': lastVisit,
      'diagnosis': diagnosis,
      'status': status,
      'color': color.value,
      'visits': visits.map((v) => v.toMap()).toList(),
    };
  }
}
