import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../../core/services/biometric_service.dart';
import '../../core/storage/local_storage_service.dart';
import '../../core/network/api_client.dart';

// Splash
import '../../features/Splash/presentation/provider/splash_provider.dart';

// Auth - Data
import '../../features/auth/data/datasources/user_firestore_datasource.dart';
import '../../features/auth/data/datasources/session_local_datasource.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Auth - Domain
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/check_app_state_usecase.dart';

// Auth - Presentation
import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/auth/presentation/controller/auth_controller.dart';

// Location - Data
import '../../features/location/data/datasources/location_remote_datasource.dart';
import '../../features/location/data/repositories/location_repository_impl.dart';

// Location - Domain
import '../../features/location/domain/repositories/location_repository.dart';
import '../../features/location/domain/usecases/get_location_usecase.dart';

// Location - Presentation
import '../../features/location/presentation/provider/location_provider.dart';

// Transactions - Data
import '../../features/transactions/data/datasources/transaction_remote_datasource.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../features/transactions/data/repositories_impl/transaction_repository_impl.dart';

// Transactions - Domain
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/get_transactions_usecase.dart';

// Transactions - Presentation
import '../../features/transactions/presentation/providers/transaction_provider.dart';

// Orders - Data
import '../../features/orders/data/datasources/order_remote_datasource.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';

// Orders - Domain
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';

// Orders - Presentation
import '../../features/orders/presentation/providers/order_provider.dart';

// Insurance - Data
import '../../features/insurance/data/datasources/insurance_remote_datasource.dart';
import '../../features/insurance/data/repositories/insurance_repository_impl.dart';

// Insurance - Domain
import '../../features/insurance/domain/repositories/insurance_repository.dart';
import '../../features/insurance/domain/usecases/get_insurances_usecase.dart';

// Insurance - Presentation
import '../../features/insurance/presentation/providers/insurance_provider.dart';

// Cart - Presentation ✅
import '../../features/cart/presentation/providers/cart_provider.dart';

// My Health Team - Data
import '../../features/my_health_team/data/datasources/health_team_remote_datasource.dart';
import '../../features/my_health_team/data/repositories/health_team_repository_impl.dart';

// My Health Team - Domain
import '../../features/my_health_team/domain/repositories/health_team_repository.dart';
import '../../features/my_health_team/domain/usecases/get_my_health_team_usecase.dart';
import '../../features/my_health_team/domain/usecases/get_hospitals_usecase.dart';
import '../../features/my_health_team/domain/usecases/get_doctors_usecase.dart';

// My Health Team - Presentation
import '../../features/my_health_team/presentation/providers/health_team_provider.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // ================= FIREBASE =================

  getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  // ================= BIOMETRIC =================

  getIt.registerLazySingleton<LocalAuthentication>(
        () => LocalAuthentication(),
  );

  getIt.registerLazySingleton<BiometricService>(
        () => BiometricService(getIt<LocalAuthentication>()),
  );

  // ================= LOCAL STORAGE =================

  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<LocalStorageService>(
        () => LocalStorageService(prefs),
  );

  // ================= NETWORK =================

  getIt.registerLazySingleton<ApiClient>(
        () => ApiClient(getIt<LocalStorageService>()),
  );

  // ================= SESSION DATA SOURCE =================

  getIt.registerLazySingleton<SessionLocalDataSource>(
        () => SessionLocalDataSource(getIt<LocalStorageService>()),
  );

  // ================= FIRESTORE DATA SOURCE =================

  getIt.registerLazySingleton<UserFirestoreDataSource>(
        () => UserFirestoreDataSource(getIt<FirebaseFirestore>()),
  );

  // ================= REMOTE DATA SOURCE =================

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // ================= REPOSITORY =================

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      getIt<UserFirestoreDataSource>(),
      getIt<SessionLocalDataSource>(),
      getIt<AuthRemoteDataSource>(),
    ),
  );

  // ================= USECASES =================

  getIt.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<CheckAppStateUseCase>(
        () => CheckAppStateUseCase(getIt<AuthRepository>()),
  );

  // ================= PROVIDERS =================

  getIt.registerFactory<AuthProvider>(
        () => AuthProvider(
      getIt<LoginUseCase>(),
      getIt<AuthRepository>(),
      getIt<BiometricService>(),
    ),
  );

  getIt.registerFactory<AuthController>(
    () => AuthController(
      loginUseCase: getIt<LoginUseCase>(),
      repository: getIt<AuthRepository>(),
      biometricService: getIt<BiometricService>(),
    ),
  );

  getIt.registerLazySingleton<SplashProvider>(
        () => SplashProvider(
      getIt<CheckAppStateUseCase>(),
    ),
  );

  // ================= LOCATION FEATURE =================

  getIt.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(getIt<LocationRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetLocationUseCase>(
    () => GetLocationUseCase(getIt<LocationRepository>()),
  );

  getIt.registerLazySingleton<LocationProvider>(
    () => LocationProvider(getIt<GetLocationUseCase>()),
  );

  // ================= TRANSACTIONS FEATURE =================

  getIt.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(prefs),
  );

  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: getIt<TransactionRemoteDataSource>(),
      localDataSource: getIt<TransactionLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(getIt<TransactionRepository>()),
  );

  getIt.registerFactory<TransactionProvider>(
    () => TransactionProvider(getIt<GetTransactionsUseCase>()),
  );

  // ================= ORDERS FEATURE =================

  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetOrdersUseCase>(
    () => GetOrdersUseCase(getIt<OrderRepository>()),
  );

  getIt.registerFactory<OrderProvider>(
    () => OrderProvider(getIt<GetOrdersUseCase>()),
  );

  // ================= INSURANCE FEATURE =================

  getIt.registerLazySingleton<InsuranceRemoteDataSource>(
    () => InsuranceRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<InsuranceRepository>(
    () => InsuranceRepositoryImpl(getIt<InsuranceRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetInsurancesUseCase>(
    () => GetInsurancesUseCase(getIt<InsuranceRepository>()),
  );

  getIt.registerFactory<InsuranceProvider>(
    () => InsuranceProvider(getIt<GetInsurancesUseCase>()),
  );

  // ================= CART FEATURE ✅ =================
  getIt.registerLazySingleton<CartProvider>(
    () => CartProvider(),
  );

  // ================= MY HEALTH TEAM FEATURE =================

  getIt.registerLazySingleton<HealthTeamRemoteDataSource>(
    () => HealthTeamRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<HealthTeamRepository>(
    () => HealthTeamRepositoryImpl(getIt<HealthTeamRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetMyHealthTeamUseCase>(
    () => GetMyHealthTeamUseCase(getIt<HealthTeamRepository>()),
  );

  getIt.registerLazySingleton<GetHospitalsUseCase>(
    () => GetHospitalsUseCase(getIt<HealthTeamRepository>()),
  );

  getIt.registerLazySingleton<GetDoctorsUseCase>(
    () => GetDoctorsUseCase(getIt<HealthTeamRepository>()),
  );

  getIt.registerFactory<HealthTeamProvider>(
    () => HealthTeamProvider(
      getIt<GetMyHealthTeamUseCase>(),
      getIt<GetHospitalsUseCase>(),
      getIt<GetDoctorsUseCase>(),
    ),
  );
}
