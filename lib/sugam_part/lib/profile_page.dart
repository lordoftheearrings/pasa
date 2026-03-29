// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pasa/core/components/buttons/app_button.dart';
import 'package:pasa/core/components/messengers/dialog_box.dart';
import 'package:pasa/core/components/selectors/date_selector.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/sugam_part/lib/ble_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static final GlobalKey<_ProfilePageState> profileKey =
      GlobalKey<_ProfilePageState>();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;

  // User profile data
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  bool isEditing = false;

  DateTime? _selectedDob;
  String? _selectedGender;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _emergencyNoteController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bloodGroupController.dispose();
    _emergencyNoteController.dispose();
    super.dispose();
  }

  int? _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> loadProfileAndSendToBle() async {
    await _loadProfile();
  }

  // Load user profile from Supabase
  Future<void> _loadProfile() async {
    setState(() => isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        _showSnackBar("No authenticated user found", Colors.red);
        return;
      }
      final userId = user.id;
      final response = await supabase
          .from('user_profile')
          .select()
          .eq('user_id', userId)
          .single();

      setState(() {
        userProfile = response;
        _populateControllers();
        isLoading = false;
      });

      final dobStr = userProfile?['dob']?.toString();
      DateTime? dob = dobStr != null ? DateTime.tryParse(dobStr) : null;
      int age = dob != null ? _calculateAge(dob)! : 0;

      // Map blood group string to ESP int code
      final String bgString = userProfile?['blood_group']?.toString() ?? '';
      final int bgCode = bloodGroupCodes[bgString] ?? 0;

      await getIt<BleController>().setUserProfile(
        name: userProfile?['name']?.toString() ?? '',
        age: age,
        bloodGroup: bgCode, // send the int code now
        medicalInfo: userProfile?['emergency_note']?.toString() ?? '',
      );
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        userProfile = null;
        isLoading = false;
      });
    }
  }

  // Map blood group string -> ESP code
  static const Map<String, int> bloodGroupCodes = {
    "A+": 1,
    "A-": 2,
    "B+": 3,
    "B-": 4,
    "AB+": 5,
    "AB-": 6,
    "O+": 7,
    "O-": 8,
  };
  void _populateControllers() {
    if (userProfile != null) {
      _nameController.text = userProfile!['name'] ?? '';
      _emailController.text = userProfile!['email'] ?? '';
      _phoneController.text = userProfile!['phone'] ?? '';
      _addressController.text = userProfile!['address'] ?? '';
      _bloodGroupController.text = userProfile!['blood_group'] ?? '';
      _emergencyNoteController.text = userProfile!['emergency_note'] ?? '';

      final dobStr = userProfile!['dob'];
      if (dobStr != null) {
        _selectedDob = DateTime.tryParse(dobStr);
      }
      _selectedGender = userProfile!['gender'];
    }
  }

  // Save/Update profile to Supabase
  Future<void> _saveProfile() async {
    try {
      final data = {
        'user_id': supabase.auth.currentUser!.id,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'blood_group': _bloodGroupController.text,
        'emergency_note': _emergencyNoteController.text,
        'dob': _selectedDob?.toIso8601String(),
        'gender': _selectedGender,
      };

      if (userProfile == null) {
        await supabase.from('user_profile').insert(data);
      } else {
        await supabase
            .from('user_profile')
            .update(data)
            .eq('user_id', supabase.auth.currentUser!.id);
      }

      await _loadProfile();
      setState(() => isEditing = false);
      _showSnackBar("Profile saved successfully", Colors.green);
    } catch (e) {
      print("Error saving profile: $e");
      _showSnackBar("Failed to save profile", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool? enabled,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled ?? isEditing,
      maxLines: maxLines,
      style: TextStyle(
        color: isEditing ? Colors.white : Colors.grey[400],
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isEditing ? Colors.grey[400] : Colors.grey[600],
        ),
        prefixIcon: Icon(
          icon,
          color: isEditing ? Colors.green : Colors.grey[600],
        ),
        filled: true,
        fillColor: isEditing ? Colors.grey[850] : Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (!isEditing)
            IconButton(
              onPressed: () => setState(() => isEditing = true),
              icon: const Icon(Icons.edit, color: Colors.green),
            )
          else
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() => isEditing = false);
                    _populateControllers();
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                ),
                IconButton(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.check, color: Colors.green),
                ),
              ],
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Avatar
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[700]!, Colors.green[500]!],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // User Name
                  Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : "Your Name",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _emailController.text.isNotEmpty
                        ? _emailController.text
                        : "your.email@example.com",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Profile Form
                  _buildTextField(
                    controller: _nameController,
                    label: "Full Name",
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _phoneController,
                    label: "Phone Number",
                    icon: Icons.phone,
                  ),

                  const SizedBox(height: 16),

                  // Age (Read-only)
                  _buildTextField(
                    controller: TextEditingController(
                      text: _selectedDob != null
                          ? _calculateAge(_selectedDob!).toString()
                          : "--",
                    ),
                    label: "Age",
                    icon: Icons.calendar_today_outlined,
                    enabled: false,
                  ),

                  const SizedBox(height: 16),

                  // Date of Birth
                  DateSelector(
                    label: "Date of Birth",
                    selectedDate: _selectedDob,
                    enabled: isEditing,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDob = date;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Gender Selection (Styled like other fields)
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: "Gender",
                      labelStyle: TextStyle(
                        color: isEditing ? Colors.grey[400] : Colors.grey[600],
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: isEditing ? Colors.green : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: isEditing
                          ? Colors.grey[850]
                          : Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                      ),
                    ),
                    items:
                        [
                              {'value': 'male', 'label': 'Male'},
                              {'value': 'female', 'label': 'Female'},
                              {'value': 'ratherNotSay', 'label': 'Other'},
                            ]
                            .map(
                              (g) => DropdownMenuItem(
                                value: g['value'],
                                child: Text(g['label']!),
                              ),
                            )
                            .toList(),
                    onChanged: isEditing
                        ? (val) => setState(() => _selectedGender = val)
                        : null,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _addressController,
                    label: "Address",
                    icon: Icons.home,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _bloodGroupController,
                    label: "Blood Group",
                    icon: Icons.bloodtype,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _emergencyNoteController,
                    label: "Emergency Medical Notes",
                    icon: Icons.medical_information,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 32),

                  // Stats Cards
                  // Row(
                  //   //TODO: add stats
                  //   children: [
                  //     _buildStatCard(
                  //       icon: Icons.access_time,
                  //       label: "Rides",
                  //       value: "--",
                  //       color: Colors.blue,
                  //     ),
                  //     const SizedBox(width: 12),
                  //     _buildStatCard(
                  //       icon: Icons.route,
                  //       label: "Distance",
                  //       value: "-- km",
                  //       color: Colors.purple,
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 12),

                  // Row(
                  //   children: [
                  //     _buildStatCard(
                  //       icon: Icons.timer,
                  //       label: "Avg Time",
                  //       value: "-- min",
                  //       color: Colors.orange,
                  //     ),
                  //     const SizedBox(width: 12),
                  //     _buildStatCard(
                  //       icon: Icons.favorite,
                  //       label: "Avg HR",
                  //       value: "-- BPM",
                  //       color: Colors.red,
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 32),
                  SizedBox(height: 16),
                  AppButton(
                    label: 'LogOut',
                    onPressed: () async {
                      final save = await AppDialogBox.show(
                        context,
                        title: "Are you sure?",
                        content: 'You want to log out?',
                      );
                      if (save == null || !save) {
                        return;
                      } else if (save) {
                        getIt<SupabaseClient>().auth.signOut();
                      }
                    },
                  ),

                  // // Danger Zone
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Colors.red.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(16),
                  //     border: Border.all(
                  //       color: Colors.red.withOpacity(0.3),
                  //       width: 1.5,
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       const Row(
                  //         children: [
                  //           Icon(Icons.warning, color: Colors.red, size: 20),
                  //           SizedBox(width: 8),
                  //           Text(
                  //             "DANGER ZONE",
                  //             style: TextStyle(
                  //               color: Colors.red,
                  //               fontSize: 14,
                  //               fontWeight: FontWeight.w800,
                  //               letterSpacing: 1,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 12),
                  //       ElevatedButton.icon(
                  //         onPressed: () {
                  //           // Show confirmation dialog
                  //           showDialog(
                  //             context: context,
                  //             builder: (context) => AlertDialog(
                  //               backgroundColor: Colors.grey[900],
                  //               title: const Text(
                  //                 "Delete Account?",
                  //                 style: TextStyle(color: Colors.red),
                  //               ),
                  //               content: const Text(
                  //                 "This action cannot be undone. All your data will be permanently deleted.",
                  //                 style: TextStyle(color: Colors.white),
                  //               ),
                  //               actions: [
                  //                 TextButton(
                  //                   onPressed: () => Navigator.pop(context),
                  //                   child: const Text("Cancel"),
                  //                 ),
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                     _showSnackBar(
                  //                       "Account deletion not implemented",
                  //                       Colors.orange,
                  //                     );
                  //                   },
                  //                   child: const Text(
                  //                     "Delete",
                  //                     style: TextStyle(color: Colors.red),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           );
                  //         },
                  //         icon: const Icon(Icons.delete_forever, size: 20),
                  //         label: const Text("Delete Account"),
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.red.withOpacity(0.2),
                  //           foregroundColor: Colors.red,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //         ),
                  //       ),

                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // Widget _buildStatCard({
  //   required IconData icon,
  //   required String label,
  //   required String value,
  //   required Color color,
  // }) {
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[900],
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(color: color.withOpacity(0.3), width: 1.5),
  //       ),
  //       child: Column(
  //         children: [
  //           Icon(icon, color: color, size: 28),
  //           const SizedBox(height: 8),
  //           Text(
  //             value,
  //             style: TextStyle(
  //               color: color,
  //               fontSize: 20,
  //               fontWeight: FontWeight.w800,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               color: Colors.grey[500],
  //               fontSize: 12,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
