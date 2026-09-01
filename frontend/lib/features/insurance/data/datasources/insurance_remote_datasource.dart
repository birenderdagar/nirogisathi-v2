import '../../domain/entities/insurance_entity.dart';
import '../models/insurance_model.dart';

abstract class InsuranceRemoteDataSource {
  Future<List<InsuranceModel>> getInsurances();
}

class InsuranceRemoteDataSourceImpl implements InsuranceRemoteDataSource {
  @override
  Future<List<InsuranceModel>> getInsurances() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      InsuranceModel(
        id: "INS001",
        policyNumber: "POL-12345678",
        providerName: "Star Health Insurance",
        planName: "Family Health Optima",
        coverageAmount: 500000.0,
        expiryDate: DateTime(2025, 12, 31),
        status: InsuranceStatus.active,
        providerLogo: "https://starhealth.in/logo.png",
        benefits: const [
          "Cashless Treatment",
          "Pre & Post Hospitalization",
          "Day Care Procedures",
          "Health Checkup Cover"
        ],
      ),
      InsuranceModel(
        id: "INS002",
        policyNumber: "POL-87654321",
        providerName: "HDFC ERGO",
        planName: "Optima Restore",
        coverageAmount: 1000000.0,
        expiryDate: DateTime(2024, 06, 15),
        status: InsuranceStatus.active,
        providerLogo: "https://hdfcergo.com/logo.png",
        benefits: const [
          "Restore Benefit",
          "No Claim Bonus",
          "Worldwide Emergency Cover"
        ],
      ),
    ];
  }
}
