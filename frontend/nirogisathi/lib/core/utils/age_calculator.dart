import 'package:intl/intl.dart';

String calculateAge(String? dob) {
  if (dob == null || dob.isEmpty || dob == 'N/A') return 'N/A';
  
  try {
    DateTime birthDate;
    if (dob.contains('-')) {
      // Try dd-MM-yyyy first (Common in India/this app)
      try {
        birthDate = DateFormat("dd-MM-yyyy").parse(dob);
      } catch (e) {
        // Try yyyy-MM-dd (ISO)
        birthDate = DateTime.parse(dob);
      }
    } else if (dob.contains('/')) {
      birthDate = DateFormat("dd/MM/yyyy").parse(dob);
    } else {
      birthDate = DateTime.parse(dob);
    }

    final today = DateTime.now();
    int age = today.year - birthDate.year;
    
    if (today.month < birthDate.month || 
       (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    
    return age.toString();
  } catch (e) {
    return 'N/A';
  }
}
