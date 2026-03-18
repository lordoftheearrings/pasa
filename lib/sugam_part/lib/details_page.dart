// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ble_controller.dart';

class DetailsPage extends StatefulWidget {
  final BleController bleController;

  const DetailsPage({super.key, required this.bleController});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> emergencyContacts = [];
  bool isLoading = true;
  bool crashDetected = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();

    // widget.bleController.onDataReceived = (_) {
    //   if (!mounted) return;

    //   setState(() {
    //     crashDetected = widget.bleController.crashDetected;
    //   });

    //   if (crashDetected) {
    //     _sendEmergencyNotifications();
    //   }
    // };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    if (!mounted) return;

    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('emergency_contacts')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        emergencyContacts = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("Error loading contacts: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
      _showSnackBar("Failed to load contacts", Colors.red);
    }
  }

  Future<void> _addContact() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _relationController.text.isEmpty) {
      if (!mounted) return;
      _showSnackBar("Please fill all fields", Colors.orange);
      return;
    }

    try {
      await supabase.from('emergency_contacts').insert({
        'user_id': supabase.auth.currentUser!.id,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'relation': _relationController.text,
      });

      _nameController.clear();
      _phoneController.clear();
      _relationController.clear();

      // Load contacts only if mounted
      await _loadContacts();

      if (!mounted) return; // <-- always check

      // Pop dialog safely
      Navigator.of(context, rootNavigator: true).pop();

      // Show snackbar safely
      _showSnackBar("Contact added successfully", Colors.green);
    } catch (e) {
      print("Error adding contact: $e");
      if (!mounted) return;
      _showSnackBar("Failed to add contact", Colors.red);
    }
  }

  // Delete contact from Supabase
  Future<void> _deleteContact(String id) async {
    try {
      await supabase.from('emergency_contacts').delete().eq('id', id);
      _loadContacts();
      _showSnackBar("Contact deleted", Colors.green);
    } catch (e) {
      print("Error deleting contact: $e");
      _showSnackBar("Failed to delete contact", Colors.red);
    }
  }

  // // Send emergency notifications (placeholder - integrate with SMS API)
  // Future<void> _sendEmergencyNotifications() async {
  //   if (emergencyContacts.isEmpty) return;

  //   double lat = widget.bleController.latitude;
  //   double lng = widget.bleController.longitude;

  //   String message =
  //       "🚨 EMERGENCY ALERT! Crash detected at GPS: $lat, $lng. Please respond immediately.";

  //   print("Sending emergency SMS to all contacts: $message");

  //   _showSnackBar("Emergency notifications sent!", Colors.red);
  // }

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

  void _showAddContactDialog() {
    if (emergencyContacts.length == 3) {
      _showSnackBar('Only 3 contacts can be added at a time', Colors.red);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Add Emergency Contact",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(_nameController, "Name", Icons.person),
            const SizedBox(height: 12),
            _buildTextField(_phoneController, "Phone", Icons.phone),
            const SizedBox(height: 12),
            _buildTextField(
              _relationController,
              "Relation",
              Icons.family_restroom,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _addContact,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.grey[850],
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
          "Emergency Contacts",
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAddContactDialog,
            icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
          ),
        ],
      ),
      body: Column(
        children: [
          // Crash Alert Banner
          if (crashDetected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "CRASH DETECTED! Notifying contacts...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

          // Emergency Info Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[900]!, Colors.red[700]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.emergency, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                const Text(
                  "EMERGENCY CONTACTS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "These contacts will be notified in case of emergency\n\nOnly 3 contacts can be added at a time",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Contacts List
          Flexible(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : emergencyContacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.contacts, size: 80, color: Colors.grey[700]),
                        const SizedBox(height: 16),
                        Text(
                          "No emergency contacts added",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap + to add contacts",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: Colors.green,
                    onRefresh: _loadContacts,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: emergencyContacts.length,
                      itemBuilder: (context, index) {
                        final contact = emergencyContacts[index];
                        return _buildContactCard(contact);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Colors.green, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'] ?? 'Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact['phone'] ?? 'No phone',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact['relation'] ?? 'Unknown relation',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _deleteContact(contact['id'] as String),
            // onPressed: () => getIt<BleController>().cancelSOS(),
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
