// import 'dart:html';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:svar_new/widgets/custom_button.dart';

class TipBoxVideoScreen extends StatefulWidget {

   TipBoxVideoScreen({Key? key})
      : super(
          key: key,
        );

  @override
  TipBoxVideoScreenState createState() => TipBoxVideoScreenState();

  static Widget builder(BuildContext context) {
    
    return TipBoxVideoScreen();
  }
}

class TipBoxVideoScreenState extends State<TipBoxVideoScreen> {
    late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _showPlayButton = false;


  @override
  void initState() {
    super.initState();

      void stop() async {
    await PlayBgm().stopMusic();
    }
    
    stop();
    var prov=Provider.of<LingLearningProvider>(context,listen: false);

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse( "https://images.svar.in/phonemes/${PhonmesListModel().addedPhonemes.contains(PhonmesListModel().hindiToEnglishPhonemeMap[prov.selectedCharacter]) ?PhonmesListModel().hindiToEnglishPhonemeMap[prov.selectedCharacter]:"B"}.mp4"))
      ..initialize().then((_) {
        setState(() {});
      });
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        Navigator.pop(context, true);
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      _showPlayButton = false;
    });
  }

  void _onTap() {
    setState(() {
      _showPlayButton = !_showPlayButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userprovider = context.watch<UserDataProvider>();

    var levelprovider = context.watch<LingLearningProvider>();
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/tip_vdo.png"),
                fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Text(
                "msg_parental_tip_box".tr,
                style: CustomTextStyles.headlineLargeBlack,
              ),
              SizedBox(height: 12.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 10.v),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
        onTap: _onTap,
        child: _videoPlayerController.value.isInitialized
            ? SizedBox(
              height: 219.v,
                width: MediaQuery.of(context).size.width * 0.50,
              child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Center(child: Chewie(controller: _chewieController!)),
                ),
            )
            : Center(child: CircularProgressIndicator()),
      ),
                    Container(
                      height: 219.v,
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Center(
                        child: Text(
                          '''To teach the "P" sound, tell your child to gently press their lips together and release them with a small burst of air, like they're "popping a bubble." Make sure no voice or humming is used—it's just the lips and air. Encourage them to exaggerate the "pop" to practice!''',
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.titleMediumNunitoSansTeal900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.v)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
      
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.v),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 1.h),
              child: CustomButton(
                  type: ButtonType.Back,
                  onPressed: () {
                    NavigatorService.goBack();
                  }),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 1.h),
              child: CustomButton(type: ButtonType.Replay, onPressed: () {}),
            ),
            SizedBox(width: 5),
            Padding(
              padding: EdgeInsets.only(left: 1.h),
              child:
                  CustomButton(type: ButtonType.FullVolume, onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }


}
