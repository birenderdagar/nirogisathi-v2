class PrescriptionRecord {
  final String id;
  final String doctorName;
  final String date;
  final String time;
  final String purpose;
  final String clinicalNotes;
  final String investigation;
  final String remarks;
  final List<String> imagePaths;
  final DateTime createdAt;

  const PrescriptionRecord({
    required this.id,
    required this.doctorName,
    required this.date,
    this.time = '',
    this.purpose = '',
    this.clinicalNotes = '',
    this.investigation = '',
    this.remarks = '',
    this.imagePaths = const [],
    required this.createdAt,
  });

  String get title => doctorName.isNotEmpty ? doctorName : 'Prescription';

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctorName': doctorName,
        'date': date,
        'time': time,
        'purpose': purpose,
        'clinicalNotes': clinicalNotes,
        'investigation': investigation,
        'remarks': remarks,
        'imagePaths': imagePaths,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PrescriptionRecord.fromJson(Map<String, dynamic> json) {
    return PrescriptionRecord(
      id: json['id']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      purpose: json['purpose']?.toString() ?? '',
      clinicalNotes: json['clinicalNotes']?.toString() ?? '',
      investigation: json['investigation']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      imagePaths: (json['imagePaths'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  PrescriptionRecord copyWith({
    String? doctorName,
    String? date,
    String? time,
    String? purpose,
    String? clinicalNotes,
    String? investigation,
    String? remarks,
    List<String>? imagePaths,
  }) {
    return PrescriptionRecord(
      id: id,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      time: time ?? this.time,
      purpose: purpose ?? this.purpose,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      investigation: investigation ?? this.investigation,
      remarks: remarks ?? this.remarks,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt,
    );
  }
}

class LabReportRecord {
  final String id;
  final String labName;
  final String date;
  final String time;
  final String reportType;
  final String clinicalNotes;
  final String observations;
  final String remarks;
  final List<String> imagePaths;
  final DateTime createdAt;

  const LabReportRecord({
    required this.id,
    required this.labName,
    required this.date,
    this.time = '',
    this.reportType = '',
    this.clinicalNotes = '',
    this.observations = '',
    this.remarks = '',
    this.imagePaths = const [],
    required this.createdAt,
  });

  String get title => labName.isNotEmpty ? labName : 'Lab Report';

  Map<String, dynamic> toJson() => {
        'id': id,
        'labName': labName,
        'date': date,
        'time': time,
        'reportType': reportType,
        'clinicalNotes': clinicalNotes,
        'observations': observations,
        'remarks': remarks,
        'imagePaths': imagePaths,
        'createdAt': createdAt.toIso8601String(),
      };

  factory LabReportRecord.fromJson(Map<String, dynamic> json) {
    return LabReportRecord(
      id: json['id']?.toString() ?? '',
      labName: json['labName']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      reportType: json['reportType']?.toString() ?? '',
      clinicalNotes: json['clinicalNotes']?.toString() ?? '',
      observations: json['observations']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      imagePaths: (json['imagePaths'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  LabReportRecord copyWith({
    String? labName,
    String? date,
    String? time,
    String? reportType,
    String? clinicalNotes,
    String? observations,
    String? remarks,
    List<String>? imagePaths,
  }) {
    return LabReportRecord(
      id: id,
      labName: labName ?? this.labName,
      date: date ?? this.date,
      time: time ?? this.time,
      reportType: reportType ?? this.reportType,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      observations: observations ?? this.observations,
      remarks: remarks ?? this.remarks,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt,
    );
  }
}

class DiagnosticRecord {
  final String id;
  final String hospitalName;
  final String date;
  final String time;
  final String reportType;
  final String clinicalNotes;
  final String doctorNotes;
  final String remarks;
  final List<String> imagePaths;
  final DateTime createdAt;

  const DiagnosticRecord({
    required this.id,
    required this.hospitalName,
    required this.date,
    this.time = '',
    this.reportType = '',
    this.clinicalNotes = '',
    this.doctorNotes = '',
    this.remarks = '',
    this.imagePaths = const [],
    required this.createdAt,
  });

  String get title => hospitalName.isNotEmpty ? hospitalName : 'Diagnostic';

  Map<String, dynamic> toJson() => {
        'id': id,
        'hospitalName': hospitalName,
        'date': date,
        'time': time,
        'reportType': reportType,
        'clinicalNotes': clinicalNotes,
        'doctorNotes': doctorNotes,
        'remarks': remarks,
        'imagePaths': imagePaths,
        'createdAt': createdAt.toIso8601String(),
      };

  factory DiagnosticRecord.fromJson(Map<String, dynamic> json) {
    return DiagnosticRecord(
      id: json['id']?.toString() ?? '',
      hospitalName: json['hospitalName']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      reportType: json['reportType']?.toString() ?? '',
      clinicalNotes: json['clinicalNotes']?.toString() ?? '',
      doctorNotes: json['doctorNotes']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      imagePaths: (json['imagePaths'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  DiagnosticRecord copyWith({
    String? hospitalName,
    String? date,
    String? time,
    String? reportType,
    String? clinicalNotes,
    String? doctorNotes,
    String? remarks,
    List<String>? imagePaths,
  }) {
    return DiagnosticRecord(
      id: id,
      hospitalName: hospitalName ?? this.hospitalName,
      date: date ?? this.date,
      time: time ?? this.time,
      reportType: reportType ?? this.reportType,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      remarks: remarks ?? this.remarks,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt,
    );
  }
}

class MedicineRecord {
  final String id;
  final String name;
  final String dose;
  final String doctorName;
  final String date;
  final String time;
  final String purpose;
  final String instructions;
  final String remarks;
  final List<String> imagePaths;
  final DateTime createdAt;

  const MedicineRecord({
    required this.id,
    required this.name,
    this.dose = '',
    this.doctorName = '',
    required this.date,
    this.time = '',
    this.purpose = '',
    this.instructions = '',
    this.remarks = '',
    this.imagePaths = const [],
    required this.createdAt,
  });

  String get title => name.isNotEmpty ? name : 'Medicine';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dose': dose,
        'doctorName': doctorName,
        'date': date,
        'time': time,
        'purpose': purpose,
        'instructions': instructions,
        'remarks': remarks,
        'imagePaths': imagePaths,
        'createdAt': createdAt.toIso8601String(),
      };

  factory MedicineRecord.fromJson(Map<String, dynamic> json) {
    return MedicineRecord(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      dose: json['dose']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      purpose: json['purpose']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      imagePaths: (json['imagePaths'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  MedicineRecord copyWith({
    String? name,
    String? dose,
    String? doctorName,
    String? date,
    String? time,
    String? purpose,
    String? instructions,
    String? remarks,
    List<String>? imagePaths,
  }) {
    return MedicineRecord(
      id: id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      time: time ?? this.time,
      purpose: purpose ?? this.purpose,
      instructions: instructions ?? this.instructions,
      remarks: remarks ?? this.remarks,
      imagePaths: imagePaths ?? this.imagePaths,
      createdAt: createdAt,
    );
  }
}

/// Helpers for list-card date chips.
class HealthLockerDateParts {
  final String day;
  final String month;

  const HealthLockerDateParts(this.day, this.month);

  static HealthLockerDateParts from(String date, DateTime fallback) {
    final parts = date.split(RegExp(r'[/\-.]'));
    if (parts.length >= 2) {
      final day = parts[0].padLeft(2, '0');
      final monthNum = int.tryParse(parts[1]);
      const months = [
        'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
        'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
      ];
      final month = (monthNum != null && monthNum >= 1 && monthNum <= 12)
          ? months[monthNum - 1]
          : parts[1].toUpperCase();
      return HealthLockerDateParts(day, month);
    }
    return HealthLockerDateParts(
      fallback.day.toString().padLeft(2, '0'),
      [
        'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
        'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
      ][fallback.month - 1],
    );
  }
}
