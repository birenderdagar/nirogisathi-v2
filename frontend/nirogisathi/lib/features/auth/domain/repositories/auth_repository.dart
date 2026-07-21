import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart' as domain;

abstract class AuthRepository {
  Future<Either<Failure, domain.User>> loginWithMobile(String mobile, String mpin);
  Future<Either<Failure, Unit>> signUp({required String name, required String mobile, required String email, required String mpin});
  Future<Either<Failure, Unit>> completeProfile({required String uid, required Map<String, dynamic> profileData});
  Future<Either<Failure, domain.User?>> getUser();
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, dynamic>> loginWithOtp(String phone);
  Future<Either<Failure, dynamic>> verifyOtp(String mobile, String otp);
  
  // 🛠️ Diagnostic
  dynamic get remoteDataSource;
}
