import 'package:flutter/foundation.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentProvider extends ChangeNotifier {
  static final DateTime _today = DateTime.now();

  final List<AppointmentEntity> _allAppointments = [
    AppointmentEntity(
      id: '1',
      title: 'Meet Dr. Vidhi',
      subtitle: 'Root canal check up',
      date: DateTime(_today.year, _today.month, _today.day),
      time: '10:30 Am',
    ),
    AppointmentEntity(
      id: '2',
      title: 'Meet Dr. Varun',
      subtitle: 'Skin Checkup',
      date: DateTime(_today.year, _today.month, _today.day),
      time: '12:00 Pm',
    ),
    AppointmentEntity(
      id: '3',
      title: 'Dr. Ankur Jain',
      subtitle: 'Routine Checkup',
      date: _today.add(const Duration(days: 1)),
      time: '02:00 Pm',
    ),
    AppointmentEntity(
      id: '4',
      title: 'Dental Cleaning',
      subtitle: 'Dr. Mehra',
      date: _today.add(const Duration(days: 2)),
      time: '09:00 Am',
    ),
  ];

  DateTime _selectedDate = DateTime(_today.year, _today.month, _today.day);
  DateTime get selectedDate => _selectedDate;

  List<AppointmentEntity> get appointments => _allAppointments
      .where((a) =>
          a.date.year == _selectedDate.year &&
          a.date.month == _selectedDate.month &&
          a.date.day == _selectedDate.day)
      .toList();

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }
}
