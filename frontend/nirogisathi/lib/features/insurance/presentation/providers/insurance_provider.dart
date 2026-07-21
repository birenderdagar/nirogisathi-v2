import 'package:flutter/foundation.dart';
import '../../domain/entities/insurance_entity.dart';
import '../../domain/usecases/get_insurances_usecase.dart';

class InsuranceProvider extends ChangeNotifier {
  final GetInsurancesUseCase getInsurancesUseCase;

  InsuranceProvider(this.getInsurancesUseCase);

  List<InsuranceEntity> _insurances = [];
  List<InsuranceEntity> get insurances => _insurances;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchInsurances() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getInsurancesUseCase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (list) {
        _insurances = list;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
