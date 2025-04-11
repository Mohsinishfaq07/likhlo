import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likhlo/Utils/Model/Profilemodel.dart';
import 'package:likhlo/Utils/Provider/ProfileProvider.dart';
import 'package:likhlo/Utils/Service/AuthService.dart';
import 'package:likhlo/Widgets/Button/CustomButton.dart';
import 'package:likhlo/Widgets/Inpufield/Profilefields.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  final TextEditingController _ageController = TextEditingController();
  final List<String> _genderOptions = ['Male', 'Female'];
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!_isEditing) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_isEditing) {
      if (_formKey.currentState!.validate()) {
        final profileRepository = ref.read(userProfileRepositoryProvider);
        final user = FirebaseAuth.instance.currentUser;
        final currentEmail = user?.email;

        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not logged in.')),
          );
          return;
        }

        final profile = ProfileModel(
          name: _nameController.text.trim(),
          email: currentEmail ?? '',
          mobileNumber: _mobileNumberController.text.trim(),
          gender: _selectedGender ?? '',
          dateOfBirth: _selectedDateOfBirth,
          age:
              _ageController.text.isEmpty
                  ? null
                  : int.tryParse(_ageController.text),
        );
        try {
          await profileRepository.addOrUpdateProfile(profile);
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      }
    } else {
      _toggleEdit();
    }
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileStreamProvider);
    AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                _isEditing ? Icons.save : Icons.edit,
                color: Colors.white,
              ),
              onPressed: _saveProfile, // Call _saveProfile directly
            ),
          ),
        ],
      ),
      body: profile.when(
        data: (profileData) {
          if (profileData != null) {
            _nameController.text = profileData.name;
            _mobileNumberController.text = profileData.mobileNumber;
            _selectedGender =
                profileData.gender.isNotEmpty ? profileData.gender : null;
            _selectedDateOfBirth = profileData.dateOfBirth;
            _ageController.text = profileData.age?.toString() ?? '';
            _emailController.text = authService.currentUser!.email!;
          } else {
            _emailController.text = authService.currentUser!.email!;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileFields(
                    controller: _nameController,
                    label: "Name",
                    enabled: _isEditing,
                    icon: Icons.person,
                    validator: _isEditing ? _validateField : null,
                  ),
                  const SizedBox(height: 16),
                  ProfileFields(
                    controller: _emailController,
                    label: "Email",
                    enabled: false,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  ProfileFields(
                    controller: _mobileNumberController,
                    label: "Mobile Number",
                    enabled: _isEditing,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: _isEditing ? _validateField : null,
                  ),
                  const SizedBox(height: 16),
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade700),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      isExpanded: true,
                      hint: Text(
                        'Select Gender',
                        style: GoogleFonts.poppins(color: Colors.grey.shade400),
                      ),
                      items:
                          _genderOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                      onChanged:
                          _isEditing
                              ? (String? newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              }
                              : null,
                      validator:
                          _isEditing
                              ? (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please select a gender'
                                      : null
                              : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        labelStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade700),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          _selectedDateOfBirth != null
                              ? "${_selectedDateOfBirth!.year}-${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}-${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}"
                              : 'Select Date of Birth',
                          style: GoogleFonts.poppins(
                            color:
                                _selectedDateOfBirth != null
                                    ? Colors.black
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileFields(
                    controller: _ageController,
                    label: "Age",
                    enabled: _isEditing,
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                    validator: _isEditing ? _validateField : null,
                  ),
                  const SizedBox(height: 32),
                  ActionButton(
                    label: "Save",
                    isLoading: false,
                    onPressed: () async {
                      _saveProfile();
                    },
                  ),
                  const SizedBox(height: 20),
                  ActionButton(
                    label: "Logout",
                    isLoading: false,
                    onPressed: () async {
                      await authService.logout(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) =>
                Center(child: Text('Error fetching profile: $error')),
      ),
    );
  }
}
