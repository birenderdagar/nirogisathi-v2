import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlanYourDayPage extends StatefulWidget {
  const PlanYourDayPage({super.key});

  @override
  State<PlanYourDayPage> createState() => _PlanYourDayPageState();
}

class _PlanYourDayPageState extends State<PlanYourDayPage> {
  String selectedCategory = "Notes";
  bool isRepeatOn = false;
  String selectedRepeat = "Everday";

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);
    const Color orangeColor = Color(0xFFFBB03B);
    const Color noteBgColor = Color(0xFFF3E5F5);
    const Color noteTextColor = Color(0xFFAB47BC);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Hi, Birender Dagar",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  "Plan Your Day",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              
              // Calendar Card
              _buildCalendarCard(orangeColor),
              
              const SizedBox(height: 25),
              
              // Add Title Section
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: "Add Title",
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
                  Icon(Icons.notifications_none_outlined, color: primaryColor, size: 38),
                ],
              ),
              
              const SizedBox(height: 25),
              
              // Category Chips
              Row(
                children: [
                  _buildCategoryChip("Notes", noteBgColor, noteTextColor),
                  const SizedBox(width: 12),
                  _buildCategoryChip("Task", Colors.grey.shade200, Colors.black54),
                  const SizedBox(width: 12),
                  _buildCategoryChip("Appointment", Colors.grey.shade200, Colors.black54),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Repeat Section
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.black54, size: 24),
                  const SizedBox(width: 10),
                  const Text("Repeat", style: TextStyle(fontSize: 17, color: Colors.black87)),
                  const Spacer(),
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: isRepeatOn,
                      onChanged: (val) => setState(() => isRepeatOn = val),
                      activeColor: Colors.white,
                      activeTrackColor: Colors.grey.shade300,
                    ),
                  )
                ],
              ),
              
              // Repeat Tabs (Segmented Control style)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildRepeatTab("oneday"),
                    _buildRepeatTab("Everday"),
                    _buildRepeatTab("Every Month"),
                    _buildRepeatTab("selected date"),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Input Fields (Add People, Add Location, Add Attachment)
              _buildInfoInput("Add People:", "Assign to", Icons.person_outline),
              _buildInfoInput("Add Location:", "Location", Icons.location_on_outlined),
              
              // Attachment Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, color: Colors.black, size: 22),
                    const SizedBox(width: 10),
                    const Text("Add attachment:", style: TextStyle(color: Colors.black, fontSize: 15)),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, color: Colors.grey, size: 30),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Description Box
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Bottom Buttons
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
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(180, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 44), // Alignment balance
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard(Color highlightColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCalHeaderTab("Today"),
                _buildCalHeaderTab("Last 8 days"),
                _buildCalHeaderTab("Last month"),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 24),
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
                          children: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                              .map((d) => Text(d, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)))
                              .toList(),
                        ),
                      ),
                      _buildCalendarGrid(highlightColor),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 190,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  flex: 1,
                  child: _buildMonthSidebar(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCalHeaderTab(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCalendarGrid(Color highlightColor) {
    final List<String> days = [
      "27", "28", "1", "2", "3", "4", "5",
      "6", "7", "8", "9", "10", "11", "12",
      "13", "14", "15", "16", "17", "18", "19",
      "20", "21", "22", "23", "24", "25", "26",
      "27", "28", "29", "30", "31", "1", "2"
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        String day = days[index];
        bool isOtherMonth = (index < 2 || index > 32);
        bool isTarget = day == "14" && index == 15;

        return Center(
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isTarget ? highlightColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                color: isTarget ? Colors.white : (isOtherMonth ? Colors.grey.shade300 : Colors.black87),
                fontSize: 13,
                fontWeight: isTarget ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthSidebar() {
    final months = ["Jun", "Apr", "Mar", "Feb", "Dec"];
    return Column(
      children: months.map((m) {
        bool isSelected = m == "Mar";
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            m,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey.shade400,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChip(String label, Color bgColor, Color textColor) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: textColor.withOpacity(0.2)) : null,
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
    bool isSelected = selectedRepeat == label;
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

  Widget _buildInfoInput(String label, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
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
