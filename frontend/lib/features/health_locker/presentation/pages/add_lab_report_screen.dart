import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirogisathi/app/di/injection.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/health_locker_form_helpers.dart';

class AddLabReportScreen extends StatefulWidget {
  final LabReportRecord? existing;
  const AddLabReportScreen({super.key, this.existing});

  @override
  State<AddLabReportScreen> createState() => _AddLabReportScreenState();
}

class _AddLabReportScreenState extends State<AddLabReportScreen> {
  late final TextEditingController _labNameController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _reportTypeController;
  late final TextEditingController _clinicalNotesController;
  late final TextEditingController _observationsController;
  late final TextEditingController _remarksController;
  late List<String> _imagePaths;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _labNameController = TextEditingController(text: e?.labName ?? '');
    _dateController = TextEditingController(text: e?.date ?? '');
    _timeController = TextEditingController(text: e?.time ?? '');
    _reportTypeController = TextEditingController(text: e?.reportType ?? '');
    _clinicalNotesController = TextEditingController(text: e?.clinicalNotes ?? '');
    _observationsController = TextEditingController(text: e?.observations ?? '');
    _remarksController = TextEditingController(text: e?.remarks ?? '');
    _imagePaths = List<String>.from(e?.imagePaths ?? const []);
  }

  @override
  void dispose() {
    _labNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _reportTypeController.dispose();
    _clinicalNotesController.dispose();
    _observationsController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final labName = _labNameController.text.trim();
    final date = _dateController.text.trim();
    if (labName.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter lab name and date')),
      );
      return;
    }

    final locker = getIt<HealthLockerProvider>();
    if (_isEdit) {
      await locker.updateLabReport(widget.existing!.copyWith(
        labName: labName,
        date: date,
        time: _timeController.text.trim(),
        reportType: _reportTypeController.text.trim(),
        clinicalNotes: _clinicalNotesController.text.trim(),
        observations: _observationsController.text.trim(),
        remarks: _remarksController.text.trim(),
        imagePaths: _imagePaths,
      ));
    } else {
      await locker.addLabReport(LabReportRecord(
        id: locker.newId(),
        labName: labName,
        date: date,
        time: _timeController.text.trim(),
        reportType: _reportTypeController.text.trim(),
        clinicalNotes: _clinicalNotesController.text.trim(),
        observations: _observationsController.text.trim(),
        remarks: _remarksController.text.trim(),
        imagePaths: _imagePaths,
        createdAt: DateTime.now(),
      ));
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEdit ? 'Lab report updated' : 'Lab report added'), backgroundColor: const Color(0xFF00456A)),
    );
    if (_isEdit) {
      context.go('/health-locker/lab-reports');
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
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.chevron_left, color: primaryColor, size: 28),
                ),
              ),
              Expanded(
                child: Text(
                  _isEdit ? 'Edit Lab Report' : 'Add Lab Report',
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
          children: [
            HealthLockerImageStrip(
              title: 'Report Photos & PDF',
              imagePaths: _imagePaths,
              onChanged: (p) => setState(() => _imagePaths = p),
            ),
            const SizedBox(height: 20),
            HealthLockerField(label: 'Lab Name', hint: 'Enter lab name', controller: _labNameController),
            HealthLockerField(label: 'Date', hint: 'DD/MM/YYYY', controller: _dateController, onTap: () => pickHealthLockerDate(context, _dateController)),
            HealthLockerField(label: 'Time', hint: '12:00 Pm', controller: _timeController, onTap: () => pickHealthLockerTime(context, _timeController)),
            HealthLockerField(label: 'Report Type', hint: 'e.g. CBC, LFT', controller: _reportTypeController),
            HealthLockerField(label: 'Clinical Notes', hint: 'Clinical notes', controller: _clinicalNotesController),
            HealthLockerField(label: 'Observations', hint: 'Observations', controller: _observationsController),
            HealthLockerField(label: 'Remarks', hint: 'Remarks', controller: _remarksController, isMultiline: true),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text(_isEdit ? 'Update' : 'Add', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
