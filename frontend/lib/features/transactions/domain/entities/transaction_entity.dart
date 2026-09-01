import 'package:equatable/equatable.dart';

enum TransactionStatus { success, pending, failed, confirmed, missed }
enum TransactionType { credit, debit }

class TransactionEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionStatus status;
  final TransactionType type;
  final String category; // payment, appointment, visit
  
  // New fields for improved design
  final String? subtitle; 
  final String? doctorName;
  final String? phoneNumber;
  final String? location;
  final String? placedTime;
  final String? statusTime;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
    required this.type,
    required this.category,
    this.subtitle,
    this.doctorName,
    this.phoneNumber,
    this.location,
    this.placedTime,
    this.statusTime,
  });

  @override
  List<Object?> get props => [
    id, title, description, amount, date, status, type, category,
    subtitle, doctorName, phoneNumber, location, placedTime, statusTime,
  ];
}
