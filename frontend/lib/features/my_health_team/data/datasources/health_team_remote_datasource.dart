import 'dart:async';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/health_professional_model.dart';
import '../models/hospital_model.dart';
import '../models/doctor_model.dart';

abstract class HealthTeamRemoteDataSource {
  Future<List<HealthProfessionalModel>> getMyHealthTeam();
  Future<List<HospitalModel>> getPreferredHospitals();
  Future<List<HospitalModel>> getOtherHospitals();
  Future<List<DoctorModel>> getPreferredDoctors();
  Future<List<DoctorModel>> getPopularDoctors();
  Future<List<DoctorModel>> getFeatureDoctors();
}

class HealthTeamRemoteDataSourceImpl implements HealthTeamRemoteDataSource {
  final ApiClient apiClient;

  HealthTeamRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<HealthProfessionalModel>> getMyHealthTeam() async {
    try {
      final response = await apiClient.get(ApiConstants.myHealthTeam);
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => HealthProfessionalModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Fallback for demo
      return [];
    }
  }

  @override
  Future<List<HospitalModel>> getPreferredHospitals() async {
    try {
      final response = await apiClient.get(ApiConstants.hospitals, queryParameters: {'type': 'preferred'});
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => HospitalModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<HospitalModel>> getOtherHospitals() async {
    try {
      final response = await apiClient.get(ApiConstants.hospitals, queryParameters: {'type': 'other'});
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => HospitalModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DoctorModel>> getPreferredDoctors() async {
    try {
      final response = await apiClient.get(ApiConstants.doctors, queryParameters: {'filter': 'preferred'});
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => DoctorModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DoctorModel>> getPopularDoctors() async {
    try {
      final response = await apiClient.get(ApiConstants.doctors, queryParameters: {'filter': 'popular'});
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => DoctorModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DoctorModel>> getFeatureDoctors() async {
    try {
      final response = await apiClient.get(ApiConstants.doctors, queryParameters: {'filter': 'featured'});
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => DoctorModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
