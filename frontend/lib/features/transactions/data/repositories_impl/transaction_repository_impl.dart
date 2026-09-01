import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../datasources/transaction_local_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(String type) async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactions(type: type);
      return Right(remoteTransactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> getTransactionDetails(String id) async {
    try {
      final transactions = await remoteDataSource.getTransactions(type: "all");
      final transaction = transactions.firstWhere((element) => element.id == id);
      return Right(transaction);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
