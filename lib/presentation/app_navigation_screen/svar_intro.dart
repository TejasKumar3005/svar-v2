import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_button.dart';

class MascotIntro extends StatefulWidget {
  const MascotIntro({super.key});

  @override
  State<MascotIntro> createState() => _MascotIntroState();
  static Widget builder(BuildContext context) {
    return MascotIntro();
  }
}

class _MascotIntroState extends State<MascotIntro> {


  @override
  void dispose() {
  
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                  type: ButtonType.Continue,
                  onPressed: () {
                  
                  Navigator.of(context).pushNamed(AppRoutes.loginSignup);
                  }),
            ),
        

      body:   _buildPage(screenWidth, screenHeight,
              topWidget: _buildIntroHeader(), bottomWidget: Container()),
    );
  }

  Widget _buildPage(double screenWidth, double screenHeight,
      {required Widget topWidget, required Widget bottomWidget}) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          Spacer(flex: 1),
          topWidget,
          Spacer(flex: 1),
          // Mascot animation centered in the same position on both pages
          Hero(
            tag: 'mascot-rig-final',
            child: SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              child: RiveAnimation.asset(
                'assets/rive/mascot-rig-final.riv',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Spacer(flex: 1),
          bottomWidget,
          Spacer(flex: 2),
        ],
      ),
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

  
}
