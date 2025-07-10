import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:slimy_card_plus/slimy_card.dart';
import 'package:video_player/video_player.dart';

import '../../core/app_export.dart';
import 'exercise_provider.dart';
import '../../database/userController.dart';




class ExerciseCustomNonVideo extends StatefulWidget {
  const ExerciseCustomNonVideo({
    Key? key,
    required this.title,
    required this.description,
    this.contentUrl,               
  }) : super(key: key);

  // ↧ builder now passes contentUrl too
  static Widget builder(BuildContext context) {
    final args   = ModalRoute.of(context)!.settings.arguments as List<dynamic>?;
    if (args == null || args.length < 4) return _errorScreen('Invalid arguments');

    final index     = args[3] as int;
    final dataPro   = Provider.of<ExerciseProvider>(context, listen: false);
    if (index >= dataPro.todaysExercises.length) return _errorScreen('Exercise not found');

    final exercise  = dataPro.todaysExercises[index];

    return ExerciseCustomNonVideo._(
      title:       exercise['title']        ?? 'Exercise',
      description: exercise['description']  ?? '',
      contentUrl:  exercise['content_url'],
    );
  }

  const ExerciseCustomNonVideo._({
    required this.title,
    required this.description,
    this.contentUrl,
    Key? key,
  }) : super(key: key);

  final String  title;
  final String  description;
  final String? contentUrl;       

  // handy little error screen
  static Scaffold _errorScreen(String msg) => Scaffold(
        body: Center(child: Text(msg, style: const TextStyle(fontSize: 18))),
      );

  @override
  State<ExerciseCustomNonVideo> createState() => _ExerciseCustomNonVideoState();
}

class _ExerciseCustomNonVideoState extends State<ExerciseCustomNonVideo> {
  bool? _done; // null → unanswered, true/false → answered
  bool _hasMoreToday = false;
  int _idx = 0;

  VideoPlayerController? _videoCtl;
  ChewieController?      _chewieCtl;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());

    if (widget.contentUrl != null && widget.contentUrl!.isNotEmpty) {
      _videoCtl  = VideoPlayerController.network(widget.contentUrl!)
        ..initialize().then((_) => setState(() {}));
      _chewieCtl = ChewieController(
        videoPlayerController: _videoCtl!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
      );
    }
  }

  @override
  void dispose() {
    _chewieCtl?.dispose();
    _videoCtl?.dispose();
    super.dispose();
  }


  void _init() {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _idx = args[3] as int;

    final dataPro = Provider.of<ExerciseProvider>(context, listen: false);
    _hasMoreToday = _checkMoreForToday(dataPro);
    setState(() {}); // refresh
  }

  bool _checkMoreForToday(ExerciseProvider pro) {
    if (_idx >= pro.todaysExercises.length) return false;
    final date = pro.todaysExercises[_idx]['date'];
    if (date == null) return false;

    // any later exercise of the same date with null completedAt?
    for (var i = _idx + 1; i < pro.todaysExercises.length; i++) {
      final ex = pro.todaysExercises[i];
      if (ex['date'] == date && ex['completedAt'] == null) return true;
    }
    return false;
  }

  // ────────────────────────────────────────────────────────────
  // save result + optional navigation
  // ────────────────────────────────────────────────────────────
  Future<void> _handleResult(bool done) async {
    setState(() => _done = done);

    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final dataPro = Provider.of<ExerciseProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _showSnack('User not logged in', ContentType.failure);
      return;
    }
    int startExerciseIndex = args[3] as int;
    final map = dataPro.todaysExercises[_idx];
    final String uid = map['uid'];
    final String date = map['date'];

    // update Firestore
    try {
      await UserData(uid: currentUser.uid).updateExerciseData(
        euid: uid,
        date: date,
        performance: {
          'completed': true,
          "correct_attempt": done,
          'time': DateTime.now().toString(),
        },
      );

      // update provider locally
      dataPro.incrementLevel(startExerciseIndex);
      debugPrint("data is stored successfully");
    } catch (e) {
      _showSnack('Failed to save: $e', ContentType.failure);
    }

    debugPrint("in the custom non video exercise creation section ");

    // auto pop / next
    if (!_hasMoreToday) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) Navigator.pop(context);
      });
    }


    if (mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.of(context).pop();
      });
    }

  }

  void _showSnack(String msg, ContentType type) {
    final sb = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content:
          AwesomeSnackbarContent(title: 'Info', message: msg, contentType: type),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(sb);
  }

// ─────────────────────────────────────────────────────────────
//  BOTTOM CARD  –  buttons or result
// ─────────────────────────────────────────────────────────────
Widget _buildBottomCard() {
  // BEFORE the user answers
  if (_done == null) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // NOT DONE
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleResult(false),
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text('NOT DONE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                minimumSize: const Size.fromHeight(52), // identical height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // DONE
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _handleResult(true),
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text('DONE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AFTER the user answers
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _done! ? Icons.check_circle : Icons.cancel,
          size: 56,
          color: _done! ? Colors.green : Colors.red,
        ),
        const SizedBox(height: 10),
        Text(
          _done! ? 'Great! Marked as completed.' : 'Marked as not done.',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        if (_hasMoreToday) ...[
          const SizedBox(height: 4),
          Text('Swipe back or tap “Back” to continue',
              style: GoogleFonts.inter(fontSize: 14)),
        ],
      ],
    ),
  );
}

@override
Widget build(BuildContext context) {
  const double kSectionGap = 12;      
  final hasVideo = widget.contentUrl != null && widget.contentUrl!.isNotEmpty;

  return Scaffold(
    backgroundColor: const Color(0xFFE3F2FD),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── title ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kSectionGap),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              // ── video (only if present) ─────────────────────────────
              if (hasVideo && _videoCtl?.value.isInitialized == true) ...[
                AspectRatio(
                  // keeps the video full width but correctly scaled
                  aspectRatio: _videoCtl!.value.aspectRatio,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Chewie(controller: _chewieCtl!),
                  ),
                ),
                const SizedBox(height: kSectionGap),
              ],

              // ── description ────────────────────────────────────────
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(.06),
                      ),
                    ],
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    radius: const Radius.circular(8),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 1.55,
                            color: const Color(0xFF2B2B2B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: kSectionGap),

              // ── bottom bar / result ────────────────────────────────
              _buildBottomCard(),
            ],
          ),
        ),
      ),
    ),
  );
}
}