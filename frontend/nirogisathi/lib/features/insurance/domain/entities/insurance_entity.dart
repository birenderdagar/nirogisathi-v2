import 'package:equatable/equatable.dart';

enum InsuranceStatus { active, pending, expired }

class InsuranceEntity extends Equatable {
  final String id;
  final String policyNumber;
  final String providerName;
  final String planName;
  final double coverageAmount;
  final DateTime expiryDate;
  final InsuranceStatus status;
  final String providerLogo;
  final List<String> benefits;

  const InsuranceEntity({
    required this.id,
    required this.policyNumber,
    required this.providerName,
    required this.planName,
    required this.coverageAmount,
    required this.expiryDate,
    required this.status,
    required this.providerLogo,
    this.benefits = const [],
  });

  @override
  List<Object?> get props => [
        id,
        policyNumber,
        providerName,
        planName,
        coverageAmount,
        expiryDate,
        status,
        providerLogo,
        benefits,
      ];
}
