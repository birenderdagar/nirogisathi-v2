import 'package:intl/intl.dart';

String calculateAge(String? dob) {
  if (dob == null || dob.isEmpty || dob == 'N/A') return 'N/A';

  try {
    final birthDate = _parseDob(dob.trim());
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    if (age < 0 || age > 150) return 'N/A';
    return age.toString();
  } catch (e) {
    return 'N/A';
  }
}

DateTime _parseDob(String dob) {
  // Backend / MySQL date: yyyy-MM-dd (optionally with time)
  if (dob.contains('-') && dob.indexOf('-') == 4) {
    return DateTime.parse(dob);
  }

  if (dob.contains('-')) {
    return DateFormat('dd-MM-yyyy').parseStrict(dob);
  }

  if (dob.contains('/')) {
    return DateFormat('dd/MM/yyyy').parseStrict(dob);
  }

  return DateTime.parse(dob);
}
