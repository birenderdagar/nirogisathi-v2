import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/planner_reminder_service.dart';
import '../../domain/entities/planner_event.dart';

class DayPlannerProvider extends ChangeNotifier {
  static const _storageKey = 'day_planner_events';

  final SharedPreferences _prefs;
  final PlannerReminderService _reminders;
  final List<PlannerEvent> _allEvents = [];
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DayPlannerProvider(this._prefs, this._reminders) {
    _loadEvents();
    _reminders.rescheduleAll(_allEvents.where((e) => e.reminderEnabled));
  }

  DateTime get selectedDate => _selectedDate;

  List<PlannerEvent> get allEvents => List.unmodifiable(_allEvents);

  List<PlannerEvent> get eventsForSelectedDay {
    final events = _allEvents
        .where((e) => _isSameDay(e.date, _selectedDate))
        .toList();
    events.sort((a, b) => a.time.compareTo(b.time));
    return events;
  }

  bool hasEventsOn(DateTime date) {
    return _allEvents.any((e) => _isSameDay(e.date, date));
  }

  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  Future<void> addEvent(PlannerEvent event) async {
    _allEvents.add(event);
    _selectedDate = DateTime(event.date.year, event.date.month, event.date.day);
    await _persist();
    if (event.reminderEnabled) {
      await _reminders.schedule(event);
    }
    notifyListeners();
  }

  Future<void> addEvents(List<PlannerEvent> events) async {
    if (events.isEmpty) return;
    _allEvents.addAll(events);
    final first = events.first.date;
    _selectedDate = DateTime(first.year, first.month, first.day);
    await _persist();
    for (final event in events.where((e) => e.reminderEnabled)) {
      await _reminders.schedule(event);
    }
    notifyListeners();
  }

  Future<void> updateEvent(PlannerEvent event) async {
    final index = _allEvents.indexWhere((e) => e.id == event.id);
    if (index == -1) return;

    await _reminders.cancel(event.id);
    _allEvents[index] = event;
    _selectedDate = DateTime(event.date.year, event.date.month, event.date.day);
    await _persist();
    if (event.reminderEnabled) {
      await _reminders.schedule(event);
    }
    notifyListeners();
  }

  Future<void> removeEvent(String id) async {
    await _reminders.cancel(id);
    _allEvents.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  void _loadEvents() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      _allEvents
        ..clear()
        ..addAll(
          list.map((e) => PlannerEvent.fromJson(e as Map<String, dynamic>)),
        );
    } catch (_) {
      // Ignore corrupt storage
    }
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(_allEvents.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, encoded);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
