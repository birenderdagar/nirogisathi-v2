import 'package:shared_preferences/shared_preferences.dart';

abstract class TransactionLocalDataSource {
  Future<void> cacheTransactions(String transactionsJson);
  String? getCachedTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final SharedPreferences sharedPreferences;

  TransactionLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheTransactions(String transactionsJson) {
    return sharedPreferences.setString('CACHED_TRANSACTIONS', transactionsJson);
  }

  @override
  String? getCachedTransactions() {
    return sharedPreferences.getString('CACHED_TRANSACTIONS');
  }
}
