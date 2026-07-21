import 'package:flutter/material.dart';
import '../../domain/entities/hospital.dart';

class HospitalDetailPage extends StatelessWidget {
  final Hospital hospital;

  const HospitalDetailPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF00456A);
    // Based on reference image, buttons are purple, but using primary for theme consistency if requested
    const Color accentColor = Color(0xFF9C27B0); 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          hospital.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Main Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F7FF), // Light blue background
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              hospital.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.business, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hospital.logoUrl.isNotEmpty)
                                Image.network(hospital.logoUrl, height: 25)
                              else
                                const Text("MAX Healthcare", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                              const SizedBox(height: 12),
                              Text(
                                hospital.name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hospital.address,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                              ),
                              const SizedBox(height: 16),
                              // Fixed Overflow Row
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return Wrap(
                                    spacing: 12,
                                    runSpacing: 10,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        hospital.type,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                      _iconInfo(Icons.king_bed_outlined, "${hospital.beds} Beds", Colors.orange),
                                      _iconInfo(Icons.person_outline, "60+ Doctors", Colors.orange),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
                              _detailRow("TPA and Insurance :", "Yes"),
                              _detailRow("Contact person Name :", "N/A"),
                              _detailRow("Contact person Number :", "N/A"),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _actionButton("Hospital Website", accentColor, () {}),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _actionButton("Looking for Admission", accentColor, () {}),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Section
                  _sectionTitle("About ${hospital.name}"),
                  _infoBox(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Max Super Speciality Hospital, Dwarka is a unit of Mahajan Hospitals Pvt. Ltd. located in the heart of South West Delhi, spread across 8.02 acres of serene, nature-friendly landscape. It is one of the first 5-star rated GRIHA compliant hospitals in Delhi NCR. With over 300 beds, it offers a comprehensive range of clinical specialities tailored to meet the diverse healthcare needs of patients. Renowned for distinguished clinical services, Max Hospital Dwarka encompasses expertise in Cardiac Sciences, Laparoscopic, Endoscopic & Bariatric Surgery, Renal Sciences, Neurosciences, Liver & Gastrointestinal Sciences, Cancer Care, Pulmonology, Internal Medicine, Robotic Surgery, Paediatrics, ENT and Cochlear Implant, Endocrinology & Diabetes, Obstetrics & Gynaecology, Infertility & IVF...",
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                          child: const Text("Read More", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Specialities Section
                  _sectionTitle("Specialities"),
                  _infoBox(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bulletItem("Joint Replacement."),
                        _bulletItem("Dialysis & Kidney transplant."),
                        _bulletItem("Brain and spine."),
                        _bulletItem("Surgical Oncology."),
                        _bulletItem("Hematology & Bone marrow transplant."),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Departments Section
                  _sectionTitle("Departments"),
                  _infoBox(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bulletItem("Outpatient(OPD)"),
                        _bulletItem("Inpatient(Wards)"),
                        _bulletItem("Casualty(Emergency)"),
                        _bulletItem("Intensive Critical Care(ICU)"),
                        _bulletItem("General Surgery(OT)"),
                        _bulletItem("Anaesthetics"),
                        _bulletItem("Major Surgery"),
                        _bulletItem("General Medicine"),
                        _bulletItem("Ears, Nose and Throat"),
                        _bulletItem("Ophthalmology (EYES)"),
                        _bulletItem("Orthopedics"),
                        _bulletItem("Dentistry(Dental)"),
                        _bulletItem("Dermatology(Skin)"),
                        _bulletItem("Pulmonary"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _infoBox(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _iconInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Colors.black),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
