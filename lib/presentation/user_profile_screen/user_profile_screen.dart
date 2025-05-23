import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/patient_report/app_theme.dart';
import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'package:svar_new/presentation/home/provider/streak_provider.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/presentation/home/provider/main_interaction_provider.dart';
import 'package:svar_new/core/app_export.dart';


import 'package:svar_new/widgets/customTextField.dart';
import 'package:svar_new/widgets/custom_button.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();

  static Widget builder(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainInteractionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StreakProvider(),
        ),
      ],
      child: UserProfileScreen(),
    );
  }
}

class UserProfileScreenState extends State<UserProfileScreen> {
  late String uid;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Get current user ID

    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    fetchUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize streak provider data
      Provider.of<StreakProvider>(context, listen: false)
          .initializeStreakData();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> fetchUserData() async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('patients').doc(uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        setState(() {
          userData = docSnapshot.data();
          isLoading = false;
        });
      } else {
        print('User document with ID $uid not found.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(child: CircularProgressIndicator())),
      );
    } else {
      return ProfilePage(userData: userData);
    }
  }
}

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ProfilePage({Key? key, this.userData}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 4; // Default to Today tab
  late TabController _tabController;
  bool _isPersonalDetailsSelected = true;
  bool _isUploading = false;

  // Track if any field has changed
  bool _hasChanges = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController childNameController = TextEditingController();
  TextEditingController childAgeController = TextEditingController();

  // Store original values to compare against
  String _originalName = '';
  String _originalFatherName = '';
  String _originalMotherName = '';
  String _originalAddress = '';
  String _originalEmail = '';
  String _originalContact = '';
  String _originalChildName = '';
  String _originalChildAge = '';

  // This function handles index changes from the bottom navigation bar
  // This function handles index changes from the bottom navigation bar
  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Note: The navigation logic is handled inside the CustomBottomNavigationBar
  }


  @override
  void initState() {
    super.initState();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isPersonalDetailsSelected = _tabController.index == 0;
      });
    });

    // Initialize original values and add listeners to text controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeOriginalValues();
      _addFieldListeners();
    });
  }

  void _initializeOriginalValues() {
    _originalName = widget.userData?["name"] ?? '';
    _originalFatherName = widget.userData?["fathersName"] ?? '';
    _originalMotherName = widget.userData?["mothersName"] ?? '';
    _originalAddress = widget.userData?["address"] ?? '';
    _originalEmail = widget.userData?["email"] ?? '';
    _originalContact = widget.userData?["parentPhone"] ?? '';
    _originalChildName = widget.userData?["name"] ?? '';
    _originalChildAge = widget.userData?["age"] ?? '';
  }

  void _addFieldListeners() {
    nameController.addListener(_checkForChanges);
    fatherNameController.addListener(_checkForChanges);
    motherNameController.addListener(_checkForChanges);
    addressController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    contactController.addListener(_checkForChanges);
    childNameController.addListener(_checkForChanges);
    childAgeController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    bool hasChanges = nameController.text != _originalName ||
        fatherNameController.text != _originalFatherName ||
        motherNameController.text != _originalMotherName ||
        addressController.text != _originalAddress ||
        emailController.text != _originalEmail ||
        contactController.text != _originalContact ||
        childNameController.text != _originalChildName ||
        childAgeController.text != _originalChildAge;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    nameController.removeListener(_checkForChanges);
    fatherNameController.removeListener(_checkForChanges);
    motherNameController.removeListener(_checkForChanges);
    addressController.removeListener(_checkForChanges);
    emailController.removeListener(_checkForChanges);
    contactController.removeListener(_checkForChanges);
    childNameController.removeListener(_checkForChanges);
    childAgeController.removeListener(_checkForChanges);

    _tabController.dispose();
    super.dispose();
  }
     
  // Change password dialog
  Future<void> _showChangePasswordDialog() async {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isLoading = false;
    String errorMessage = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Change Password'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                    TextField(
                      controller: currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Current Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () async {
                      // Validate inputs
                      if (currentPasswordController.text.isEmpty ||
                          newPasswordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        setState(() {
                          errorMessage = 'All fields are required';
                        });
                        return;
                      }

                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        setState(() {
                          errorMessage = 'New passwords do not match';
                        });
                        return;
                      }

                      if (newPasswordController.text.length < 6) {
                        setState(() {
                          errorMessage =
                              'Password must be at least 6 characters';
                        });
                        return;
                      }

                      // Update password
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });

                      try {
                        // Get current user
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          // Create a credential with email and current password
                          final credential = EmailAuthProvider.credential(
                            email: user.email!,
                            password: currentPasswordController.text,
                          );

                          // Re-authenticate user
                          await user.reauthenticateWithCredential(credential);

                          // Change password in Firebase Auth
                          await user.updatePassword(newPasswordController.text);

                          // Update password in Firestore
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'password': newPasswordController.text,
                          });

                          Navigator.of(context).pop();

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password updated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          isLoading = false;
                          if (e.code == 'wrong-password') {
                            errorMessage = 'Current password is incorrect';
                          } else {
                            errorMessage = 'Error: ${e.message}';
                          }
                        });
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                          errorMessage = 'An error occurred: $e';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text('Update'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.userData?["name"] ?? '';
    fatherNameController.text = widget.userData?["fathersName"] ?? '';
    motherNameController.text = widget.userData?["mothersName"] ?? '';
    addressController.text = widget.userData?["address"] ?? '';
    emailController.text = widget.userData?["email"] ?? '';
    contactController.text = widget.userData?["parentPhone"] ?? '';
    childNameController.text = widget.userData?["name"] ?? '';
    childAgeController.text = widget.userData?["age"] ?? '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(),
            _buildInfoTabs(),
            // _buildSupportSection(),
            // Conditional buttons based on field changes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _hasChanges
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            type: ButtonType.Save,
                            onPressed: () {
                              UserData(
                                      uid: FirebaseAuth
                                              .instance.currentUser?.uid ??
                                          '')
                                  .updateUserFields({
                                "name": childNameController.text,
                                "fathersName": fatherNameController.text,
                                "mothersName": motherNameController.text,
                                "address": addressController.text,
                                "email": emailController.text,
                                "parentPhone": contactController.text,
                                "age": childAgeController.text,
                              }, widget.userData!);
      
                              // Update original values after save
                              _initializeOriginalValues();
      
                              // Reset hasChanges
                              setState(() {
                                _hasChanges = false;
                              });
      
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Profile updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
      
                              print("Save button pressed");
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            type: ButtonType.Logout,
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              NavigatorService.pushNamed(
                                  AppRoutes.loginSignup);
                            },
                          ),
                        ),
                      ],
                    )
                  : CustomButton(
                      type: ButtonType.Logout,
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        NavigatorService.pushNamed(AppRoutes.loginSignup);
                      },
                    ),
            ),
            const SizedBox(height: 80), // Space for bottom navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<StreakProvider>(
      builder: (context, streakProvider, child) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile background curve
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Color(0xFF1cb0f6), // Bright blue color as in the image
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white,
                                  width: 4), // White border
                            ),
                            child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.lightBlue.shade200,
                                    backgroundImage:
                                        widget.userData?['profileImage'] != null
                                            ? NetworkImage(
                                                widget.userData!['profileImage']
                                                    as String)
                                            : AssetImage(
                                                "assets/images/girl.png",
                                              ) as ImageProvider,
                                  ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: _isUploading
                                  ? Colors.grey
                                  : Color(0xFF1cb0f6),
                              child: _isUploading
                                  ? SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        streakProvider.patientName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Profile image (positioned to overlap the curve)
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isPersonalDetailsSelected
                          ? Color(0xFF1cb0f6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Personal Details',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: _isPersonalDetailsSelected
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _tabController.animateTo(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_isPersonalDetailsSelected
                          ? Color(0xFF1cb0f6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Child Details',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: !_isPersonalDetailsSelected
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: _isPersonalDetailsSelected
                ? _buildPersonalDetailsTab()
                : _buildChildDetailsTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name field
        Text(
          'Name',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: nameController,
          hintText: 'Enter your name',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Colors.blue,
          enabledBorderColor: Colors.grey.shade300,
        ),

        SizedBox(height: 20),
        // Father's Name field
        Text(
          'Father\'s Name',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
          ),
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: fatherNameController,
          hintText: 'Enter your father\'s name',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Colors.blue,
          enabledBorderColor: Colors.grey.shade300,
        ),

        SizedBox(height: 20),
        // Mother's Name field
        Text(
          'Mother\'s Name',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
          ),
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: motherNameController,
          hintText: 'Enter your mother\'s name',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Colors.blue,
          enabledBorderColor: Colors.grey.shade300,
        ),

        SizedBox(height: 20),
        // Address field
        Text(
          'Address',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
          ),
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: addressController,
          hintText: 'Enter your address',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Colors.blue,
          enabledBorderColor: Colors.grey.shade300,
        ),

        SizedBox(height: 20),
        // Email field
        Text(
          'Email',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
          ),
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: emailController,
          hintText: 'Enter your email',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Colors.blue,
          enabledBorderColor: Colors.grey.shade300,
        ),

        SizedBox(height: 20),
        // Contact field
        Text(
          'Contact',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
          ),
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: contactController,
          hintText: 'Enter your contact number',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Color(0xFF1cb0f6),
          enabledBorderColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildChildDetailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Child Name field
        Text(
          'Child Name',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
          ),
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: childNameController,
          hintText: 'Enter your child\'s name',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Colors.blue,
          enabledBorderColor: Colors.grey.shade300,
        ),

        SizedBox(height: 20),
        // Child Age field
        Text(
          'Child Age',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
          ),
        ),
        SizedBox(height: 8),
        CustomTextField(
          controller: childAgeController,
          hintText: 'Enter your child\'s age',
          fillColor: Colors.grey.shade200,
          focusedBorderColor: Colors.blue,
          enabledBorderColor: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 24.0, left: 16.0, right: 16.0, bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 8, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.headset_mic_outlined,
                  color: Colors.brown.shade300,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown.shade300,
                  ),
                ),
              ],
            ),
          ),
          _buildSupportItem(
            icon: Icons.help_outline,
            iconBgColor: Colors.teal.withOpacity(0.1), // Unified background
            iconColor: Colors.teal.shade700, // Unified color
            title: 'FAQ\'s',
          ),
          SizedBox(height: 16), // Increased spacing
          _buildSupportItem(
            icon: Icons.warning_amber_outlined,
            iconBgColor: Colors.teal.withOpacity(0.1), // Unified background
            iconColor: Colors.teal.shade700, // Unified color
            title: 'Terms & Conditions',
          ),
          SizedBox(height: 16), // Increased spacing
          _buildSupportItem(
            icon: Icons.security_outlined,
            iconBgColor: Colors.teal.withOpacity(0.1), // Unified background
            iconColor: Colors.teal.shade700, // Unified color
            title: 'Privacy Policy',
          ),
        ],
      ),
    );
  }

  Widget _buildSupportItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white, // Changed to white for consistency
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.teal, // Match theme
            size: 24,
          ),
        ],
      ),
    );
  }
}
