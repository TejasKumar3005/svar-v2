import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/exercises/identification_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/database/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/widgets/image_option.dart';
import 'package:svar_new/widgets/text_option.dart';

class ExerciseComprehension extends StatefulWidget {
  const ExerciseComprehension({Key? key}) : super(key: key);

  @override
  ExerciseComprehensionState createState() => ExerciseComprehensionState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IdentificationProvider(),
      child: ExerciseComprehension(),
    );
  }
}

class ExerciseComprehensionState extends State<ExerciseComprehension> {
  late AudioPlayer _player;
  late UserData userData;

  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;

  // Exercise state management
  bool exerciseCompleted = false;
  bool hasMoreExercises = false;
  int currentExerciseIndex = 0;

  // Story comprehension state
  int currentSceneIndex = 0;
  int currentQuestionIndex = 0;
  bool showingStory = true; // true for scenes, false for questions

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Set orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _player = AudioPlayer();

    // Initialize userData
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    currentExerciseIndex = obj[3] as int;

    // Check if there are more exercises
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    _checkForMoreExercises(data_pro);
  }

  void _checkForMoreExercises(ExerciseProvider data_pro) {
    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Filter exercises for the same date
    List<Map<String, dynamic>> sameDateExercises = data_pro.todaysExercises
        .where((exercise) => exercise['date'] == exerciseDate)
        .toList();

    // Find current exercise position in same date list
    int currentIndexInSameDateExercises = sameDateExercises.indexWhere(
        (exercise) =>
            data_pro.todaysExercises.indexOf(exercise) == currentExerciseIndex);

    if (currentIndexInSameDateExercises != -1) {
      // Check if any exercises after current one are incomplete
      hasMoreExercises = sameDateExercises
          .skip(currentIndexInSameDateExercises + 1)
          .any((exercise) => exercise['completedAt'] == null);
    }

    print("Has more exercises for this date: $hasMoreExercises");
  }

  void _onRiveInit(Artboard artboard) async {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 2');

    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;

      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;
    }
  }

  void _triggerAnimation(bool isCorrect) {
    print("isCorrect: $isCorrect");
    if (isCorrect) {
      if (_correctTrigger != null) {
        _correctTrigger!.fire();
      }
      setState(() {
        exerciseCompleted = true;
      });

      // Auto-navigate if no more exercises
      if (!hasMoreExercises) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && exerciseCompleted) {
            Navigator.pop(context);
          }
        });
      }
    } else {
      print("Incorrect");
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<IdentificationProvider>();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;

    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    String params = obj[2] as String;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: appTheme.gray300,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // Replace gradient with background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/quiz_bg.jpeg'), // Update with your actual image path
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 30.0, bottom: 20),
          child: Column(
            children: [
              // Custom app bar without parent mode
              DisciAppBar(
                context,
                parent_mode: false,
                onParentModeChanged: (value) {},
              ),

              // Exercise content
              Expanded(
                  child: Stack(
                children: [
                  Container(
                  
                    child: _buildExerciseContent(
                      context,
                      provider,
                      type,
                      dtcontainer,
                      params,
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: IgnorePointer(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: RiveAnimation.asset(
                              'assets/rive/Celebration_animation.riv',
                              onInit: _onRiveInit,
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                        ),
                      ),
                      if (exerciseCompleted && hasMoreExercises)
                        Positioned(
                          bottom: MediaQuery.of(context).size.height * 0.03,
                          right: 20,
                          child: AnimatedScale(
                              scale: 1,
                              duration: Duration(milliseconds: 500),
                              child: CustomButton(
                                  width: 150,
                                  child: Text(
                                    "Next",
                                    style: GoogleFonts.inter(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  type: ButtonType.Next,
                                  onPressed: _moveToNextExercise)),
                        ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseContent(
    BuildContext context,
    IdentificationProvider provider,
    String type,
    dynamic dtcontainer,
    String params,
  ) {
    switch (type) {
      case "PictureMatchingComprehension":
        return _buildPictureMatchingComprehension(dtcontainer);
      case "Wh":
        return _buildWhComprehension(dtcontainer);
      case "YesNoComprehension":
        return _buildYesNoComprehension(dtcontainer);
      case "StoryCompletion":
        return _buildStoryCompletion(dtcontainer);
      case "StoryComprehension":
        return _buildStoryComprehension(dtcontainer);
      default:
        return Center(
          child: Text(
            "Exercise type not supported: $type",
            style: GoogleFonts.inter(fontSize: 18, color: Colors.white),
          ),
        );
    }
  }

  Widget _buildPictureMatchingComprehension(PictureMatchingComprehension data) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Instruction text
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
            
              borderRadius: BorderRadius.circular(16),
            
            ),
            child: Column(
              children: [
                Text(
                  data.getPrompt(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 16.v),
                // Audio play button
                CustomButton(
                  width: 150,
                  type: ButtonType.Play,
                  onPressed: () async {
                    await _player.play(UrlSource(data.getPromptAudioUrl()));
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 32.v),

          // Options grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.h,
              mainAxisSpacing: 16.v,
              childAspectRatio: 0.8,
            ),
            itemCount: data.getOptions().length,
            itemBuilder: (context, index) {
              final option = data.getOptions()[index];
              return OptionWidget(
                key: Key(index.toString()),
                triggerAnimation: _triggerAnimation,
                child: _buildDuolingoOption(
                  imageUrl: option['image_url'] ?? '',
                  text: option['text'] ?? '',
                ),
                isCorrect: () {
                  print("index: $index");
                  bool isCorrect = index == data.getCorrect();
                  _handleAnswer(isCorrect);
                  return isCorrect;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWhComprehension(Wh data) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Question prompt
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              data.getPrompt(),
              textAlign: TextAlign.center,
              style: GoogleFonts.comicNeue(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),

          SizedBox(height: 32.v),

          // Options in 2x2 grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.h,
                mainAxisSpacing: 16.v,
                childAspectRatio:
                    0.8, // Increased height for better text visibility
              ),
              itemCount: data.getOptions().length,
              itemBuilder: (context, index) {
                final option = data.getOptions()[index];
                return OptionWidget(
                  triggerAnimation: _triggerAnimation,
                  child: _buildDuolingoOption(
                    imageUrl: option['image_url'] ?? '',
                    text: option['text'] ?? '',
                    isFullWidth: false, // Grid items don't need full width
                  ),
                  isCorrect: () {
                    bool isCorrect = index == data.getCorrect();
                    _handleAnswer(isCorrect);
                    return isCorrect;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYesNoComprehension(YesNoComprehension data) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Main prompt
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  data.getPrompt(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(height: 16.v),
                CustomButton(
                  type: ButtonType.Play,
                  onPressed: () async {
                    await _player.play(UrlSource(data.input_audio_url));
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 24.v),

          // Output image if available
          if (data.output_image_url.isNotEmpty)
            Container(
              height: 200.v,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 24.v),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomImageView(
                  imagePath: data.output_image_url,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // Output prompt
          if (data.output_prompt.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.h),
              margin: EdgeInsets.only(bottom: 24.v),
              decoration: BoxDecoration(
                color: Color(0xFFF3E5F5).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    data.output_prompt,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comicNeue(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  if (data.output_audio_url.isNotEmpty) ...[
                    SizedBox(height: 12.v),
                    CustomButton(
                      type: ButtonType.Play,
                      onPressed: () async {
                        await _player.play(UrlSource(data.output_audio_url));
                      },
                    ),
                  ],
                ],
              ),
            ),

          // Yes/No options
          Row(
            children: [
              Expanded(
                child: OptionWidget(
                  triggerAnimation: _triggerAnimation,
                  child: _buildYesNoButton("Yes", Colors.green),
                  isCorrect: () {
                    bool isCorrect = data.getCorrect().toLowerCase() == "yes";
                    _handleAnswer(isCorrect);
                    return isCorrect;
                  },
                ),
              ),
              SizedBox(width: 16.h),
              Expanded(
                child: OptionWidget(
                  triggerAnimation: _triggerAnimation,
                  child: _buildYesNoButton("No", Colors.red),
                  isCorrect: () {
                    bool isCorrect = data.getCorrect().toLowerCase() == "no";
                    _handleAnswer(isCorrect);
                    return isCorrect;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCompletion(StoryCompletion data) {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Story prompt
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              data.getPrompt(),
              textAlign: TextAlign.center,
              style: GoogleFonts.comicNeue(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: 32.v),

          // Story completion options
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.h,
              mainAxisSpacing: 16.v,
              childAspectRatio: 0.7,
            ),
            itemCount: data.options.length,
            itemBuilder: (context, index) {
              final option = data.options[index];
              return OptionWidget(
                triggerAnimation: _triggerAnimation,
                child: _buildStoryOption(
                  imageUrl: option['image_url'] ?? '',
                  text: option['text'] ?? '',
                  audioUrl: option['audio_url'] ?? '',
                ),
                isCorrect: () {
                  bool isCorrect = index == data.getCorrect();
                  _handleAnswer(isCorrect);
                  return isCorrect;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryComprehension(StoryComprehension data) {
    Widget content;

    if (showingStory) {
      // Show scenes one by one
      if (currentSceneIndex < data.scenes.length) {
        content = _buildStoryScene(data.scenes[currentSceneIndex], data);
      } else {
        // All scenes shown, start questions
        showingStory = false;
        currentQuestionIndex = 0;
        content =
            _buildStoryQuestion(data.questions[currentQuestionIndex], data);
      }
    } else {
      // Show questions one by one
      if (currentQuestionIndex < data.questions.length) {
        content =
            _buildStoryQuestion(data.questions[currentQuestionIndex], data);
      } else {
        // All questions completed
        content = _buildStoryCompleted();
      }
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: content,
    );
  }

  Widget _buildStoryScene(Scene scene, StoryComprehension storyData) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Story progress indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Story: ${currentSceneIndex + 1} of ${storyData.scenes.length}",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),

          SizedBox(height: 24.v),

          // Scene image
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomImageView(
                imagePath: scene.image_url,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 24.v),

          // Scene description
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  scene.getDescription(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Audio play button
                    CustomButton(
                      type: ButtonType.Play,
                      onPressed: () async {
                        await _player.play(UrlSource(scene.getAudioUrl()));
                      },
                    ),
                    SizedBox(width: 20.h),
                    // Next scene button
                    CustomButton(
                      type: ButtonType.Next,
                      onPressed: _nextScene,
                      child: Text(
                        currentSceneIndex == storyData.scenes.length - 1
                            ? "Start Questions"
                            : "Next",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryQuestion(Question question, StoryComprehension storyData) {
    return Column(
      children: [
        // Fixed header section
        Container(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Question progress indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Question: ${currentQuestionIndex + 1} of ${storyData.questions.length}",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),

              SizedBox(height: 24.v),

              // Question text and audio
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      question.getText(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comicNeue(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 16.v),
                    CustomButton(
                      type: ButtonType.Play,
                      onPressed: () async {
                        await _player.play(UrlSource(question.getAudioUrl()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Scrollable options section
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: GridView.builder(
              padding: EdgeInsets.only(top: 16.v, bottom: 16.v),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.h,
                mainAxisSpacing: 16.v,
                childAspectRatio: 0.7,
              ),
              itemCount: question.getOptions().length,
              itemBuilder: (context, index) {
                final option = question.getOptions()[index];
                return OptionWidget(
                  triggerAnimation: (isCorrect) {
                    if (isCorrect) {
                      _nextQuestion(storyData);
                    }
                  },
                  child: _buildStoryQuestionOption(
                    imageUrl: option['image_url'] ?? '',
                    text: option['text'] ?? '',
                    audioUrl: option['audio_url'] ?? '',
                  ),
                  isCorrect: () {
                    bool isCorrect = option['text'] == question.getAnswer();
                    _handleStoryAnswer(isCorrect, storyData);
                    return isCorrect;
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryQuestionOption({
    required String imageUrl,
    required String text,
    required String audioUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE0E0E0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (imageUrl.isNotEmpty) ...[
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: CustomImageView(
                        imagePath: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (audioUrl.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          await _player.play(UrlSource(audioUrl));
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (text.isNotEmpty) ...[
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: imageUrl.isNotEmpty
                      ? BorderRadius.vertical(bottom: Radius.circular(16))
                      : BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212529),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoryCompleted() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16.v),
                  Text(
                    "Story Completed!",
                    style: GoogleFonts.comicNeue(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  SizedBox(height: 8.v),
                  Text(
                    "Great job understanding the story!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.v),
            if (hasMoreExercises)
              CustomButton(
                type: ButtonType.Next,
                onPressed: _moveToNextExercise,
                child: Text(
                  "Next Exercise",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              CustomButton(
                type: ButtonType.Home,
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Finish",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _nextScene() {
    setState(() {
      if (currentSceneIndex < 999) {
        // Use a large number since we check in build
        currentSceneIndex++;
      }
    });
  }

  void _nextQuestion(StoryComprehension storyData) {
    setState(() {
      currentQuestionIndex++;
      if (currentQuestionIndex >= storyData.questions.length) {
        exerciseCompleted = true;
      }
    });
  }

  void _handleStoryAnswer(bool isCorrect, StoryComprehension storyData) {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];

    if (isCorrect) {
      data_pro.incrementLevel(currentExerciseIndex);
    }

    UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
      euid: data["uid"],
      date: data["date"],
      performance: {
        "correct_attempt": isCorrect,
        "time": DateTime.now().toString(),
        "question_index": currentQuestionIndex,
        "total_questions": storyData.questions.length,
      },
    ).then((value) => print("Story exercise data updated"));
  }

  Widget _buildDuolingoOption({
    required String imageUrl,
    required String text,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE0E0E0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (imageUrl.isNotEmpty) ...[
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  child: CustomImageView(
                    imagePath: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          if (text.isNotEmpty) ...[
            Expanded(
              flex: imageUrl.isNotEmpty
                  ? 3
                  : 1, // Increased flex for more text space
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.v),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: imageUrl.isNotEmpty
                      ? BorderRadius.vertical(bottom: Radius.circular(14))
                      : BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212529),
                      height: 1.2, // Better line height for readability
                    ),
                    maxLines: 3, // Allow up to 3 lines of text
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildYesNoButton(String text, Color color) {
    return Container(
      height: 60.v,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildStoryOption({
    required String imageUrl,
    required String text,
    required String audioUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE0E0E0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (imageUrl.isNotEmpty) ...[
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: CustomImageView(
                        imagePath: imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (audioUrl.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          await _player.play(UrlSource(audioUrl));
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (text.isNotEmpty) ...[
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: imageUrl.isNotEmpty
                      ? BorderRadius.vertical(bottom: Radius.circular(16))
                      : BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212529),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleAnswer(bool isCorrect) {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];

    if (isCorrect) {
      data_pro.incrementLevel(currentExerciseIndex);
    }

    UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
      euid: data["uid"],
      date: data["date"],
      performance: {
        "correct_attempt": isCorrect,
        "time": DateTime.now().toString(),
      },
    ).then((value) => print("Exercise data updated"));
  }

  void _moveToNextExercise() {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Find next incomplete exercise for the same date
    int nextExerciseIndex = -1;
    for (int i = currentExerciseIndex + 1;
        i < data_pro.todaysExercises.length;
        i++) {
      if (data_pro.todaysExercises[i]['date'] == exerciseDate &&
          data_pro.todaysExercises[i]['completedAt'] == null) {
        nextExerciseIndex = i;
        break;
      }
    }

    if (nextExerciseIndex != -1) {
      Map<String, dynamic> nextExercise =
          data_pro.todaysExercises[nextExerciseIndex];
      String exerciseType = nextExercise["exerciseType"];

      Navigator.pop(context);

      // Use the centralized navigation function
      navigateToExerciseType(exerciseType, nextExerciseIndex, context);
    } else {
      Navigator.pop(context);
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
