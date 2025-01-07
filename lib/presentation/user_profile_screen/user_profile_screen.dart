import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
  
  static Widget builder(BuildContext context) => UserProfileScreen();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  
  bool _isPasswordHidden = true;
  bool _showPasswordFields = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchUserData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackBar('No user is currently logged in.');
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        _populateUserData(userDoc.data() ?? {});
      }
    } catch (e) {
      _showSnackBar('Failed to fetch user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateUserData(Map<String, dynamic> data) {
    setState(() {
      _nameController.text = data['name'] ?? '';
      _phoneController.text = data['mobile'] ?? '';
      _addressController.text = data['address'] ?? '';
      _emailController.text = data['email'] ?? '';
    });
  }

  // UI Components
  Widget _buildProfileForm() {
    return Form(
      key: _profileFormKey,
      child: Column(
        children: [
          _buildProfileField(
            controller: _nameController,
            icon: Icons.person,
            label: "Name",
            validator: (value) => value?.isEmpty ?? true ? "Please enter name" : null,
          ),
          _buildPhoneField(),
          _buildProfileField(
            controller: _addressController,
            icon: Icons.location_on,
            label: "Address",
            validator: (value) => value?.isEmpty ?? true ? "Please enter address" : null,
          ),
          _buildProfileField(
            controller: _emailController,
            icon: Icons.email,
            label: "Email",
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            label: 'Save Changes',
            onPressed: _handleProfileUpdate,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        children: [
          _buildPasswordField(
            controller: _currentPasswordController,
            label: "Current Password",
          ),
          _buildPasswordField(
            controller: _newPasswordController,
            label: "New Password",
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            label: 'Change Password',
            onPressed: _handlePasswordUpdate,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextFormField(
        controller: controller,
        hintText: label,
        textInputType: keyboardType,
        prefix: Icon(icon, color: appTheme.orangeA200, size: 24),
        contentPadding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 12.h),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextFormField(
        controller: controller,
        hintText: label,
        prefix: Icon(Icons.lock, color: appTheme.orangeA200, size: 24),
        suffix: GestureDetector(
          onTap: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
          child: Icon(
            _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            color: appTheme.orangeA200,
          ),
        ),
        obscureText: _isPasswordHidden,
        validator: (value) => (value?.length ?? 0) < 6 
            ? "Password must be at least 6 characters" 
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 12.h),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextFormField(
        controller: _phoneController,
        prefix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CustomImageView(
                imagePath: ImageConstant.imgIndia,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 24,
              child: VerticalDivider(color: appTheme.orangeA200),
            ),
          ],
        ),
        validator: (value) =>
            value?.length != 10 ? "Please enter valid phone number" : null,
        hintText: "Phone Number",
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.orangeA200,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _handleProfileUpdate() async {
    if (!_profileFormKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackBar('No user is currently logged in.');
        return;
      }

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .update({
        'name': _nameController.text,
        'mobile': _phoneController.text,
        'address': _addressController.text,
        'email': _emailController.text,
      });

      _showSnackBar('Profile updated successfully!');
      Navigator.pushReplacementNamed(context, '/nextScreenRoute');
    } catch (e) {
      _showSnackBar('Failed to update profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePasswordUpdate() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnackBar('No user is currently logged in.');
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        _showSnackBar('User document not found.');
        return;
      }

      final storedPassword = userDoc.data()?['password'];
      if (_currentPasswordController.text != storedPassword) {
        _showSnackBar('Current password is incorrect.');
        return;
      }

      await Future.wait([
        FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .update({'password': _newPasswordController.text}),
        user.updatePassword(_newPasswordController.text),
      ]);

      _showSnackBar('Password updated successfully!');
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } catch (e) {
      _showSnackBar('Failed to update password: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      _showSnackBar('Failed to log out: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.imgProfileBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
           
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SingleChildScrollView(
                
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Profile Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: appTheme.orangeA200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _buildProfileForm(),
                        const Divider(height: 40),
                        if (_showPasswordFields) ...[
                          _buildPasswordForm(),
                          const Divider(height: 40),
                        ],
                        _buildActionButton(
                          label: 'Log out',
                          onPressed: _handleLogout,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}