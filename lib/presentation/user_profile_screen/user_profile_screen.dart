import 'package:flutter/material.dart';
import 'package:googleapis/dfareporting/v3_5.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
  
  static Widget builder(BuildContext context) => UserProfileScreen();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  
  bool _isPasswordHidden = true;
  bool _isNewPasswordHidden = true;
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
        showErrorSnackBar('No user is currently logged in.');
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
      showErrorSnackBar('Failed to fetch user data: $e');
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

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Oh Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showSuccessSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: message,
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // UI Components
  Widget _buildProfileForm() {
    return Form(
      key: _profileFormKey,
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileField(
            controller: _nameController,
            icon: Icons.person,
            label: "Full Name",
            validator: (value) => value?.isEmpty ?? true ? "Please enter your name" : null,
          ),
          const SizedBox(height: 16),
          _buildPhoneField(),
          const SizedBox(height: 16),
          _buildProfileField(
            controller: _addressController,
            icon: Icons.location_on,
            label: "Address",
            validator: (value) => value?.isEmpty ?? true ? "Please enter your address" : null,
          ),
          const SizedBox(height: 16),
          _buildProfileField(
            controller: _emailController,
            icon: Icons.email,
            label: "Email Address",
            keyboardType: TextInputType.emailAddress,
            validator: (value) => !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value ?? '') 
                ? "Please enter a valid email" 
                : null,
          ),
          const SizedBox(height: 32),
          _buildActionButton(
            label: 'Save Changes',
            onPressed: _handleProfileUpdate,
            icon: Icons.save,
            color: appTheme.orangeA200,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: appTheme.orangeA200.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: 60,
              color: appTheme.orangeA200,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _nameController.text.isNotEmpty ? _nameController.text : 'User Profile',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_emailController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _emailController.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Text(
              "Security Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: appTheme.orangeA200,
              ),
            ),
          ),
          _buildPasswordField(
            controller: _currentPasswordController,
            label: "Current Password",
            isHidden: _isPasswordHidden,
            toggleVisibility: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
          ),
          const SizedBox(height: 16),
          _buildPasswordField(
            controller: _newPasswordController,
            label: "New Password",
            isHidden: _isNewPasswordHidden,
            toggleVisibility: () => setState(() => _isNewPasswordHidden = !_isNewPasswordHidden),
          ),
          const SizedBox(height: 32),
          Center(
            child: _buildActionButton(
              label: 'Change Password',
              onPressed: _handlePasswordUpdate,
              icon: Icons.lock_reset,
              color: appTheme.orangeA200,
            ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomTextFormField(
        controller: controller,
        hintText: label,
        textInputType: keyboardType,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Icon(icon, color: appTheme.orangeA200, size: 22),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 12.h),
        validator: validator,
        borderDecoration: InputBorder.none,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isHidden,
    required VoidCallback toggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomTextFormField(
        controller: controller,
        hintText: label,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Icon(Icons.lock, color: appTheme.orangeA200, size: 22),
        ),
        suffix: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: toggleVisibility,
            child: Icon(
              isHidden ? Icons.visibility : Icons.visibility_off,
              color: appTheme.orangeA200,
              size: 22,
            ),
          ),
        ),
        obscureText: isHidden,
        validator: (value) => (value?.length ?? 0) < 6 
            ? "Password must be at least 6 characters" 
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 12.h),
        borderDecoration: InputBorder.none,
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomTextFormField(
        controller: _phoneController,
        borderDecoration: InputBorder.none,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIndia,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 20,
                child: VerticalDivider(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
        validator: (value) =>
            value?.length != 10 ? "Please enter a valid 10-digit phone number" : null,
        hintText: "Phone Number",
        textInputType: TextInputType.phone,
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleProfileUpdate() async {
    if (!_profileFormKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showErrorSnackBar('No user is currently logged in.');
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
      showSuccessSnackBar('Profile updated successfully!');
    } catch (e) {
      showErrorSnackBar('Failed to update profile: $e');
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
        showErrorSnackBar('No user is currently logged in.');
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        showErrorSnackBar('User document not found.');
        return;
      }

      final storedPassword = userDoc.data()?['password'];
      if (_currentPasswordController.text != storedPassword) {
        showErrorSnackBar('Current password is incorrect.');
        return;
      }

      await Future.wait([
        FirebaseFirestore.instance
            .collection('patients')
            .doc(user.uid)
            .update({'password': _newPasswordController.text}),
        user.updatePassword(_newPasswordController.text),
      ]);
      showSuccessSnackBar('Password updated successfully!');
      
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } catch (e) {
      showErrorSnackBar('Failed to update password: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      showErrorSnackBar('Failed to log out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile Settings',
            style: TextStyle(
              color: appTheme.orangeA200,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: appTheme.orangeA200),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.imgProfileBg),
                  fit: BoxFit.cover,
                  opacity: 0.8,
                ),
              ),
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(appTheme.orangeA200),
                ),
              )
            else
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildProfileForm(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_showPasswordFields)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: _buildPasswordForm(),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: const EdgeInsets.all(4),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.logout, size: 20),
                        label: const Text(
                          'Log out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _handleLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}