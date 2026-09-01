import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nirogisathi/app/di/injection.dart';
import '../../domain/entities/health_locker_items.dart';
import '../providers/health_locker_provider.dart';
import '../widgets/health_locker_form_helpers.dart';

class AddDiagnosticScreen extends StatefulWidget {
  final DiagnosticRecord? existing;
  const AddDiagnosticScreen({super.key, this.existing});

  @override
  State<AddDiagnosticScreen> createState() => _AddDiagnosticScreenState();
}

class _AddDiagnosticScreenState extends State<AddDiagnosticScreen> {
  late final TextEditingController _hospitalNameController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _reportTypeController;
  late final TextEditingController _clinicalNotesController;
  late final TextEditingController _doctorNotesController;
  late final TextEditingController _remarksController;
  late List<String> _imagePaths;
  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _hospitalNameController = TextEditingController(text: e?.hospitalName ?? '');
    _dateController = TextEditingController(text: e?.date ?? '');
    _timeController = TextEditingController(text: e?.time ?? '');
    _reportTypeController = TextEditingController(text: e?.reportType ?? '');
    _clinicalNotesController = TextEditingController(text: e?.clinicalNotes ?? '');
    _doctorNotesController = TextEditingController(text: e?.doctorNotes ?? '');
    _remarksController = TextEditingController(text: e?.remarks ?? '');
    _imagePaths = List<String>.from(e?.imagePaths ?? const []);
  }

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _reportTypeController.dispose();
    _clinicalNotesController.dispose();
    _doctorNotesController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _hospitalNameController.text.trim();
    final date = _dateController.text.trim();
    if (name.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter hospital/clinic name and date')));
      return;
    }
    final locker = getIt<HealthLockerProvider>();
    if (_isEdit) {
      await locker.updateDiagnostic(widget.existing!.copyWith(
        hospitalName: name,
        date: date,
        time: _timeController.text.trim(),
        reportType: _reportTypeController.text.trim(),
        clinicalNotes: _clinicalNotesController.text.trim(),
        doctorNotes: _doctorNotesController.text.trim(),
        remarks: _remarksController.text.trim(),
        imagePaths: _imagePaths,
      ));
    } else {
      await locker.addDiagnostic(DiagnosticRecord(
        id: locker.newId(),
        hospitalName: name,
        date: date,
        time: _timeController.text.trim(),
        reportType: _reportTypeController.text.trim(),
        clinicalNotes: _clinicalNotesController.text.trim(),
        doctorNotes: _doctorNotesController.text.trim(),
        remarks: _remarksController.text.trim(),
        imagePaths: _imagePaths,
        createdAt: DateTime.now(),
      ));
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEdit ? 'Diagnostic updated' : 'Diagnostic added'), backgroundColor: const Color(0xFF00456A)));
    if (_isEdit) {
      context.go('/health-locker/diagnostics');
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
                child: Text(_isEdit ? 'Edit Diagnostic' : 'Add Diagnostic Report', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
            HealthLockerImageStrip(title: 'Photos & Scans', imagePaths: _imagePaths, onChanged: (p) => setState(() => _imagePaths = p)),
            const SizedBox(height: 20),
            HealthLockerField(label: 'Hospital/Clinic Name', hint: 'Enter name', controller: _hospitalNameController),
            HealthLockerField(label: 'Date', hint: 'DD/MM/YYYY', controller: _dateController, onTap: () => pickHealthLockerDate(context, _dateController)),
            HealthLockerField(label: 'Time', hint: '12:00 Pm', controller: _timeController, onTap: () => pickHealthLockerTime(context, _timeController)),
            HealthLockerField(label: 'Report Type', hint: 'e.g. X-Ray, MRI, CT Scan', controller: _reportTypeController),
            HealthLockerField(label: 'Clinical Notes', hint: 'Reason for diagnostic', controller: _clinicalNotesController),
            HealthLockerField(label: "Doctor's Notes", hint: 'Findings', controller: _doctorNotesController),
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
