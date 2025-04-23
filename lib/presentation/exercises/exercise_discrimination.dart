import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart' hide LinearGradient,Image;
import 'package:svar_new/presentation/settings_screen/setting.dart';

class ExerciseDiscrimination extends StatefulWidget {
  const ExerciseDiscrimination({
    Key? key,
  }) : super(key: key);

  @override
  State<ExerciseDiscrimination> createState() => _DiscriminationState();

  static Widget builder(BuildContext context) {
    return const ExerciseDiscrimination();
  }
}

class _DiscriminationState extends State<ExerciseDiscrimination> with SingleTickerProviderStateMixin {
  final GlobalKey<AudioWidgetState> _childKey = GlobalKey<AudioWidgetState>();
  late UserData userData;
  int selectedOption = -1;
  List<double> samples = [];
  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;
  bool isPlaying = false;
  
  // Animation controller for feedback
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int currentIndex = 0;
  double currentProgress = 0.0;
  List<double> total_length = [];

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    // Portrait orientation setup
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
  }

  void getAudioProgress() {
    setState(() {
      currentProgress = _childKey.currentState!.progress.value;
    });
  }

  void _onRiveInit(Artboard artboard) async {
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 2');

    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;
      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;
    }
  }

  void _triggerAnimation(bool isCorrect) {
    if (isCorrect) {
      if (_correctTrigger != null) {
        _correctTrigger!.fire();
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int level = 0;

@override
Widget build(BuildContext context) {
  var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
  String type = obj[0] as String;
  level = obj[3] as int;
  Object data = obj[1] as Object;
  dynamic dtcontainer = obj[2] as dynamic;

  return Scaffold(
    body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // Replace gradient with background image
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/quiz_bg.jpeg'), // Update with your actual image path
          fit: BoxFit.fill,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Bar with padding
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.v),
              child: DisciAppBar(context),
            ),

            // Title section positioned over the placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.v),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
                // Remove decoration to make it transparent over the placeholder
                child: Text(
                  type == "OddOne"
                      ? "PICK THE ODD ONE OUT"
                      : type == "MaleFemale" 
                        ? "IDENTIFY THE GENDER"
                        : type == "DiffHalf"
                          ? "PRESS WHEN THE SOUND CHANGES"
                          : "SAME OR DIFFERENT?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.black87, // Adjust text color to be visible on placeholder
                  ),
                ),
              ),
            ),
            
            

            // Main content area
            Expanded(
              child: Stack(
                children: [
                  // Main discrimination options
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.h, 10.v, 15.h, 60.v),
                    child: discriminationOptions(type, data, dtcontainer),
                  ),

                  // Animation overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width,
                        child: RiveAnimation.asset(
                          'assets/rive/Celebration_animation.riv',
                          onInit: _onRiveInit,
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget discriminationOptions(String type, Object d, dynamic dtcontainer) {
    switch (type) {
      case "DiffSounds":
        return DiffSoundsW(d as DiffSounds, dtcontainer);
      case "OddOne":
        return OddOneW(d as OddOne, dtcontainer);
      case "DiffHalf":
        return DiffHalfW(d as DiffHalf, dtcontainer);
      case "MaleFemale":
        return MaleFemaleW(d as MaleFemale, dtcontainer);
      default:
        return Container();
    }
  }

Widget MaleFemaleW(MaleFemale maleFemale, dynamic dtcontainer) {
  var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
  var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
  int startExerciseIndex = obj[3] as int;
  Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

  // Use LayoutBuilder to ensure responsiveness
  return LayoutBuilder(
    builder: (context, constraints) {
      // Calculate responsive sizes
      double maxWidth = constraints.maxWidth;
      double maxHeight = constraints.maxHeight;
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Adding space to push everything to center vertically
          SizedBox(height: maxHeight * 0.05),
          
          // Audio player component - centered and sized appropriately
          Container(
            width: maxWidth * 0.8,
            height: 70,
            margin: EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: Color(0xFFF77D2B),  // Orange color
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AudioWidget(
              audioLinks: maleFemale.getVideoUrl(),
            ),
          ),
          
          // Gender selection options - smaller size and centered
          Container(
            width: maxWidth * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Female option
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: _buildSmallGenderOption(
                      "FEMALE",
                      "assets/images/female.png",
                      () => maleFemale.getCorrectOutput() == "female",
                      startExerciseIndex,
                      data,
                    ),
                  ),
                ),
                
                // Male option
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: _buildSmallGenderOption(
                      "MALE",
                      "assets/images/male.png",
                      () => maleFemale.getCorrectOutput() == "male",
                      startExerciseIndex,
                      data,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

// Small gender option widget optimized for centered layout
Widget _buildSmallGenderOption(
  String label, 
  String imagePath, 
  bool Function() isCorrectFn,
  int startExerciseIndex,
  Map<String, dynamic> data
) {
  return OptionWidget(
    triggerAnimation: _triggerAnimation,
    child: Container(
      height: 220, // Reduced height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image section
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF5FB8FF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  height: 85, // Smaller image size
                ),
              ),
            ),
          ),
          
          // Label section
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5E9FE0), Color(0xFF3D7EDB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Smaller font size
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isCorrect: () {
      var condition = isCorrectFn();
      if (condition) {
        var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
        data_pro.incrementLevel(startExerciseIndex);
        if (data["completedAt"] == null) {
          UserData(uid: FirebaseAuth.instance.currentUser!.uid)
              .updateExerciseData(
            euid: data["uid"],
            date: data["date"],
          );
        }
      }
      return condition;
    },
  );
}
  
  Widget DiffHalfW(DiffHalf diffHalf, dynamic dtcontainer) {
  var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
  var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
  int startExerciseIndex = obj[3] as int;
  Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

  // Using LayoutBuilder for responsive layout
  return LayoutBuilder(
    builder: (context, constraints) {
      // Calculate responsive sizes
      double maxWidth = constraints.maxWidth;
      double maxHeight = constraints.maxHeight;
      
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Spacer to push content to vertical center
      
            Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
          margin: EdgeInsets.only(bottom: 24.v),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            "PRESS WHEN THE SOUND CHANGES",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
          Spacer(flex: 1),
          // Audio player component - centered
          Container(
            width: maxWidth * 0.85,
            height: 70,
            margin: EdgeInsets.only(bottom: 50),
            decoration: BoxDecoration(
              color: Color(0xFFF77D2B), // Orange color
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: AudioWidget(
              key: _childKey,
              audioLinks: diffHalf.getVideoUrls(),
            ),
          ),
          
          // Change button - centered
          ScaleTransition(
            scale: _scaleAnimation,
            child: OptionWidget(
              triggerAnimation: _triggerAnimation,
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5E9FE0), Color(0xFF3D7EDB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      _animationController.forward().then((_) => _animationController.reverse());
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.change_circle_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "CHANGE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              isCorrect: () {
                List<double> total_length = _childKey.currentState!.lengths;
                double ans = total_length[0] / (total_length[1] + total_length[0]);
                var condition = _childKey.currentState!.progress.value > ans &&
                    _childKey.currentState!.progress.value < ans + 0.4;

                if (condition) {
                  data_pro.incrementLevel(startExerciseIndex);
                  if (data["completedAt"] == null) {
                    UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateExerciseData(
                      euid: data["uid"],
                      date: data["date"],
                    );
                  }
                }
                
                return condition;
              },
            ),
          ),
          
          // Spacer to push content to vertical center
          Spacer(flex: 1),
        ],
      );
    },
  );
}

  Widget DiffSoundsW(DiffSounds diffSounds, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    return Column(
      children: [
        // Improved audio player
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Container(
            height: 80.v,
            margin: EdgeInsets.symmetric(vertical: 30.v),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: AudioWidget(
                audioLinks: [diffSounds.getVideoUrls()[1]],
              ),
            ),
          ),
        ),
        
        // Button row with improved styling
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.v),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Same button
              _buildResponseButton(
                "SAME",
                Icons.repeat,
                () {
                  var condition = !diffSounds.getSame();
                  if (condition) {
                    data_pro.incrementLevel(startExerciseIndex);
                    if (data["completedAt"] == null) {
                      UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateExerciseData(
                          euid: data["uid"],
                          date: data["date"],
                        );
                    }
                  }
                  return condition;
                },
              ),
              
              // Different button
              _buildResponseButton(
                "DIFFERENT",
                Icons.compare_arrows,
                () {
                  var condition = diffSounds.getSame();
                  if (condition) {
                    data_pro.incrementLevel(startExerciseIndex);
                    if (data["completedAt"] == null) {
                      UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateExerciseData(
                          euid: data["uid"],
                          date: data["date"],
                        );
                    }
                  }
                  return condition;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildResponseButton(
    String label, 
    IconData icon,
    bool Function() isCorrectFn,
  ) {
    return OptionWidget(
      triggerAnimation: _triggerAnimation,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 60.v,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5E9FE0), Color(0xFF3D7EDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              // Button press animation
              _animationController.forward().then((_) => _animationController.reverse());
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8.h),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isCorrect: isCorrectFn,
    );
  }
Widget OddOneW(OddOne oddOne, dynamic dtcontainer) {
  var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
  var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
  int startExerciseIndex = obj[3] as int;
  Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

  // Function to build each audio option
  Widget buildAudioOption(int index) {
    return OptionWidget(
      triggerAnimation: (value) => _triggerAnimation(value),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
        height: 70, // Fixed height for all audio widgets
        decoration: BoxDecoration(
          color: Color(0xFFF77D2B), // Orange color
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: AudioWidget(
          audioLinks: [oddOne.getVideoUrls()[index]],
        ),
      ),
      isCorrect: () {
        var condition = oddOne.getVideoUrls()[index] == oddOne.getCorrectOutput();

        if (condition) {
          data_pro.incrementLevel(startExerciseIndex);
          if (data["completedAt"] == null) {
            UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                .updateExerciseData(
              euid: data["uid"],
              date: data["date"],
            );
          }
        }

        return condition;
      },
    );
  }

  // Using LayoutBuilder for responsive layout
  return LayoutBuilder(
    builder: (context, constraints) {
      // Calculate the number of options and spacing
      int optionCount = oddOne.video_url.length;
      double containerHeight = optionCount * 70 + (optionCount - 1) * 20; // Height for all options + spacing
      double topPadding = (constraints.maxHeight - containerHeight) / 2; // Center vertically
      
      return Column(
        children: [
          // Top padding to push content to vertical center
        Spacer(flex: 1),
          
          // Container for audio options
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                optionCount,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: index < optionCount - 1 ? 20 : 0),
                  child: Center(child: buildAudioOption(index)),
                ),
              ),
            ),
          ),
          Spacer(flex: 1),
        ],
      );
    },
  );
}
}

// Assume AudioWidget class with required functionality exists somewhere in your codebase
// The implementation should match your actual AudioWidget class
class AudioWidgetState extends State<AudioWidget> {
  ValueNotifier<double> progress = ValueNotifier<double>(0.0);
  List<double> lengths = [0.5, 0.5]; // Default mocked lengths
  
  @override
  Widget build(BuildContext context) {
    // This is a placeholder - your actual implementation will be different
    return Container();
  }
}


class ImageWidget extends StatelessWidget {
  final String imagePath;
  
  const ImageWidget({Key? key, required this.imagePath}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}