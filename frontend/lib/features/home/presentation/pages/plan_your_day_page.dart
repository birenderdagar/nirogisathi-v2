import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:nirogisathi/features/Splash/presentation/provider/splash_provider.dart';
import 'package:nirogisathi/core/enums/app_state.dart';
import '../../domain/entities/planner_event.dart';
import '../providers/day_planner_provider.dart';

class PlanYourDayPage extends StatefulWidget {
  final PlannerEvent? editEvent;

  const PlanYourDayPage({super.key, this.editEvent});

  @override
  State<PlanYourDayPage> createState() => _PlanYourDayPageState();
}

class _PlanYourDayPageState extends State<PlanYourDayPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String selectedCategory = 'Notes';
  bool isRepeatOn = false;
  bool _notificationEnabled = false;
  String selectedRepeat = 'oneday';
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool get _isEditing => widget.editEvent != null;

  static const Color primaryColor = Color(0xFF00456A);
  static const Color orangeColor = Color(0xFFFBB03B);
  static const Color switchBlue = Color(0xFF2196F3);

  @override
  void initState() {
    super.initState();
    final event = widget.editEvent;
    if (event != null) {
      _titleController.text = event.title;
      _descriptionController.text = event.description;
      _selectedDate = DateTime(event.date.year, event.date.month, event.date.day);
      _focusedMonth = DateTime(event.date.year, event.date.month);
      _notificationEnabled = event.reminderEnabled;
      selectedCategory = switch (event.type) {
        PlannerEventType.appointment => 'Appointment',
        PlannerEventType.schedule => 'Task',
        PlannerEventType.event => 'Notes',
      };
      try {
        final parsed = DateFormat('hh:mm a').parse(event.time);
        _selectedTime = TimeOfDay(hour: parsed.hour, minute: parsed.minute);
      } catch (_) {}
    }
  }

  Future<void> _toggleNotification() async {
    final enabling = !_notificationEnabled;
    setState(() => _notificationEnabled = enabling);

    if (enabling) {
      HapticFeedback.lightImpact();
      try {
        await FlutterRingtonePlayer().playNotification(
          volume: 1.0,
          looping: false,
          asAlarm: false,
        );
      } catch (_) {
        await SystemSound.play(SystemSoundType.alert);
      }
    } else {
      try {
        await FlutterRingtonePlayer().stop();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _peopleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String get _userName {
    final splash = context.read<SplashProvider>();
    String name = splash.user?.name ?? 'User';
    if (name == 'User' && splash.state is RoleSelectionRequired) {
      name = (splash.state as RoleSelectionRequired).userName;
    } else if (name == 'User' && splash.state is AuthenticatedWithRole) {
      name = (splash.state as AuthenticatedWithRole).userName;
    }
    return name;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  PlannerEventType _categoryToType(String category) {
    switch (category) {
      case 'Appointment':
        return PlannerEventType.appointment;
      case 'Task':
        return PlannerEventType.schedule;
      default:
        return PlannerEventType.event;
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  List<DateTime> _datesToSave() {
    final base = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    if (!isRepeatOn) return [base];

    switch (selectedRepeat) {
      case 'Everday':
        return List.generate(7, (i) => base.add(Duration(days: i)));
      case 'Every Month':
        return [
          base,
          DateTime(base.year, base.month + 1, base.day),
          DateTime(base.year, base.month + 2, base.day),
        ];
      case 'selected date':
      case 'oneday':
      default:
        return [base];
    }
  }

  Future<void> _saveActivity() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a title')),
      );
      return;
    }

    final descriptionParts = <String>[];
    final desc = _descriptionController.text.trim();
    if (desc.isNotEmpty) descriptionParts.add(desc);
    final people = _peopleController.text.trim();
    if (people.isNotEmpty) descriptionParts.add('With: $people');
    final location = _locationController.text.trim();
    if (location.isNotEmpty) descriptionParts.add(location);

    final timeLabel = _formatTime(_selectedTime);
    final type = _categoryToType(selectedCategory);
    final description = descriptionParts.isEmpty
        ? selectedCategory
        : descriptionParts.join(' • ');
    final provider = context.read<DayPlannerProvider>();

    if (_isEditing) {
      final updated = widget.editEvent!.copyWith(
        title: title,
        description: description,
        date: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
        time: timeLabel,
        type: type,
        reminderEnabled: _notificationEnabled,
      );
      await provider.updateEvent(updated);
    } else {
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final events = _datesToSave()
          .asMap()
          .entries
          .map(
            (entry) => PlannerEvent(
              id: '${nowMs}_${entry.key}',
              title: title,
              description: description,
              date: entry.value,
              time: timeLabel,
              type: type,
              reminderEnabled: _notificationEnabled,
            ),
          )
          .toList();
      await provider.addEvents(events);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _notificationEnabled
              ? (_isEditing
                  ? 'Activity updated. Reminder set for $timeLabel'
                  : 'Activity saved. Reminder set for $timeLabel')
              : (_isEditing
                  ? 'Activity updated'
                  : 'Activity saved to My Day Planner'),
        ),
        backgroundColor: primaryColor,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    const noteBgColor = Color(0xFFF3E5F5);
    const noteTextColor = Color(0xFFAB47BC);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Hi, $_userName',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  _isEditing ? 'Edit Activity' : 'Plan Your Day',
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildCalendarCard(),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: primaryColor),
                      const SizedBox(width: 10),
                      const Text('Time', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      Text(
                        _formatTime(_selectedTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(fontSize: 18, color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: 'Add Title',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _toggleNotification,
                    tooltip: _notificationEnabled
                        ? 'Notification on'
                        : 'Notification off',
                    icon: Icon(
                      _notificationEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_none_outlined,
                      color: _notificationEnabled ? switchBlue : Colors.grey,
                      size: 34,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  _buildCategoryChip('Notes', noteBgColor, noteTextColor),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Task', const Color(0xFFFFF3E0), const Color(0xFFEF6C00)),
                  const SizedBox(width: 12),
                  _buildCategoryChip('Appointment', const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                ],
              ),
              if (!_isEditing) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.black54, size: 24),
                    const SizedBox(width: 10),
                    const Text('Repeat', style: TextStyle(fontSize: 17, color: Colors.black87)),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.9,
                      child: Switch(
                        value: isRepeatOn,
                        onChanged: (val) => setState(() => isRepeatOn = val),
                        activeThumbColor: Colors.white,
                        activeTrackColor: switchBlue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade400,
                        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return switchBlue;
                          }
                          return Colors.grey.shade400;
                        }),
                      ),
                    )
                  ],
                ),
                if (isRepeatOn)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _buildRepeatTab('oneday'),
                        _buildRepeatTab('Everday'),
                        _buildRepeatTab('Every Month'),
                        _buildRepeatTab('selected date'),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 20),
              _buildInfoInput('Add People:', 'Assign to', Icons.person_outline, _peopleController),
              _buildInfoInput('Add Location:', 'Location', Icons.location_on_outlined, _locationController),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Add description / notes',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _saveActivity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(180, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: Text(
                      _isEditing ? 'Update' : 'Save',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy').format(_focusedMonth),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildQuickTab('Today', () {
                  final now = DateTime.now();
                  setState(() {
                    _selectedDate = DateTime(now.year, now.month, now.day);
                    _focusedMonth = DateTime(now.year, now.month);
                  });
                }),
                const SizedBox(width: 8),
                _buildQuickTab('Last 8 days', () {
                  final target = DateTime.now().subtract(const Duration(days: 7));
                  setState(() {
                    _selectedDate = DateTime(target.year, target.month, target.day);
                    _focusedMonth = DateTime(target.year, target.month);
                  });
                }),
                const SizedBox(width: 8),
                _buildQuickTab('Last month', () {
                  final now = DateTime.now();
                  final target = DateTime(now.year, now.month - 1, now.day);
                  setState(() {
                    _selectedDate = DateTime(target.year, target.month, target.day);
                    _focusedMonth = DateTime(target.year, target.month);
                  });
                }),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 0.8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                              .map(
                                (d) => Text(
                                  d,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      _buildCalendarGrid(),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 220,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(flex: 1, child: _buildMonthSidebar()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTab(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday % 7; // Sunday = 0
    final totalCells = ((startWeekday + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - startWeekday + 1;
        final isCurrentMonth = dayNumber >= 1 && dayNumber <= daysInMonth;

        DateTime cellDate;
        if (isCurrentMonth) {
          cellDate = DateTime(_focusedMonth.year, _focusedMonth.month, dayNumber);
        } else if (dayNumber < 1) {
          final prevMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 0);
          cellDate = DateTime(prevMonth.year, prevMonth.month, prevMonth.day + dayNumber);
        } else {
          cellDate = DateTime(_focusedMonth.year, _focusedMonth.month + 1, dayNumber - daysInMonth);
        }

        final isSelected = cellDate.year == _selectedDate.year &&
            cellDate.month == _selectedDate.month &&
            cellDate.day == _selectedDate.day;
        final isToday = cellDate.year == DateTime.now().year &&
            cellDate.month == DateTime.now().month &&
            cellDate.day == DateTime.now().day;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = DateTime(cellDate.year, cellDate.month, cellDate.day);
              _focusedMonth = DateTime(cellDate.year, cellDate.month);
            });
          },
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected
                    ? orangeColor
                    : (isToday ? primaryColor.withValues(alpha: 0.15) : Colors.transparent),
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: primaryColor, width: 1)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                '${cellDate.day}',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isCurrentMonth ? Colors.black87 : Colors.grey.shade300),
                  fontSize: 13,
                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthSidebar() {
    final months = List.generate(5, (i) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month - 2 + i);
      return date;
    });

    return Column(
      children: months.map((monthDate) {
        final isSelected =
            monthDate.year == _focusedMonth.year && monthDate.month == _focusedMonth.month;
        return GestureDetector(
          onTap: () {
            setState(() {
              _focusedMonth = DateTime(monthDate.year, monthDate.month);
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              DateFormat('MMM').format(monthDate),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey.shade400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChip(String label, Color bgColor, Color textColor) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: textColor.withValues(alpha: 0.2)) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? textColor : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatTab(String label) {
    final isSelected = selectedRepeat == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRepeat = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: isSelected ? const Border(bottom: BorderSide(color: Colors.black, width: 2)) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.black : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoInput(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 15)),
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 15),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
