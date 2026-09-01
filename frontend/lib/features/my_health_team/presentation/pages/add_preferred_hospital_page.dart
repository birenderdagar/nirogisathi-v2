import 'package:flutter/material.dart';

class AddPreferredHospitalPage extends StatefulWidget {
  const AddPreferredHospitalPage({super.key});

  @override
  State<AddPreferredHospitalPage> createState() => _AddPreferredHospitalPageState();
}

class _AddPreferredHospitalPageState extends State<AddPreferredHospitalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Hospital",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Hospital Icon with Edit Badge
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_hospital_outlined,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Hospital Name
              _buildLabel("Hospital Name"),
              _buildTextField(
                controller: _nameController,
                hintText: "Enter Hospital Name",
              ),
              const SizedBox(height: 20),

              // Address
              _buildLabel("Address"),
              _buildTextField(
                controller: _addressController,
                hintText: "Enter Address",
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Contact Person Name
              _buildLabel("Contact Person Name"),
              _buildTextField(
                controller: _contactPersonController,
                hintText: "Enter contact person Name if any",
              ),
              const SizedBox(height: 20),

              // Contact Person Number
              _buildLabel("Contact Person Number"),
              _buildTextField(
                controller: _contactNumberController,
                hintText: "Contact Person Number",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 50),

              // Submit Button
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle submission
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFB0C4DE)), // Light blue border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF00456A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
