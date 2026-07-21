abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network Error']);
}

class GeneralFailure extends Failure {
  const GeneralFailure([super.message = 'Unexpected Error']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown Error']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Invalid Credentials']);
}