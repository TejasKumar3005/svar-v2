import 'dart:io';
import 'dart:async'; // Add Timer import
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chiclet/chiclet.dart';
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
import 'package:svar_new/widgets/duolingo_option.dart';

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

  // Session management for story comprehension
  String? _storySessionId;

  // Timer management for auto-play functionality
  Timer? _autoPlayTimer;
  Timer? _sceneAutoTimer;
  Timer? _audioReplayTimer; // New timer for repetitive audio replay
  bool _hasPlayedAudio = false;
  bool _autoPlayEnabled = true;
  String? _currentAudioUrl; // Track current audio URL for replay

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
    // Clean up timers to prevent memory leaks
    _autoPlayTimer?.cancel();
    _sceneAutoTimer?.cancel();
    _audioReplayTimer?.cancel();
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

    // Generate new session ID for story comprehension
    _storySessionId = DateTime.now().millisecondsSinceEpoch.toString();
    print('New story session ID generated: $_storySessionId');

    // Reset auto-play state for new exercise
    _resetAutoPlayState();
    _resetSceneAutoPlayState();

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

  // Auto-play timer management methods
  void _startAutoPlayTimer(VoidCallback audioCallback) {
    if (!_autoPlayEnabled || _hasPlayedAudio) return;

    _autoPlayTimer?.cancel();
    // Play audio immediately on first load (no delay)
    if (mounted && !_hasPlayedAudio) {
      audioCallback();
      setState(() {
        _hasPlayedAudio = true;
      });
    }
  }

  // Modified auto-play for exercises with replay
  void _startAutoPlayWithReplay(String audioUrl) {
    if (!_autoPlayEnabled || _hasPlayedAudio) return;

    _autoPlayTimer?.cancel();
    // Play audio immediately on first load (no delay) and start replay
    if (mounted && !_hasPlayedAudio && audioUrl.isNotEmpty) {
      _playAudioWithReplay(audioUrl);
      setState(() {
        _hasPlayedAudio = true;
      });
    }
  }

  void _cancelAutoPlayTimer() {
    _autoPlayTimer?.cancel();
    setState(() {
      _hasPlayedAudio = true;
    });
  }

  void _resetAutoPlayState() {
    _autoPlayTimer?.cancel();
    _stopAudioReplay(); // Stop any ongoing audio replay
    setState(() {
      _hasPlayedAudio = false;
    });
  }

  // Scene auto-play timer management methods
  void _startSceneAutoPlayTimer(Scene scene, StoryComprehension storyData) {
    _sceneAutoTimer?.cancel();
    // Play audio immediately on first load (no delay) and start replay
    if (mounted && !_hasPlayedAudio && scene.getAudioUrl().isNotEmpty) {
      _playAudioWithReplay(scene.getAudioUrl());
      setState(() {
        _hasPlayedAudio = true;
      });
    }
  }

  void _cancelSceneAutoTimer() {
    _sceneAutoTimer?.cancel();
    setState(() {
      _hasPlayedAudio = false;
    });
  }

  void _resetSceneAutoPlayState() {
    _sceneAutoTimer?.cancel();
    _stopAudioReplay(); // Stop any ongoing audio replay
    setState(() {
      _hasPlayedAudio = false;
    });
  }

  // Audio replay management methods
  void _startAudioReplay(String audioUrl) {
    _currentAudioUrl = audioUrl;
    _audioReplayTimer?.cancel();
    _audioReplayTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted && _currentAudioUrl != null) {
        _player.play(UrlSource(_currentAudioUrl!));
      }
    });
  }

  void _stopAudioReplay() {
    _audioReplayTimer?.cancel();
    _currentAudioUrl = null;
  }

  Future<void> _playAudioWithReplay(String audioUrl) async {
    _stopAudioReplay(); // Stop any existing replay
    await _player.play(UrlSource(audioUrl));
    _startAudioReplay(audioUrl); // Start new replay cycle
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
      var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;

    String type = obj[0] as String;
    print("isCorrect: $isCorrect");
    if (isCorrect) {
      if (_correctTrigger != null) {
        _correctTrigger!.fire();
      }
      setState(() {
        exerciseCompleted = true;
      });

      // Auto-navigate if no more exercises
      if (!hasMoreExercises && type != "StoryComprehension") {
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
                show_switch: false,
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
                              key: type=="StoryComprehension" ? Key(currentQuestionIndex.toString()) : null,
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
    // Start auto-play timer for prompt audio after 5 seconds
    _startAutoPlayWithReplay(data.getPromptAudioUrl());

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
              mainAxisSize: MainAxisSize.min,
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
                // Audio play button - now shows auto-play status
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
              childAspectRatio: 0.9, // Adjusted for larger images
            ),
            itemCount: data.getOptions().length,
            itemBuilder: (context, index) {
              final option = data.getOptions()[index];
              return OptionWidget(
                key: Key(index.toString()),
                triggerAnimation: _triggerAnimation,
                child: ImageWidget(
                  imagePath: option['image_url'] ?? '',
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
    _startAutoPlayWithReplay(data.getPromptAudioUrl());
    // Wh class doesn't have audio, so we skip auto-play for this type

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
                childAspectRatio: 0.9, // Adjusted for larger images
              ),
              itemCount: data.getOptions().length,
              itemBuilder: (context, index) {
                final option = data.getOptions()[index];
                return OptionWidget(
                  triggerAnimation: _triggerAnimation,
                    child: ImageWidget(
                      imagePath: option['image_url'] ?? '',
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
    // Start auto-play timer for input audio after 5 seconds
    _startAutoPlayWithReplay(data.input_audio_url);

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

        

          // Yes/No options
          Row(
            children: [
              Expanded(
                child: OptionWidget(
                  triggerAnimation: _triggerAnimation,
                  child: YesNoButtonWidget(text: "Yes", color: Colors.green),
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
                  child: YesNoButtonWidget(text: "No", color: Colors.red),
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
    // StoryCompletion class doesn't have prompt audio, so we skip auto-play for this type
    _startAutoPlayWithReplay(data.getPromptAudioUrl());
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Story prompt
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.h),
            decoration: BoxDecoration(),
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
              childAspectRatio: 0.8, // Adjusted for larger images
            ),
            itemCount: data.options.length,
            itemBuilder: (context, index) {
              final option = data.options[index];
              return OptionWidget(
                triggerAnimation: _triggerAnimation,
                  child: ImageWidget(
                    imagePath: option['image_url'] ?? '',
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
        // All questions completed - this should not happen now since we navigate back
        // But keep a fallback
        content = Container(
          child: Center(
            child: Text("Questions completed"),
          ),
        );
      }
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: content,
    );
  }

  Widget _buildStoryScene(Scene scene, StoryComprehension storyData) {
    // Start automatic audio playback and scene progression
    _startSceneAutoPlayTimer(scene, storyData);

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
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 174, 179, 98)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  scene.getDescription(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comicNeue(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Audio play button

                    // Next scene button
                    CustomButton(
                      width: 150,
                      type: ButtonType.Next,
                      onPressed: () => _nextScene(storyData),
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
    // Play question audio automatically when question shows with replay
    if (!_hasPlayedAudio && question.getAudioUrl().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _playAudioWithReplay(question.getAudioUrl());
          setState(() {
            _hasPlayedAudio = true;
          });
        }
      });
    }

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
                decoration: BoxDecoration(),
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
                    // Next question button
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
                childAspectRatio: 0.8, // Adjusted for larger images
              ),
              itemCount: question.getOptions().length,
              itemBuilder: (context, index) {
                final option = question.getOptions()[index];
                return OptionWidget(
                  key: Key(question.getText()+ index.toString()),
                  triggerAnimation: (isCorrect) async {
                    _triggerAnimation(isCorrect);
                    if (isCorrect) {
                      await _nextQuestion(storyData);
                    }
                  },
                  child: ImageWidget(
                    imagePath: option['image_url'] ?? '',
                  ),
                  isCorrect: () {
                    bool isCorrect = option['index'] == question.getAnswer();
                    _handleStoryAnswer(isCorrect, storyData);
                    return isCorrect;
                  },
                );
              },
            ),
          ),
        ),
        CustomButton(
          width: 120,
          type: ButtonType.Next,
          onPressed: () => _nextQuestion(storyData),
          child: Text(
            "Next",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _nextScene(StoryComprehension storyData) {
    _stopAudioReplay(); // Stop current audio replay
    setState(() {
      if (currentSceneIndex < 999) {
        // Use a large number since we check in build
        currentSceneIndex++;
        // Reset auto-play state for the new scene
        _hasPlayedAudio = false;
        _sceneAutoTimer?.cancel();
      }
    });
  }

  Future<void> _nextQuestion(StoryComprehension storyData) async {
    _stopAudioReplay(); // Stop current audio replay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      currentQuestionIndex++;
      // Reset audio state for the new question
      _hasPlayedAudio = false;
      if (currentQuestionIndex >= storyData.questions.length) {
        // Instead of showing completion, go back to previous screen
        Navigator.pop(context);
        return;
      }
    });
  }

  void _handleStoryAnswer(bool isCorrect, StoryComprehension storyData) {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];

    if (isCorrect && currentQuestionIndex == storyData.questions.length - 1) {
      data_pro.incrementLevel(currentExerciseIndex);
    }

    // Use the new story comprehension attempt function
    userData
        .updateStoryComprehensionAttempt(
          date: data["date"],
          euid: data["uid"],
          questionIndex: currentQuestionIndex,
          totalQuestions: storyData.questions.length,
          isCorrect: isCorrect,
          sessionId: _storySessionId,
        )
        .then((value) => print("Story comprehension attempt updated"));
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
