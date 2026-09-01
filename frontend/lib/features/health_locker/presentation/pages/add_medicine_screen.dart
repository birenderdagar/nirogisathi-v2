import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirogisathi/app/di/injection.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/health_locker_form_helpers.dart';

class AddMedicineScreen extends StatefulWidget {
  final MedicineRecord? existing;
  const AddMedicineScreen({super.key, this.existing});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  late final TextEditingController _medicineNameController;
  late final TextEditingController _doseController;
  late final TextEditingController _doctorNameController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _purposeController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _remarksController;
  late List<String> _imagePaths;
  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _medicineNameController = TextEditingController(text: e?.name ?? '');
    _doseController = TextEditingController(text: e?.dose ?? '');
    _doctorNameController = TextEditingController(text: e?.doctorName ?? '');
    _dateController = TextEditingController(text: e?.date ?? '');
    _timeController = TextEditingController(text: e?.time ?? '');
    _purposeController = TextEditingController(text: e?.purpose ?? '');
    _instructionsController = TextEditingController(text: e?.instructions ?? '');
    _remarksController = TextEditingController(text: e?.remarks ?? '');
    _imagePaths = List<String>.from(e?.imagePaths ?? const []);
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _doseController.dispose();
    _doctorNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _purposeController.dispose();
    _instructionsController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _medicineNameController.text.trim();
    final date = _dateController.text.trim();
    if (name.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter medicine name and date')));
      return;
    }
    final locker = getIt<HealthLockerProvider>();
    if (_isEdit) {
      await locker.updateMedicine(widget.existing!.copyWith(
        name: name,
        dose: _doseController.text.trim(),
        doctorName: _doctorNameController.text.trim(),
        date: date,
        time: _timeController.text.trim(),
        purpose: _purposeController.text.trim(),
        instructions: _instructionsController.text.trim(),
        remarks: _remarksController.text.trim(),
        imagePaths: _imagePaths,
      ));
    } else {
      await locker.addMedicine(MedicineRecord(
        id: locker.newId(),
        name: name,
        dose: _doseController.text.trim(),
        doctorName: _doctorNameController.text.trim(),
        date: date,
        time: _timeController.text.trim(),
        purpose: _purposeController.text.trim(),
        instructions: _instructionsController.text.trim(),
        remarks: _remarksController.text.trim(),
        imagePaths: _imagePaths,
        createdAt: DateTime.now(),
      ));
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEdit ? 'Medicine updated' : 'Medicine added'), backgroundColor: const Color(0xFF00456A)));
    if (_isEdit) {
      context.go('/health-locker/medicines');
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00456A);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HealthLockerAppBar(title: _isEdit ? 'Edit Medicine' : 'Add Medicine'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            HealthLockerImageStrip(title: 'Medicine Photo', imagePaths: _imagePaths, onChanged: (p) => setState(() => _imagePaths = p)),
            const SizedBox(height: 20),
            HealthLockerField(label: 'Medicine Name', hint: 'Enter medicine name', controller: _medicineNameController),
            HealthLockerField(label: 'Dose', hint: 'e.g. 1 tablet, 5ml', controller: _doseController),
            HealthLockerField(label: 'Doctor Name', hint: 'Enter doctor name', controller: _doctorNameController),
            HealthLockerField(label: 'Date', hint: 'DD/MM/YYYY', controller: _dateController, onTap: () => pickHealthLockerDate(context, _dateController)),
            HealthLockerField(label: 'Time', hint: '12:00 Pm', controller: _timeController, onTap: () => pickHealthLockerTime(context, _timeController)),
            HealthLockerField(label: 'Purpose', hint: 'e.g. Fever, Pain', controller: _purposeController),
            HealthLockerField(label: 'Instructions', hint: 'e.g. After meal', controller: _instructionsController),
            HealthLockerField(label: 'Remarks', hint: 'Remarks', controller: _remarksController, isMultiline: true),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text(_isEdit ? 'Update Medicine' : 'Add Medicine', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
