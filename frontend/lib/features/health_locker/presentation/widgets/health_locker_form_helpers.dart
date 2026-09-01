import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HealthLockerImageStrip extends StatelessWidget {
  final List<String> imagePaths;
  final ValueChanged<List<String>> onChanged;
  final String title;

  const HealthLockerImageStrip({
    super.key,
    required this.imagePaths,
    required this.onChanged,
    this.title = "Document's & Photo's",
  });

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 85);
    if (file == null) return;
    onChanged([...imagePaths, file.path]);
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Add Document or Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pick(context, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pick(context, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00456A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < imagePaths.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imagePaths[i]),
                          width: 70,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 70,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -6,
                        right: -6,
                        child: GestureDetector(
                          onTap: () {
                            final next = [...imagePaths]..removeAt(i);
                            onChanged(next);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              GestureDetector(
                onTap: () => _showSheet(context),
                child: Container(
                  width: 70,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.add, color: primaryColor, size: 30),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HealthLockerField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isMultiline;
  final VoidCallback? onTap;
  final bool readOnly;

  const HealthLockerField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isMultiline = false,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: isMultiline ? 3 : 1,
          readOnly: readOnly || onTap != null,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            suffixIcon: onTap != null ? const Icon(Icons.calendar_today, size: 18) : null,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

Future<void> pickHealthLockerDate(
  BuildContext context,
  TextEditingController controller,
) async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(2000),
    lastDate: DateTime(now.year + 5),
  );
  if (picked == null) return;
  controller.text =
      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
}

Future<void> pickHealthLockerTime(
  BuildContext context,
  TextEditingController controller,
) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked == null || !context.mounted) return;
  controller.text = picked.format(context);
}

Widget healthLockerThumb(String? path, {double width = 60, double height = 80}) {
  if (path == null || path.isEmpty) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    ),
  );
}
