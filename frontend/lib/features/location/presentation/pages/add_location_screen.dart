import 'package:flutter/material.dart';
import '../../../../features/health_locker/presentation/widgets/custom_app_bar.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  String _addressType = "Home";

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HealthLockerAppBar(
        title: "Add Location",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Placeholder
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Select from Map", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Address Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInputField("House No. / Building Name", "Enter details", _houseNoController),
            _buildInputField("Area / Colony / Street", "Enter details", _areaController),
            _buildInputField("Landmark (Optional)", "Enter landmark", _landmarkController),
            Row(
              children: [
                Expanded(child: _buildInputField("Pincode", "6-digit code", _pincodeController, keyboardType: TextInputType.number)),
                const SizedBox(width: 15),
                Expanded(child: _buildInputField("City", "Enter city", _cityController)),
              ],
            ),
            _buildInputField("State", "Enter state", _stateController),
            const SizedBox(height: 10),
            const Text(
              "Save As",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildTypeChip("Home", Icons.home_outlined),
                const SizedBox(width: 10),
                _buildTypeChip("Work", Icons.work_outline),
                const SizedBox(width: 10),
                _buildTypeChip("Other", Icons.location_on_outlined),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "Save Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    bool isSelected = _addressType == label;
    const Color primaryColor = Color(0xFF00456A);

    return GestureDetector(
      onTap: () => setState(() => _addressType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
