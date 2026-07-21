import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.amount,
    required super.date,
    required super.status,
    required super.type,
    required super.category,
    super.subtitle,
    super.doctorName,
    super.phoneNumber,
    super.location,
    super.placedTime,
    super.statusTime,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: _mapStatus(json['status'] as String),
      type: _mapType(json['type'] as String),
      category: json['category'] as String? ?? 'payment',
      subtitle: json['subtitle'] as String?,
      doctorName: json['doctorName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      location: json['location'] as String?,
      placedTime: json['placedTime'] as String?,
      statusTime: json['statusTime'] as String?,
    );
  }

  static TransactionStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'success': return TransactionStatus.success;
      case 'pending': return TransactionStatus.pending;
      case 'failed': return TransactionStatus.failed;
      case 'confirmed': return TransactionStatus.confirmed;
      case 'missed': return TransactionStatus.missed;
      default: return TransactionStatus.pending;
    }
  }

  static TransactionType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'credit': return TransactionType.credit;
      case 'debit': return TransactionType.debit;
      default: return TransactionType.debit;
    }
  }
}
