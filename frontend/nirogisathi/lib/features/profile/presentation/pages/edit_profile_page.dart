import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nirogisathi/app/di/injection.dart';
import 'package:nirogisathi/core/storage/local_storage_service.dart';
import 'package:nirogisathi/core/utils/age_calculator.dart';
import 'package:nirogisathi/features/Splash/presentation/provider/splash_provider.dart';
import 'package:nirogisathi/features/auth/presentation/provider/auth_provider.dart';
import 'package:nirogisathi/features/auth/presentation/widgets/auth_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  
  String? selectedGender;
  String? selectedBloodGroup;
  String currentUserName = "";
  String userMobile = "";
  File? _imageFile;
  String? _selectedAvatar;
  String calculatedAge = "24";

  final List<String> _bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
  final List<String> _avatars = [
    'https://cdn-icons-png.flaticon.com/512/4140/4140037.png',
    'https://cdn-icons-png.flaticon.com/512/4140/4140047.png',
    'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
    'https://cdn-icons-png.flaticon.com/512/4140/4140051.png',
  ];
  
  @override
  void initState() {
    super.initState();

    // ✅ Initialize controllers empty
    nameController = TextEditingController();
    emailController = TextEditingController();
    dobController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();

    // ✅ Fetch latest profile from backend every time page opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      // Refresh latest user data from API
      await context.read<SplashProvider>().refresh();

      final user = context.read<SplashProvider>().user;

      if (user == null) return;

      // ✅ Format DOB properly
      String displayDob = "";

      if (user.dob != null &&
          user.dob!.isNotEmpty &&
          user.dob != 'N/A') {
        try {
          DateTime parsedDate;

          if (user.dob!.contains('-') &&
              user.dob!.indexOf('-') == 4) {
            // yyyy-MM-dd
            parsedDate = DateTime.parse(user.dob!);
          } else {
            // dd-MM-yyyy
            parsedDate =
                DateFormat("dd-MM-yyyy").parse(user.dob!);
          }

          displayDob =
              DateFormat("dd-MM-yyyy").format(parsedDate);

        } catch (e) {
          displayDob = user.dob!;
        }
      }

      // ✅ Update UI with latest backend data
      setState(() {

        currentUserName = user.name ?? "";
        userMobile = user.mobile ?? "";

        nameController.text = user.name ?? "";
        emailController.text = user.email ?? "";
        dobController.text = displayDob;
        weightController.text = user.weight ?? "";
        heightController.text = user.height ?? "";

        selectedGender = user.gender ?? "Male";
        selectedBloodGroup = user.bloodGroup ?? "O+";

        _selectedAvatar = user.photoUrl;

        // ✅ Recalculate age
        if (displayDob.isNotEmpty) {
          _calculateAge(displayDob);
        }
      });
    });

    // ✅ Live update name on top
    nameController.addListener(() {
      setState(() {
        currentUserName = nameController.text;
      });
    });
  }

  void _calculateAge(String dob) {
    setState(() {
      calculatedAge = calculateAge(dob);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        dobController.text = formattedDate;
        _calculateAge(formattedDate);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _selectedAvatar = null;
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Change Profile Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text('Choose Avatar'),
              onTap: () {
                Navigator.pop(context);
                _showAvatarPicker(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          children: [
            const Text("Select an Avatar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemCount: _avatars.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatar = _avatars[index];
                      _imageFile = null;
                    });
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_avatars[index]),
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile(AuthProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final uid = getIt<LocalStorageService>().getUid();
    if (uid == null) return;

    /*
    |--------------------------------------------------------------------------
    | FORMAT DOB FOR MYSQL (yyyy-MM-dd)
    |--------------------------------------------------------------------------
    */
    String formattedDob = dobController.text.trim();
    if (formattedDob.isNotEmpty && formattedDob != 'N/A') {
      try {
        DateTime date;
        // Detect if format is already yyyy-MM-dd
        if (formattedDob.contains('-') && formattedDob.indexOf('-') == 4) {
           date = DateTime.parse(formattedDob);
        } else {
           // Standard display format
           date = DateFormat('dd-MM-yyyy').parse(formattedDob);
        }
        formattedDob = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        debugPrint("❌ DATE PARSE ERROR: $e");
        // Fallback to whatever is in the controller if parsing fails
      }
    }

    final data = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'dob': formattedDob,
      'age': calculatedAge,
      'gender': selectedGender,
      'blood_group': selectedBloodGroup,
      'profile_image': _selectedAvatar ?? (_imageFile?.path),
    };

    // Only add weight/height if not empty to prevent MySQL numeric errors
    if (weightController.text.trim().isNotEmpty) {
      data['weight'] = weightController.text.trim();
    }
    
    if (heightController.text.trim().isNotEmpty) {
      data['height'] = heightController.text.trim();
    }

    await provider.completeProfile(uid, data);

    if (mounted) {
      if (provider.errorMessage == null) {
        // ✅ Refresh global user state to update Dashboard/Drawer
        await context.read<SplashProvider>().refresh();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
      child: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profile"),
              backgroundColor: const Color(0xFF00456A),
              foregroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _showImageSourceActionSheet(context),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: const Color(0xFF00456A),
                                backgroundImage: _imageFile != null 
                                  ? FileImage(_imageFile!) 
                                  : (_selectedAvatar != null && _selectedAvatar!.isNotEmpty
                                      ? (_selectedAvatar!.startsWith('http') 
                                          ? NetworkImage(_selectedAvatar!) 
                                          : FileImage(File(_selectedAvatar!))) as ImageProvider?
                                      : null),
                                child: (_imageFile == null && (_selectedAvatar == null || _selectedAvatar!.isEmpty))
                                  ? const Icon(Icons.person, size: 65, color: Colors.white)
                                  : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.orange,
                                  child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Text(
                          currentUserName.isEmpty ? "Your Name" : currentUserName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userMobile,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        const SizedBox(height: 20),
                        
                        // 📊 Profile Completion Meter
                        Consumer<SplashProvider>(
                          builder: (context, splash, _) {
                            final completion = splash.user?.profileCompletion ?? 0.0;
                            final percentage = (completion * 100).toInt();
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Profile Completion", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    Text("$percentage%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00456A))),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: completion,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      percentage < 40 ? Colors.red : (percentage < 80 ? Colors.orange : Colors.green),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 30),
                        
                        _buildTextField(nameController, "Full Name", Icons.person_outline),
                        const SizedBox(height: 16),
                        
                        _buildTextField(emailController, "Email Address", Icons.email_outlined, keyboardType: TextInputType.emailAddress, isOptional: true),
                        const SizedBox(height: 16),
                        
                        // 📅 Date of Birth & 🔢 Static Age
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: dobController,
                                readOnly: true,
                                onTap: () => _selectDate(context),
                                decoration: InputDecoration(
                                  labelText: "Date of Birth",
                                  prefixIcon: const Icon(Icons.calendar_month_outlined),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 80,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // ✅ Added to prevent overflow
                                children: [
                                  const Text("Age", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  Text(calculatedAge, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // 💉 Gender & 🩸 Blood Group
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                decoration: InputDecoration(
                                  labelText: "Gender",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: const Icon(Icons.wc_outlined),
                                ),
                                items: ["Male", "Female", "Other"]
                                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                                    .toList(),
                                onChanged: (v) => setState(() => selectedGender = v),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedBloodGroup,
                                decoration: InputDecoration(
                                  labelText: "Blood Group",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: const Icon(Icons.bloodtype_outlined),
                                ),
                                items: _bloodGroups
                                    .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                                    .toList(),
                                onChanged: (v) => setState(() => selectedBloodGroup = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(child: _buildTextField(weightController, "Weight (Kg)", Icons.monitor_weight_outlined, keyboardType: TextInputType.number, isOptional: true)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTextField(heightController, "Height (Cm)", Icons.height_outlined, keyboardType: TextInputType.number, isOptional: true)),
                          ],
                        ),

                        const SizedBox(height: 24),
                        const Divider(),
                        
                        // 📱 Update Mobile No. Tab
                        ListTile(
                          onTap: () {
                            // Link to Mobile update logic
                          },
                          leading: const Icon(Icons.phone_android, color: Color(0xFF00456A)),
                          title: const Text("Update Mobile Number", style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text("Keep your contact info up to date"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                        
                        const SizedBox(height: 30),
                        AuthButton(
                          text: "Save Changes",
                          onPressed: provider.isLoading ? null : () => _saveProfile(provider),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                if (provider.isLoading)
                  const ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF00456A)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    IconData icon, 
    {TextInputType keyboardType = TextInputType.text, bool isOptional = false}
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (v) {
        if (isOptional) return null;
        return v!.isEmpty ? "Required field" : null;
      },
    );
  }
}
