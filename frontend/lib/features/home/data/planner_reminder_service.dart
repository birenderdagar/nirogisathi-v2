import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/entities/planner_event.dart';

class PlannerReminderService {
  PlannerReminderService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    // App is India-focused; keeps reminders aligned with local IST.
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    _initialized = true;
  }

  int notificationIdFor(String eventId) => eventId.hashCode & 0x7fffffff;

  Future<void> schedule(PlannerEvent event) async {
    if (!event.reminderEnabled) {
      await cancel(event.id);
      return;
    }

    await init();

    final when = _scheduledDateTime(event);
    if (when == null || when.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'day_planner_reminders',
      'Day Planner Reminders',
      channelDescription: 'Alarm-style reminders for planned activities',
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    await _plugin.zonedSchedule(
      id: notificationIdFor(event.id),
      title: event.title,
      body: event.description.isEmpty
          ? 'Reminder for ${event.time}'
          : event.description,
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: event.id,
    );
  }

  Future<void> cancel(String eventId) async {
    await init();
    await _plugin.cancel(id: notificationIdFor(eventId));
  }

  Future<void> rescheduleAll(Iterable<PlannerEvent> events) async {
    await init();
    for (final event in events) {
      if (event.reminderEnabled) {
        await schedule(event);
      }
    }
  }

  tz.TZDateTime? _scheduledDateTime(PlannerEvent event) {
    try {
      final parsedTime = DateFormat('hh:mm a').parse(event.time);
      return tz.TZDateTime(
        tz.local,
        event.date.year,
        event.date.month,
        event.date.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      debugPrint('Failed to parse reminder time: ${event.time} ($e)');
      return null;
    }
  }
}
