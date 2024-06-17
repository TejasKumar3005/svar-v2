import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/presentation/phenoms_level_screen_one/video_player_screen.dart';
import 'provider/phonems_level_screen_one_provider.dart';
import 'package:svar_new/widgets/custom_level_map/level_map.dart';

class PhonemsLevelScreenOneScreen extends StatefulWidget {
  PhonemsLevelScreenOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  PhonemsLevelScreenOneScreenState createState() =>
      PhonemsLevelScreenOneScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        PhonemsLevelScreenOneProvider();
      },
      child: PhonemsLevelScreenOneScreen(),
    );
  }
}

class PhonemsLevelScreenOneScreenState
    extends State<PhonemsLevelScreenOneScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? val = ModalRoute.of(context)!.settings.arguments;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.47, 0.06),
              end: Alignment(0.59, 1.61),
              colors: [
                appTheme.lightGreen400,
                appTheme.teal800,
              ],
            ),
          ),

          child: LevelMap(
              levelMapParams: LevelMapParams(
            levelCount: 10,
            currentLevel: 3,
            enableVariationBetweenCurves: true,

            pathColor: appTheme.amber90001,
            shadowColor: appTheme.brown100,
            currentLevelImage: ImageParams(
              path: "assets/images/Current_LVL.png",
              size: Size(104.v, 104.h),
              onTap: (int level) {
                // taking level count from here and everything will be handled in AuditoryScreen class
                if (val == 0) {
                  debugPrint("auditory");
                  _handleAuditory(context, level);
                } else if (val == 1) {
                  debugPrint("in quizes level");
                  _handleLevel(context, level);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Center(
                                child: Text("data"),
                              )));
                }
              },
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/Locked_LVL.png",
              size: Size(104.v, 104.h),
              onTap: (int level) {
                if (val as int == 0) {
                  debugPrint("auditory");
                  _handleAuditory(context, level);
                } else if (val == 1) {
                  debugPrint("in quizes level");
                  _handleLevel(context, level);
                } else {
                  debugPrint("error zone");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Text("data")));
                }
              },
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/Complete_LVL.png",
              size: Size(104.v, 104.h),
              onTap: (int level) {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => AuditoryScreen(
                //               level: level,
                //             )));
                if (val == 0) {
                  debugPrint("auditory");
                  _handleAuditory(context, level);
                } else if (val as int == 1) {
                  debugPrint("in quizes level");
                  _handleLevel(context, level);
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Text("data")));
                }
              },
            ),
            // pathEndImage: ImageParams(
            //   path: "assets/images/img_closed_level_marker.png",
            //   size: Size(60, 60),
            // ),
            dashLengthFactor: 0.01,
            pathStrokeWidth: 10.h,
            bgImagesToBePaintedRandomly: [
              ImageParams(
                  path: "assets/images/img_bush.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.5),
              ImageParams(
                path: "assets/images/img_tree.png",
                size: Size(80, 80),
                repeatCountPerLevel: 0.5,
              )
            ],
            // ),
          )),
          //   child: SizedBox(
          //     height: 432.v,
          //     width: 768.h,
          //     child: Stack(
          //       alignment: Alignment.center,
          //       children: [
          //         Align(
          //           alignment: Alignment.center,
          //           child: Container(
          //             height: 432.v,
          //             width: 768.h,
          //             padding: EdgeInsets.only(
          //               top: 65.v,
          //               right: 277.h,
          //             ),
          //             child: Stack(
          //               alignment: Alignment.topRight,
          //               children: [
          //                 Align(
          //                   alignment: Alignment.topRight,
          //                   child: Container(
          //                     height: 12.v,
          //                     width: 27.h,
          //                     margin: EdgeInsets.only(
          //                       top: 32.v,
          //                       right: 48.h,
          //                     ),
          //                     decoration: BoxDecoration(
          //                       color: appTheme.lime90001,
          //                     ),
          //                   ),
          //                 ),
          //                 CustomImageView(
          //                   imagePath: ImageConstant.imgImage83,
          //                   height: 44.v,
          //                   width: 56.h,
          //                   radius: BorderRadius.circular(
          //                     8.h,
          //                   ),
          //                   alignment: Alignment.topRight,
          //                   margin: EdgeInsets.only(top: 7.v),
          //                 ),
          //                 Align(
          //                   alignment: Alignment.topRight,
          //                   child: Padding(
          //                     padding: EdgeInsets.only(right: 16.h),
          //                     child: Text(
          //                       "lbl_6".tr,
          //                       style: theme.textTheme.displayMedium,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Container(
          //             height: 432.v,
          //             width: 768.h,
          //             padding: EdgeInsets.only(
          //               left: 162.h,
          //               top: 143.v,
          //             ),
          //             child: Stack(
          //               alignment: Alignment.topLeft,
          //               children: [
          //                 Align(
          //                   alignment: Alignment.topLeft,
          //                   child: Container(
          //                     height: 12.v,
          //                     width: 20.h,
          //                     margin: EdgeInsets.only(
          //                       left: 53.h,
          //                       top: 9.v,
          //                     ),
          //                     decoration: BoxDecoration(
          //                       color: appTheme.lime90001,
          //                     ),
          //                   ),
          //                 ),
          //                 CustomImageView(
          //                   imagePath: ImageConstant.imgImage83,
          //                   height: 44.v,
          //                   width: 56.h,
          //                   radius: BorderRadius.circular(
          //                     8.h,
          //                   ),
          //                   alignment: Alignment.topLeft,
          //                   margin: EdgeInsets.only(top: 5.v),
          //                 ),
          //                 Align(
          //                   alignment: Alignment.topLeft,
          //                   child: Padding(
          //                     padding: EdgeInsets.only(left: 12.h),
          //                     child: Text(
          //                       "lbl_5".tr,
          //                       style: theme.textTheme.displayMedium,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Container(
          //             height: 432.v,
          //             width: 768.h,
          //             padding: EdgeInsets.only(
          //               top: 181.v,
          //               right: 142.h,
          //               bottom: 181.v,
          //             ),
          //             child: Stack(
          //               alignment: Alignment.bottomRight,
          //               children: [
          //                 Align(
          //                   alignment: Alignment.topRight,
          //                   child: Container(
          //                     height: 12.v,
          //                     width: 30.h,
          //                     margin: EdgeInsets.only(
          //                       top: 24.v,
          //                       right: 54.h,
          //                     ),
          //                     decoration: BoxDecoration(
          //                       color: appTheme.lime90001,
          //                     ),
          //                   ),
          //                 ),
          //                 CustomImageView(
          //                   imagePath: ImageConstant.imgImage83,
          //                   height: 44.v,
          //                   width: 56.h,
          //                   radius: BorderRadius.circular(
          //                     8.h,
          //                   ),
          //                   alignment: Alignment.bottomRight,
          //                   margin: EdgeInsets.only(bottom: 10.v),
          //                 ),
          //                 Align(
          //                   alignment: Alignment.bottomRight,
          //                   child: Padding(
          //                     padding: EdgeInsets.only(right: 17.h),
          //                     child: Text(
          //                       "lbl_4".tr,
          //                       style: theme.textTheme.displaySmall,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Container(
          //             height: 432.v,
          //             width: 768.h,
          //             padding: EdgeInsets.only(
          //               left: 260.h,
          //               bottom: 106.v,
          //             ),
          //             child: Stack(
          //               alignment: Alignment.bottomLeft,
          //               children: [
          //                 Align(
          //                   alignment: Alignment.bottomLeft,
          //                   child: Container(
          //                     height: 12.v,
          //                     width: 18.h,
          //                     margin: EdgeInsets.only(
          //                       left: 53.h,
          //                       bottom: 39.v,
          //                     ),
          //                     decoration: BoxDecoration(
          //                       color: appTheme.lime90001,
          //                     ),
          //                   ),
          //                 ),
          //                 CustomImageView(
          //                   imagePath: ImageConstant.imgImage83,
          //                   height: 44.v,
          //                   width: 56.h,
          //                   radius: BorderRadius.circular(
          //                     8.h,
          //                   ),
          //                   alignment: Alignment.bottomLeft,
          //                   margin: EdgeInsets.only(bottom: 13.v),
          //                 ),
          //                 Align(
          //                   alignment: Alignment.bottomLeft,
          //                   child: Padding(
          //                     padding: EdgeInsets.only(left: 14.h),
          //                     child: Text(
          //                       "lbl_32".tr,
          //                       style: theme.textTheme.displayMedium,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Container(
          //             height: 432.v,
          //             width: 768.h,
          //             padding: EdgeInsets.only(
          //               top: 43.v,
          //               right: 175.h,
          //               bottom: 43.v,
          //             ),
          //             child: Stack(
          //               alignment: Alignment.bottomRight,
          //               children: [
          //                 Align(
          //                   alignment: Alignment.bottomRight,
          //                   child: Container(
          //                     height: 12.v,
          //                     width: 28.h,
          //                     margin: EdgeInsets.only(
          //                       right: 50.h,
          //                       bottom: 37.v,
          //                     ),
          //                     decoration: BoxDecoration(
          //                       color: appTheme.lime90001,
          //                     ),
          //                   ),
          //                 ),
          //                 CustomImageView(
          //                   imagePath: ImageConstant.imgImage83,
          //                   height: 44.v,
          //                   width: 56.h,
          //                   radius: BorderRadius.circular(
          //                     8.h,
          //                   ),
          //                   alignment: Alignment.bottomRight,
          //                   margin: EdgeInsets.only(bottom: 11.v),
          //                 ),
          //                 Align(
          //                   alignment: Alignment.bottomRight,
          //                   child: Padding(
          //                     padding: EdgeInsets.only(right: 9.h),
          //                     child: Text(
          //                       "lbl_2".tr,
          //                       style: theme.textTheme.displayMedium,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Container(
          //             height: 432.v,
          //             width: 768.h,
          //             padding: EdgeInsets.only(left: 122.h),
          //             child: Stack(
          //               alignment: Alignment.bottomLeft,
          //               children: [
          //                 Align(
          //                   alignment: Alignment.bottomLeft,
          //                   child: Container(
          //                     height: 12.v,
          //                     width: 24.h,
          //                     margin: EdgeInsets.only(
          //                       left: 52.h,
          //                       bottom: 35.v,
          //                     ),
          //                     decoration: BoxDecoration(
          //                       color: appTheme.lime90001,
          //                     ),
          //                   ),
          //                 ),
          //                 CustomImageView(
          //                   imagePath: ImageConstant.imgImage83,
          //                   height: 44.v,
          //                   width: 56.h,
          //                   radius: BorderRadius.circular(
          //                     8.h,
          //                   ),
          //                   alignment: Alignment.bottomLeft,
          //                   margin: EdgeInsets.only(bottom: 7.v),
          //                 ),
          //                 Align(
          //                   alignment: Alignment.bottomLeft,
          //                   child: Padding(
          //                     padding: EdgeInsets.only(left: 15.h),
          //                     child: Text(
          //                       "lbl_1".tr,
          //                       style: theme.textTheme.displayMedium,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         CustomImageView(
          //           imagePath: ImageConstant.imgTreesAndRocks,
          //           height: 380.v,
          //           width: 735.h,
          //           alignment: Alignment.bottomCenter,
          //           margin: EdgeInsets.only(bottom: 12.v),
          //         ),
          //         CustomImageView(
          //           imagePath: ImageConstant.imgSnakePath,
          //           height: 432.v,
          //           width: 350.h,
          //           alignment: Alignment.centerLeft,
          //           margin: EdgeInsets.only(left: 191.h),
          //         ),
          //       ],
          //     ),
          //   ),
        ),
      ),
    );
  }

  void _handleLevel(BuildContext context, int level) async {
    try {
      debugPrint("entering in level section");
      final levelProvider =
          Provider.of<PhonemsLevelScreenOneProvider>(context, listen: false);
      final String type;
      debugPrint("data fetching");
      final Map<String, dynamic>? data =
          await levelProvider.fetchData(1, level);
      type = data!["type"];
      if (type == "video") {
        debugPrint("in video setion");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoUrl: data["video"])),
        );
      } else {
        final Object dtcontainer;
        dtcontainer = retrieveObject(type, data);
        debugPrint("data is ");
        debugPrint(data.toString());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           // StaticAuditoryScreen(type: type, dtcontainer: dtcontainer),
        //           AuditoryScreenAssessmentScreenVisualAudioResizScreen(
        //             type: type,
        //             dtcontainer: dtcontainer,
        //           )),
        // );
        List<dynamic> lis = [type, dtcontainer];
        NavigatorService.pushNamed(
            AppRoutes.auditoryScreenAssessmentScreenVisualAudioResizScreen,
            arguments: lis);
      }
    } catch (e) {
      debugPrint("catch section");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _handleAuditory(BuildContext context, int level) async {
    final levelProvider =
        Provider.of<PhonemsLevelScreenOneProvider>(context, listen: false);
    final String type;
    try {
      final Map<String, dynamic>? data =
          await levelProvider.fetchData(0, level);
      type = data!["type"];
      if (type == "video") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoUrl: data["video"])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Object retrieveObject(String type, Map<String, dynamic> data) {
    if (type == "ImageToAudio") {
      ImageToAudio imageToAudio = ImageToAudio.fromJson(data);
      return imageToAudio;
    } else if (type == "WordToFig") {
      WordToFiG wordToFiG = WordToFiG.fromJson(data);
      return wordToFiG;
    } else if (type == "FigToWord") {
      FigToWord figToWord = FigToWord.fromJson(data);
      return figToWord;
    } else if (type == "AudioToImage") {
      debugPrint("in audio to image section ");
      AudioToImage audioToImage = AudioToImage.fromJson(data);
      return audioToImage;
    } else
      return "unexpected value";
  }
}
