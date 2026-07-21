import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers/day_planner_provider.dart';
import '../../domain/entities/planner_event.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // ✅ Scroll to center after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    // Each date item width is 50 + 8 (margin) = 58
    // Total 30 items. Today is at index 7 (since we subtract 7 days at start)
    // To center index 7: (7 * 58) - (ScreenWidth / 2) + (58 / 2)
    const double itemWidth = 58.0;
    const int todayIndex = 7;
    final screenWidth = MediaQuery.of(context).size.width;
    final double offset = (todayIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DayPlannerProvider(),
      child: Consumer<DayPlannerProvider>(
        builder: (context, provider, _) {
          final isTodaySelected = provider.selectedDate.day == DateTime.now().day &&
              provider.selectedDate.month == DateTime.now().month &&
              provider.selectedDate.year == DateTime.now().year;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("My Day Planner",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton.icon(
                      onPressed: () => context.push('/plan-your-day'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Book",
                          style: TextStyle(
                              color: Color(0xFF00456A),
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildDateSelector(provider),
                const SizedBox(height: 15),
                if (provider.eventsForSelectedDay.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text(
                        isTodaySelected ? "No event planned today" : "No events planned for this day",
                        style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.eventsForSelectedDay.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final event = provider.eventsForSelectedDay[index];
                      return _buildPlannerItem(event);
                    },
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showAllDayEvents(context, provider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00456A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("See All Day Activities"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector(DayPlannerProvider provider) {
    final List<DateTime> dates = List.generate(30, (index) {
      return DateTime.now().subtract(const Duration(days: 7)).add(Duration(days: index));
    });

    return SizedBox(
      height: 75,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final date = dates[index];
          final now = DateTime.now();
          
          bool isToday = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
              
          bool isSelected = date.year == provider.selectedDate.year &&
              date.month == provider.selectedDate.month &&
              date.day == provider.selectedDate.day;

          Color bgColor = Colors.transparent;
          Color textColor = Colors.black87;

          if (isSelected) {
            bgColor = const Color(0xFF00456A);
            textColor = Colors.white;
          } else if (isToday) {
            bgColor = Colors.green;
            textColor = Colors.white;
          }

          return GestureDetector(
            onTap: () => provider.selectDate(date),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Text(
                    DateFormat('E').format(date).substring(0, 2),
                    style: TextStyle(
                      fontSize: 12, 
                      color: isToday && !isSelected ? Colors.green : Colors.grey,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: isToday && !isSelected 
                          ? Border.all(color: Colors.green, width: 1)
                          : null,
                    ),
                    child: Text(
                      "${date.day}",
                      style: TextStyle(
                        color: textColor, 
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlannerItem(PlannerEvent event) {
    IconData icon;
    Color color;
    switch (event.type) {
      case PlannerEventType.appointment:
        icon = Icons.medical_services_outlined;
        color = Colors.blue;
        break;
      case PlannerEventType.schedule:
        icon = Icons.timer_outlined;
        color = Colors.orange;
        break;
      case PlannerEventType.event:
        icon = Icons.event_note_outlined;
        color = Colors.purple;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(event.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(event.time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00456A))),
        ],
      ),
    );
  }

  void _showAllDayEvents(BuildContext context, DayPlannerProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 10),
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            Text("Activities for ${DateFormat('dd MMM yyyy').format(provider.selectedDate)}", 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: provider.eventsForSelectedDay.isEmpty 
                ? const Center(child: Text("No events planned for this day"))
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    controller: scrollController,
                    itemCount: provider.eventsForSelectedDay.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) => _buildPlannerItem(provider.eventsForSelectedDay[index]),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
