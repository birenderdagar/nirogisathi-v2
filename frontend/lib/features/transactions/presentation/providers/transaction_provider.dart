import 'package:flutter/foundation.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_transactions_usecase.dart';

class TransactionProvider extends ChangeNotifier {
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionProvider(this.getTransactionsUseCase);

  List<TransactionEntity> _transactions = [];
  List<TransactionEntity> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches transactions for a specific tab
  Future<void> fetchTransactions({String type = "all"}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getTransactionsUseCase(type);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (list) {
        _transactions = list;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
