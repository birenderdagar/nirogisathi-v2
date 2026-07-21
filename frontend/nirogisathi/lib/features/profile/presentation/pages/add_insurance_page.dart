import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddInsurancePage extends StatefulWidget {
  const AddInsurancePage({super.key});

  @override
  State<AddInsurancePage> createState() => _AddInsurancePageState();
}

class _AddInsurancePageState extends State<AddInsurancePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final policyController = TextEditingController();
  final providerController = TextEditingController();
  final amountController = TextEditingController();
  final expiryController = TextEditingController();
  final benefitsController = TextEditingController();

  DateTime? selectedDate;

  @override
  void dispose() {
    nameController.dispose();
    policyController.dispose();
    providerController.dispose();
    amountController.dispose();
    expiryController.dispose();
    benefitsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00456A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        expiryController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF00456A);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Insurance"),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Policy Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryBlue),
              ),
              const SizedBox(height: 20),
              _buildTextField(providerController, "Insurance Provider", Icons.business),
              const SizedBox(height: 16),
              _buildTextField(nameController, "Plan Name", Icons.assignment),
              const SizedBox(height: 16),
              _buildTextField(policyController, "Policy Number", Icons.numbers),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      amountController, 
                      "Coverage Amount", 
                      Icons.currency_rupee, 
                      keyboardType: TextInputType.number
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: expiryController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: "Expiry Date",
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              _buildTextField(
                benefitsController, 
                "Key Benefits (comma separated)", 
                Icons.list,
                maxLines: 3
              ),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Logic to save insurance would go here
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Insurance added successfully!"),
                          backgroundColor: primaryBlue,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: const Text("Save Insurance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {TextInputType keyboardType = TextInputType.text, int maxLines = 1}
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        alignLabelWithHint: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "Required field" : null,
    );
  }
}
