import 'package:flutter/foundation.dart';
import '../../domain/entities/planner_event.dart';

class DayPlannerProvider extends ChangeNotifier {
  static final DateTime _today = DateTime.now();

  final List<PlannerEvent> _allEvents = [
    PlannerEvent(
      id: '1',
      title: 'Meet Dr. Vidhi',
      description: 'Root canal check up',
      date: DateTime(_today.year, _today.month, _today.day),
      time: '10:30 AM',
      type: PlannerEventType.appointment,
    ),
    PlannerEvent(
      id: '2',
      title: 'Morning Yoga',
      description: 'Daily wellness session',
      date: DateTime(_today.year, _today.month, _today.day),
      time: '07:00 AM',
      type: PlannerEventType.schedule,
    ),
    PlannerEvent(
      id: '3',
      title: 'Blood Test',
      description: 'At PathKind Labs',
      date: _today.add(const Duration(days: 1)),
      time: '09:00 AM',
      type: PlannerEventType.event,
    ),
  ];

  DateTime _selectedDate = DateTime(_today.year, _today.month, _today.day);
  DateTime get selectedDate => _selectedDate;

  List<PlannerEvent> get eventsForSelectedDay => _allEvents
      .where((e) =>
          e.date.year == _selectedDate.year &&
          e.date.month == _selectedDate.month &&
          e.date.day == _selectedDate.day)
      .toList();

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  void addEvent(PlannerEvent event) {
    _allEvents.add(event);
    notifyListeners();
  }
}
