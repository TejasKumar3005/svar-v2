
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/app_export.dart'; // Make sure this import is correct
// Make sure this import is correct
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart'; // Make sure this import is correct
import 'package:svar_new/widgets/custom_button.dart'; // Make sure this import is correct
import 'package:rive/rive.dart';
import 'package:video_player/video_player.dart';


class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  LoginSignUpScreenState createState() => LoginSignUpScreenState();

  static Widget builder(BuildContext context) {
    return LoginSignUpScreen();
  }
}

class LoginSignUpScreenState extends State<LoginSignUpScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false; // Track video initialization

  // List of taglines to display in the PageView
  final List<String> _taglines = [
    "The fun, easy and effective way to train your kid!",
    "Learn and practice speech in an engaging way!",
    "Build confidence through interactive speech exercises!",
    "Make speech practice enjoyable with Svar!"
  ];

  // PageController for the tagline PageView
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _pageController = PageController(initialPage: 0);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController =
          VideoPlayerController.asset('assets/video/bgg_animation.mp4');
      await _videoController.initialize();
      setState(() {
        _isVideoInitialized = true;
        _videoController.play();
        _videoController.setLooping(true);
      });
    } catch (e) {
      print('Error initializing video: $e');
      // Handle error, e.g., show an error message to the user
      setState(() {
        _isVideoInitialized = false; // Video init failed
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          showQuitDialog(context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomSheet: _buildBottomButton(),
          body: _buildPage(screenWidth, screenHeight,
              topWidget: _buildLogo(screenWidth, screenHeight),
              bottomWidget: _buildTagline()),
        ),
      ),
    );
  }

  Widget _buildPage(double screenWidth, double screenHeight,
      {required Widget topWidget, required Widget bottomWidget}) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          Spacer(flex: 1),
          topWidget,
          Spacer(flex: 1),
          // Mascot animation centered in the same position on both pages
          Container(
            width: screenWidth,
            height: screenHeight * 0.6,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.5,
                    child: RiveAnimation.asset(
                      'assets/rive/mascot-rig-final.riv',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 10,
                  child: Transform.rotate(
                    angle: -0.1,
                    child: _buildIntroHeader(),
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 1),
          bottomWidget,
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildLogo(double screenWidth, double screenHeight) {
    return CustomImageView(
      width: screenWidth * 0.4,
      height: screenHeight * 0.1,
      fit: BoxFit.contain,
      imagePath: ImageConstant.imgSvaLogo1,
    );
  }

  Widget _buildIntroHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color.fromARGB(255, 197, 196, 196), width: 2),
      ),
      child: Text(
        "Hi! I'm Svar!",
        style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 104, 103, 103)),
      ),
    );
  }

  Widget _buildTagline() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 80, // Fixed height to prevent layout shifts
            child: PageView.builder(
              controller: _pageController,
              itemCount: _taglines.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Text(
                  _taglines[index],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          // Navigation dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _taglines.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? appTheme.deepOrange400
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    // Completely rebuild the button instead of switching its type
    if (_currentPage == _taglines.length - 1) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          type: ButtonType.CreateAccount,
          onPressed: () {
            print("Create Account clicked, _currentPage: $_currentPage");
            Navigator.of(context).pushNamed(AppRoutes.login);
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          type: ButtonType.Next,
          onPressed: () {
            if(_currentPage==3){
              Navigator.of(context).pushNamed(AppRoutes.login);
            }else{
              print("Next clicked, _currentPage: $_currentPage");
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            }
            
          },
        ),
      );
    }
  }
}
