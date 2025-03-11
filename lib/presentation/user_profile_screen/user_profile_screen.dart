import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'package:svar_new/presentation/home/provider/streak_provider.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/presentation/home/provider/main_interaction_provider.dart';
import 'package:svar_new/core/app_export.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize streak provider data
      Provider.of<StreakProvider>(context, listen: false).initializeStreakData();
    });
    
  }

  Future<void> fetchUserData() async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('patients').doc(uid);
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isPersonalDetailsSelected = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Change password dialog
  Future<void> _showChangePasswordDialog() async {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
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

                      if (newPasswordController.text != confirmPasswordController.text) {
                        setState(() {
                          errorMessage = 'New passwords do not match';
                        });
                        return;
                      }

                      if (newPasswordController.text.length < 6) {
                        setState(() {
                          errorMessage = 'Password must be at least 6 characters';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9F2EF),
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              _buildInfoTabs(),
              _buildSupportSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<StreakProvider>(
      builder: (context, streakProvider, child) {
        return Container(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              // Profile background curve
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2), // Increased opacity
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              // Profile image (positioned to overlap the curve)
              Transform.translate(
                offset: const Offset(0, -60),
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2), // White border
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.lightBlue.shade200,
                              backgroundImage: widget.userData?['profileImage'] != null 
                                  ? NetworkImage(widget.userData!['profileImage']) 
                                  : null,
                              child: widget.userData?['profileImage'] == null 
                                  ? Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.lightBlue.shade600,
                                  ) 
                                  : null,
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
                            child: const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.lightBlue,
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                       streakProvider.patientName ,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
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
            margin: const EdgeInsets.only(left: 8, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.brown.shade300,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown.shade300,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Changed to white for contrast
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.normal),
                    indicator: BoxDecoration(
                      color: Colors.teal
                          .withOpacity(0.1), // Light teal for selected tab
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tabs: const [
                      Tab(text: 'Personal Details'),
                      Tab (text: 'Child Details') 
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: _isPersonalDetailsSelected
                      ? _buildPersonalDetailsTab()
                      : _buildChildDetailsTab(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalDetailsTab() {
    return Column(
      children: [
        // Name field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.teal, // Unified color
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return Text(
                          streakProvider.patientName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Father's Name field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.teal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Father\'s Name',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return Text(
                          streakProvider.fatherName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Mother's Name field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.teal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mother\'s Name',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return Text(
                          streakProvider.motherName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Address field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_outlined,
                  color: Colors.teal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return Text(
                          streakProvider.address,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Email field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1), // Unified background
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: Colors.teal, // Unified color
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                Consumer<StreakProvider>(
                builder: (context, streakProvider, child) {
                   return Text(
                    streakProvider.patientEmail ,
                         style: const TextStyle(
                     fontSize: 16,
                  fontWeight: FontWeight.w500,
                    ),
                     );
                      },
                         ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16), // Increased spacing
        // Contact field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1), // Unified background
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_outlined,
                  color: Colors.teal, // Unified color
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return Text(
                          streakProvider.patientPhone ,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16), // Added spacing for password button
        // Password change button
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Colors.teal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '••••••••',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _showChangePasswordDialog,
                child: Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildChildDetailsTab() {
    return Column(
      children: [
        // Child Name field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.child_care,
                  color: Colors.teal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Child Name',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return Text(
                          streakProvider.patientName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Child Age field
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cake,
                  color: Colors.teal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Child Age',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Consumer<StreakProvider>(
                      builder: (context, streakProvider, child) {
                        return Text(
                          '${streakProvider.age} years',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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


