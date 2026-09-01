import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirogisathi/app/di/injection.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/health_locker_form_helpers.dart';

class AddPrescriptionScreen extends StatefulWidget {
  final PrescriptionRecord? existing;

  const AddPrescriptionScreen({super.key, this.existing});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  late final TextEditingController _doctorNameController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _purposeController;
  late final TextEditingController _clinicalNotesController;
  late final TextEditingController _investigationController;
  late final TextEditingController _remarksController;
  late List<String> _imagePaths;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _doctorNameController = TextEditingController(text: e?.doctorName ?? '');
    _dateController = TextEditingController(text: e?.date ?? '');
    _timeController = TextEditingController(text: e?.time ?? '');
    _purposeController = TextEditingController(text: e?.purpose ?? '');
    _clinicalNotesController = TextEditingController(text: e?.clinicalNotes ?? '');
    _investigationController = TextEditingController(text: e?.investigation ?? '');
    _remarksController = TextEditingController(text: e?.remarks ?? '');
    _imagePaths = List<String>.from(e?.imagePaths ?? const []);
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _purposeController.dispose();
    _clinicalNotesController.dispose();
    _investigationController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final doctorName = _doctorNameController.text.trim();
    final date = _dateController.text.trim();

    if (doctorName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter doctor name')),
      );
      return;
    }
    if (date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter date')),
      );
      return;
    }

    final locker = getIt<HealthLockerProvider>();
    if (_isEdit) {
      await locker.updatePrescription(
        widget.existing!.copyWith(
          doctorName: doctorName,
          date: date,
          time: _timeController.text.trim(),
          purpose: _purposeController.text.trim(),
          clinicalNotes: _clinicalNotesController.text.trim(),
          investigation: _investigationController.text.trim(),
          remarks: _remarksController.text.trim(),
          imagePaths: _imagePaths,
        ),
      );
    } else {
      await locker.addPrescription(
        PrescriptionRecord(
          id: locker.newId(),
          doctorName: doctorName,
          date: date,
          time: _timeController.text.trim(),
          purpose: _purposeController.text.trim(),
          clinicalNotes: _clinicalNotesController.text.trim(),
          investigation: _investigationController.text.trim(),
          remarks: _remarksController.text.trim(),
          imagePaths: _imagePaths,
          createdAt: DateTime.now(),
        ),
      );
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEdit ? 'Prescription updated' : 'Prescription added successfully'),
        backgroundColor: const Color(0xFF00456A),
      ),
    );
    if (_isEdit) {
      context.go('/health-locker/prescriptions');
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00456A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chevron_left, color: primaryColor, size: 28),
                ),
              ),
              Expanded(
                child: Text(
                  _isEdit ? 'Edit Prescription' : 'Add Prescription',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 45),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HealthLockerImageStrip(
              imagePaths: _imagePaths,
              onChanged: (paths) => setState(() => _imagePaths = paths),
            ),
            const SizedBox(height: 20),
            HealthLockerField(label: 'Doctor Name', hint: 'Enter Doctor name', controller: _doctorNameController),
            HealthLockerField(
              label: 'Date',
              hint: 'DD/MM/YYYY',
              controller: _dateController,
              onTap: () => pickHealthLockerDate(context, _dateController),
            ),
            HealthLockerField(
              label: 'Time',
              hint: '12:00 Pm',
              controller: _timeController,
              onTap: () => pickHealthLockerTime(context, _timeController),
            ),
            HealthLockerField(label: 'Purpose', hint: 'Purpose', controller: _purposeController),
            HealthLockerField(label: 'Clinical Notes', hint: 'Clinical notes', controller: _clinicalNotesController),
            HealthLockerField(label: 'Investigation advised', hint: 'Investigation', controller: _investigationController),
            HealthLockerField(
              label: 'Remarks',
              hint: 'Note down your remarks',
              controller: _remarksController,
              isMultiline: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  _isEdit ? 'Update' : 'Add',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
