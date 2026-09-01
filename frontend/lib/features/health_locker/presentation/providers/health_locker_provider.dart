import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/health_locker_items.dart';

class HealthLockerProvider extends ChangeNotifier {
  static const _prescriptionsKey = 'health_locker_prescriptions';
  static const _labReportsKey = 'health_locker_lab_reports';
  static const _diagnosticsKey = 'health_locker_diagnostics';
  static const _medicinesKey = 'health_locker_medicines';

  final SharedPreferences _prefs;
  final _uuid = const Uuid();

  final List<PrescriptionRecord> _prescriptions = [];
  final List<LabReportRecord> _labReports = [];
  final List<DiagnosticRecord> _diagnostics = [];
  final List<MedicineRecord> _medicines = [];

  String _prescriptionQuery = '';
  String _labQuery = '';
  String _diagnosticQuery = '';
  String _medicineQuery = '';

  HealthLockerProvider(this._prefs) {
    _loadAll();
  }

  List<PrescriptionRecord> get prescriptions {
    final q = _prescriptionQuery.trim().toLowerCase();
    final list = q.isEmpty
        ? List<PrescriptionRecord>.from(_prescriptions)
        : _prescriptions
            .where((e) =>
                e.doctorName.toLowerCase().contains(q) ||
                e.purpose.toLowerCase().contains(q) ||
                e.remarks.toLowerCase().contains(q) ||
                e.date.contains(q))
            .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<LabReportRecord> get labReports {
    final q = _labQuery.trim().toLowerCase();
    final list = q.isEmpty
        ? List<LabReportRecord>.from(_labReports)
        : _labReports
            .where((e) =>
                e.labName.toLowerCase().contains(q) ||
                e.reportType.toLowerCase().contains(q) ||
                e.remarks.toLowerCase().contains(q) ||
                e.date.contains(q))
            .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<DiagnosticRecord> get diagnostics {
    final q = _diagnosticQuery.trim().toLowerCase();
    final list = q.isEmpty
        ? List<DiagnosticRecord>.from(_diagnostics)
        : _diagnostics
            .where((e) =>
                e.hospitalName.toLowerCase().contains(q) ||
                e.reportType.toLowerCase().contains(q) ||
                e.remarks.toLowerCase().contains(q) ||
                e.date.contains(q))
            .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<MedicineRecord> get medicines {
    final q = _medicineQuery.trim().toLowerCase();
    final list = q.isEmpty
        ? List<MedicineRecord>.from(_medicines)
        : _medicines
            .where((e) =>
                e.name.toLowerCase().contains(q) ||
                e.doctorName.toLowerCase().contains(q) ||
                e.purpose.toLowerCase().contains(q) ||
                e.date.contains(q))
            .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int get medicineCount => _medicines.length;

  void setPrescriptionQuery(String value) {
    _prescriptionQuery = value;
    notifyListeners();
  }

  void setLabQuery(String value) {
    _labQuery = value;
    notifyListeners();
  }

  void setDiagnosticQuery(String value) {
    _diagnosticQuery = value;
    notifyListeners();
  }

  void setMedicineQuery(String value) {
    _medicineQuery = value;
    notifyListeners();
  }

  PrescriptionRecord? prescriptionById(String id) {
    try {
      return _prescriptions.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  LabReportRecord? labReportById(String id) {
    try {
      return _labReports.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  DiagnosticRecord? diagnosticById(String id) {
    try {
      return _diagnostics.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  MedicineRecord? medicineById(String id) {
    try {
      return _medicines.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addPrescription(PrescriptionRecord item) async {
    _prescriptions.add(item);
    await _persist(_prescriptionsKey, _prescriptions.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> updatePrescription(PrescriptionRecord item) async {
    final i = _prescriptions.indexWhere((e) => e.id == item.id);
    if (i < 0) return;
    _prescriptions[i] = item;
    await _persist(_prescriptionsKey, _prescriptions.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deletePrescription(String id) async {
    _prescriptions.removeWhere((e) => e.id == id);
    await _persist(_prescriptionsKey, _prescriptions.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> addLabReport(LabReportRecord item) async {
    _labReports.add(item);
    await _persist(_labReportsKey, _labReports.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> updateLabReport(LabReportRecord item) async {
    final i = _labReports.indexWhere((e) => e.id == item.id);
    if (i < 0) return;
    _labReports[i] = item;
    await _persist(_labReportsKey, _labReports.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteLabReport(String id) async {
    _labReports.removeWhere((e) => e.id == id);
    await _persist(_labReportsKey, _labReports.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> addDiagnostic(DiagnosticRecord item) async {
    _diagnostics.add(item);
    await _persist(_diagnosticsKey, _diagnostics.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> updateDiagnostic(DiagnosticRecord item) async {
    final i = _diagnostics.indexWhere((e) => e.id == item.id);
    if (i < 0) return;
    _diagnostics[i] = item;
    await _persist(_diagnosticsKey, _diagnostics.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteDiagnostic(String id) async {
    _diagnostics.removeWhere((e) => e.id == id);
    await _persist(_diagnosticsKey, _diagnostics.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> addMedicine(MedicineRecord item) async {
    _medicines.add(item);
    await _persist(_medicinesKey, _medicines.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> updateMedicine(MedicineRecord item) async {
    final i = _medicines.indexWhere((e) => e.id == item.id);
    if (i < 0) return;
    _medicines[i] = item;
    await _persist(_medicinesKey, _medicines.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> deleteMedicine(String id) async {
    _medicines.removeWhere((e) => e.id == id);
    await _persist(_medicinesKey, _medicines.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  String newId() => _uuid.v4();

  void _loadAll() {
    _prescriptions
      ..clear()
      ..addAll(_decodeList(_prescriptionsKey, PrescriptionRecord.fromJson));
    _labReports
      ..clear()
      ..addAll(_decodeList(_labReportsKey, LabReportRecord.fromJson));
    _diagnostics
      ..clear()
      ..addAll(_decodeList(_diagnosticsKey, DiagnosticRecord.fromJson));
    _medicines
      ..clear()
      ..addAll(_decodeList(_medicinesKey, MedicineRecord.fromJson));
  }

  List<T> _decodeList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map>()
          .map((e) => fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(String key, List<Map<String, dynamic>> items) async {
    await _prefs.setString(key, jsonEncode(items));
  }
}
