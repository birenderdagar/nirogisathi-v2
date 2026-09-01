import 'package:flutter/material.dart';
import '../../domain/entities/health_professional.dart';
import '../../domain/entities/hospital.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/usecases/get_my_health_team_usecase.dart';
import '../../domain/usecases/get_hospitals_usecase.dart';
import '../../domain/usecases/get_doctors_usecase.dart';

class HealthTeamProvider extends ChangeNotifier {
  final GetMyHealthTeamUseCase getMyHealthTeamUseCase;
  final GetHospitalsUseCase getHospitalsUseCase;
  final GetDoctorsUseCase getDoctorsUseCase;

  HealthTeamProvider(
    this.getMyHealthTeamUseCase,
    this.getHospitalsUseCase,
    this.getDoctorsUseCase,
  );

  List<HealthProfessional> _team = [];
  List<Hospital> _preferredHospitals = [];
  List<Hospital> _otherHospitals = [];
  
  List<Doctor> _preferredDoctors = [];
  List<Doctor> _popularDoctors = [];
  List<Doctor> _featureDoctors = [];

  bool _isLoading = false;
  String? _error;

  List<HealthProfessional> get team => _team;
  List<Hospital> get preferredHospitals => _preferredHospitals;
  List<Hospital> get otherHospitals => _otherHospitals;
  
  List<Doctor> get preferredDoctors => _preferredDoctors;
  List<Doctor> get popularDoctors => _popularDoctors;
  List<Doctor> get featureDoctors => _featureDoctors;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHealthTeam() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getMyHealthTeamUseCase();

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (members) {
        _team = members;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchHospitals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getHospitalsUseCase();

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _preferredHospitals = data['preferred'] ?? [];
        _otherHospitals = data['others'] ?? [];
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchDoctors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getDoctorsUseCase();

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _preferredDoctors = data['preferred'] ?? [];
        _popularDoctors = data['popular'] ?? [];
        _featureDoctors = data['feature'] ?? [];
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
