import '../../domain/entities/insurance_entity.dart';

class InsuranceModel extends InsuranceEntity {
  const InsuranceModel({
    required super.id,
    required super.policyNumber,
    required super.providerName,
    required super.planName,
    required super.coverageAmount,
    required super.expiryDate,
    required super.status,
    required super.providerLogo,
    super.benefits,
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      id: json['id'] as String,
      policyNumber: json['policyNumber'] as String,
      providerName: json['providerName'] as String,
      planName: json['planName'] as String,
      coverageAmount: (json['coverageAmount'] as num).toDouble(),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      status: _mapStatus(json['status'] as String),
      providerLogo: json['providerLogo'] as String,
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }

  static InsuranceStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active': return InsuranceStatus.active;
      case 'pending': return InsuranceStatus.pending;
      case 'expired': return InsuranceStatus.expired;
      default: return InsuranceStatus.pending;
    }
  }
}
