// import 'package:audioplayers/audioplayers.dart';
// import 'package:svar_new/widgets/auditoryAppbar.dart';
// import 'package:flutter/material.dart';
// import 'package:svar_new/core/app_export.dart';
// import 'provider/auditory_screen_assessment_screen_visual_audio_resiz_provider.dart';
// import 'package:svar_new/widgets/custom_button.dart';

// class AuditoryScreenAssessmentScreenVisualAudioResizScreen
//     extends StatefulWidget {
//       final String type;

//   const AuditoryScreenAssessmentScreenVisualAudioResizScreen({Key? key , required String this.type, })
//       : 
//       super(
//           key: key,
//         );

//   @override
//   AuditoryScreenAssessmentScreenVisualAudioResizScreenState createState() =>
//       AuditoryScreenAssessmentScreenVisualAudioResizScreenState();

//   static Widget builder(BuildContext context , {required String type}) {
//     return ChangeNotifierProvider(
//       create: (context) =>
//           AuditoryScreenAssessmentScreenVisualAudioResizProvider(),
//       child: AuditoryScreenAssessmentScreenVisualAudioResizScreen(type: type,),
//     );
//   }

// }
// class AuditoryScreenAssessmentScreenVisualAudioResizScreenState
//     extends State<AuditoryScreenAssessmentScreenVisualAudioResizScreen> {
//   late final String type;
//   final AudioPlayer audioPlayer = AudioPlayer();
//   void playAudio(String url) {
//     audioPlayer.play(url as Source);
//   }
//   @override
//   void initState() {
//     super.initState();
//     type = widget.type;
//   }

//   int sel = 0;
//   @override
//   Widget build(BuildContext context) {
//     var provider =
//         context.watch<AuditoryScreenAssessmentScreenVisualAudioResizProvider>();
//     provider.setQuizType(type);

//     return SafeArea(
//       child: Scaffold(
//         extendBody: true,
//         extendBodyBehindAppBar: true,
//         backgroundColor: appTheme.gray300,
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                 ImageConstant.imgAuditorybg,
//               ),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: 20.h,
//               vertical: 10.v,
//             ),
//             child: Column(
//               children: [
//                 AuditoryAppBar(context),
//                 SizedBox(height: 56.v),
//                 _buildOptionGRP(context, provider , type),
//                 Spacer(),
//                 Center(
//                   child: CustomButton(
//                         type: ButtonType.Next,
//                         onPressed: () {

//                         }),
//                 ),
//                 Spacer()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Section Widget
//   Widget _buildOptionGRP(BuildContext context,
//       AuditoryScreenAssessmentScreenVisualAudioResizProvider provider , String type) {
//         dynamic screen_data_obj = provider.getScreeValue(type);

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//               height: 192.v,
//               width: MediaQuery.of(context).size.width * 0.4,
//               padding: EdgeInsets.all(1.h),
//               decoration: AppDecoration.outlineBlack9001.copyWith(
//                 borderRadius: BorderRadiusStyle.roundedBorder15,
//               ),
//               child: CustomImageView(
//                 imagePath: screen_data_obj.getImageUrl,                   //  ImageConstant.imgClap,
//                 radius: BorderRadiusStyle.roundedBorder15,
//               )),
//           buildDynamicOptions(provider.quizType, provider , screen_data_obj)
//         ],
//       ),
//     );
//   }

//   Widget buildDynamicOptions(String quizType,
//       AuditoryScreenAssessmentScreenVisualAudioResizProvider provider , dynamic screen_data_obj ) {
//     switch (quizType) {
//       case "VOICE":
//         return Container(
//             height: 192.v,
//             width: MediaQuery.of(context).size.width * 0.4,
//             child: Column(
//               children: [
//                 Spacer(),
//                 GestureDetector(
//                   onTap: () {
//                     provider.setSelected(0);
//                     if (screen_data_obj.getCorrectOutput().toString() == screen_data_obj.getAudioList[0]){
//                       // push the widget which will shown after success
//                 //      Navigator.push(context, null);
//                     }else{
//                       // push the widget which will shown after failure
//                     }
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     height: 80.v,
//                     padding:
//                         EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
//                     decoration: AppDecoration.outlineBlack.copyWith(
//                         border: Border.all(
//                           width: provider.sel == 0 ? 2.3.h : 1.3.h,
//                           color: provider.sel == 0
//                               ? appTheme.green900
//                               : appTheme.black900,
//                         ),
//                         borderRadius: BorderRadiusStyle.roundedBorder10),
//                     child: Row(
//                       children: [
//                         CustomButton(
//                         type: ButtonType.ImagePlay,
//                         onPressed: () {
//                           playAudio(screen_data_obj.getAudioList[0]);
//                           // Navigator.pop(context);
//                         }),
//                         Spacer(),
//                         CustomImageView(
//                           height: 65.v,
//                           fit: BoxFit.contain,
//                           width:
//                               (MediaQuery.of(context).size.width * 0.4 - 80.h),
//                           imagePath: ImageConstant.imgSpectrum,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Spacer(),
//                 GestureDetector(
//                   onTap: () {
//                     provider.setSelected(1);
//                     if (screen_data_obj.getCorrectOutput().toString() == screen_data_obj.getAudioList[1]){
//                       // push the widget which will shown after success
//                 //      Navigator.push(context, null);
//                     }else{
//                       // push the widget which will shown after failure
//                     }
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     height: 80.v,
//                     padding:
//                         EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
//                     decoration: AppDecoration.outlineBlack9003.copyWith(
//                         border: Border.all(
//                           width: provider.sel == 1 ? 2.3.h : 1.3.h,
//                           color: provider.sel == 1
//                               ? appTheme.green900
//                               : appTheme.black900,
//                         ),
//                         borderRadius: BorderRadiusStyle.roundedBorder10),
//                     child: Row(
//                       children: [
//                         CustomButton(
//                         type: ButtonType.ImagePlay,
//                         onPressed: () {
//                           playAudio(screen_data_obj.getAudioList[0]);
//                         }),
//                         Spacer(),
//                         CustomImageView(
//                           height: 65.v,
//                           fit: BoxFit.contain,
//                           width:
//                               (MediaQuery.of(context).size.width * 0.4 - 80.h),
//                           imagePath: ImageConstant.imgSpectrum,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Spacer()
//               ],
//             ));
//       case "FIG_TO_WORD":
//         return Container(
//           height: 192.v,
//           width: MediaQuery.of(context).size.width * 0.4,
//           child: Row(
//             children: [
//               Container(
//                 height: 130.v,
//                 padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
//                 decoration: AppDecoration.outlineBlack9003.copyWith(
//                     color: appTheme.deepOrangeA200,
//                     border: Border.all(
//                       width: provider.sel == 1 ? 2.3.h : 1.3.h,
//                       color: provider.sel == 1
//                           ? appTheme.green900
//                           : appTheme.black900,
//                     ),
//                     image: DecorationImage(
//                         image:
//                            AssetImage("assets/images/radial_ray_orange.png"),
//                         fit: BoxFit.cover),
//                     borderRadius: BorderRadiusStyle.roundedBorder10),
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[0]){
//                             // success widget push
//                           }else{
//                             // failure widget push 
//                           }
//                         },
//                         child: Text(
//                         screen_data_obj.getTextList[0],
//                         style: theme.textTheme.labelMedium,
//                       ),
//                       ),
//                       SizedBox(
//                         height: 8.v,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[1]){
//                             // success widget push
//                           }else{
//                             // failure widget push 
//                           }
//                         },
//                         child: Text(
//                         screen_data_obj.getTextList[1],
//                         style: theme.textTheme.labelMedium,
//                       ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 130.v,
//                 padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
//                 decoration: AppDecoration.outlineBlack9003.copyWith(
//                     color: appTheme.teal90001,
//                     border: Border.all(
//                       width: provider.sel == 1 ? 2.3.h : 1.3.h,
//                       color: provider.sel == 1
//                           ? appTheme.green900
//                           : appTheme.black900,
//                     ),
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/radial_ray_green.png"),
//                         fit: BoxFit.cover),
//                     borderRadius: BorderRadiusStyle.roundedBorder10),
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[2]){
//                             // success widget push
//                           }else{
//                             // failure widget push 
//                           }
//                         },
//                         child: Text(
//                         screen_data_obj.getTextList[2],
//                         style: theme.textTheme.labelMedium,
//                       ),
//                       ),
//                       SizedBox(
//                         height: 8.v,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[3]){
//                             // success widget push
//                           }else{
//                             // failure widget push 
//                           }
//                         },
//                         child: Text(
//                         screen_data_obj.getTextList[3],
//                         style: theme.textTheme.labelMedium,
//                       ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       case "WORD_TO_FIG":
//         return Container(
//           height: 192.v,
//           width: MediaQuery.of(context).size.width * 0.4,
//           child: Row(
//             children: [
//               Container(
//                 height: 130.v,
//                 padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
//                 decoration: AppDecoration.outlineBlack9003.copyWith(
//                     border: Border.all(
//                       width: provider.sel == 1 ? 2.3.h : 1.3.h,
//                       color: provider.sel == 1
//                           ? appTheme.green900
//                           : appTheme.black900,
//                     ),
//                     image: DecorationImage(
//                         image:
//                             AssetImage("assets/images/radial_ray_yellow.png"),
//                         fit: BoxFit.cover),
//                     borderRadius: BorderRadiusStyle.roundedBorder10),
//                 child: Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       if(screen_data_obj.getCorrectOutput == screen_data_obj.getImageUrlList[0]){
//                         // success widget loader 
//                       }else {
//                         // failure widget loader 
//                       }
//                     },
//                     child: Image.network(
//                         screen_data_obj.getImageUrlList[0],
//                         fit: BoxFit.contain,
//                         height: 70.v,
//                         width: 50.v,
//                   ),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 130.v,
//                 padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
//                 decoration: AppDecoration.outlineBlack9003.copyWith(
//                     border: Border.all(
//                       width: provider.sel == 1 ? 2.3.h : 1.3.h,
//                       color: provider.sel == 1
//                           ? appTheme.green900
//                           : appTheme.black900,
//                     ),
//                     image: DecorationImage(
//                         image:
//                             AssetImage("assets/images/radial_ray_yellow.png"),
//                         fit: BoxFit.cover),
//                     borderRadius: BorderRadiusStyle.roundedBorder10),
//                 child: Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       if(screen_data_obj.getCorrectOutput == screen_data_obj.getImageUrlList[0]){
//                         // success widget loader 
//                       }else {
//                         // failure widget loader 
//                       }
//                     },
//                     child: Image.network(
//                         screen_data_obj.getImageUrlList[1],
//                         fit: BoxFit.contain,
//                         height: 70.v,
//                         width: 50.v,
//                   ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       default:
//         return Row();
//     }
//   }
// }









import 'package:audioplayers/audioplayers.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/auditory_screen_assessment_screen_visual_audio_resiz_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';

class AuditoryScreenAssessmentScreenVisualAudioResizScreen
    extends StatefulWidget {
      final String type = "FIG_TO_WORD";

  const AuditoryScreenAssessmentScreenVisualAudioResizScreen({Key? key })
      :
      super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenVisualAudioResizScreenState createState() =>
      AuditoryScreenAssessmentScreenVisualAudioResizScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AuditoryScreenAssessmentScreenVisualAudioResizProvider(),
      child: AuditoryScreenAssessmentScreenVisualAudioResizScreen(),
    );
  }
}
class AuditoryScreenAssessmentScreenVisualAudioResizScreenState
    extends State<AuditoryScreenAssessmentScreenVisualAudioResizScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  void playAudio(String url) {
    audioPlayer.play(url as Source);
  }
  @override
  void initState() {
    super.initState();
  }
  int sel = 0;
  @override
  Widget build(BuildContext context) {
    var provider =
        context.watch<AuditoryScreenAssessmentScreenVisualAudioResizProvider>();
  
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: appTheme.gray300,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgAuditorybg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.h,
              vertical: 10.v,
            ),
            child: Column(
              children: [
                AuditoryAppBar(context),
                SizedBox(height: 56.v),
                _buildOptionGRP(context, provider , provider.quizType),
                Spacer(),
                Center(
                  child: CustomButton(
                        type: ButtonType.Next,
                        onPressed: () {

                        }),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildOptionGRP(BuildContext context,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider, String type) {
    return FutureBuilder<dynamic>(
      future: provider.getScreeValue(type),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint("error section entering ");
          return Center(child: Text('Error: Error is produced here'));
        } else if (snapshot.hasData) {
          debugPrint("waiting for initialization");
          var screenDataObj = snapshot.data;
          debugPrint(screenDataObj.toString());

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50.v,
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(1.h),
                  decoration: AppDecoration.outlineBlack9001.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder15,
                  ),
                  child:
                  /* CustomImageView(
                    imagePath: screenDataObj.getImageUrl(),   // Adjust this based on your data structure
                    radius: BorderRadiusStyle.roundedBorder15,
                  ),

                   */
                  Image.network(
                    screenDataObj.getImageUrl(),
                    fit: BoxFit.contain,
                  ),
                ),
                buildDynamicOptions(provider.quizType, provider, screenDataObj)
              ],
            ),
          );
        } else {
          return Center(child: Text('No data found'));
        }
      },
    );
  }



  Widget buildDynamicOptions(String quizType,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider , dynamic screen_data_obj ) {
    switch (quizType) {
      case "VOICE":
        return Container(
            height: 192.v,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    provider.setSelected(0);
                    if (screen_data_obj.getCorrectOutput().toString() == screen_data_obj.getAudioList[0]){
                      // push the widget which will shown after success
                //      Navigator.push(context, null);
                    }else{
                      // push the widget which will shown after failure
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack.copyWith(
                        border: Border.all(
                          width: provider.sel == 0 ? 2.3.h : 1.3.h,
                          color: provider.sel == 0
                              ? appTheme.green900
                              : appTheme.black900,
                        ),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                    child: Row(
                      children: [
                        CustomButton(
                        type: ButtonType.ImagePlay,
                        onPressed: () {
                          playAudio(screen_data_obj.getAudioList[0]);
                          // Navigator.pop(context);
                        }),
                        Spacer(),
                        CustomImageView(
                          height: 65.v,
                          fit: BoxFit.contain,
                          width:
                              (MediaQuery.of(context).size.width * 0.4 - 80.h),
                          imagePath: ImageConstant.imgSpectrum,
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    provider.setSelected(1);
                    if (screen_data_obj.getCorrectOutput().toString() == screen_data_obj.getAudioList[1]){
                      // push the widget which will shown after success
                //      Navigator.push(context, null);
                    }else{
                      // push the widget which will shown after failure
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                        border: Border.all(
                          width: provider.sel == 1 ? 2.3.h : 1.3.h,
                          color: provider.sel == 1
                              ? appTheme.green900
                              : appTheme.black900,
                        ),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                    child: Row(
                      children: [
                        CustomButton(
                        type: ButtonType.ImagePlay,
                        onPressed: () {
                          playAudio(screen_data_obj.getAudioList[0]);
                        }),
                        Spacer(),
                        CustomImageView(
                          height: 65.v,
                          fit: BoxFit.contain,
                          width:
                              (MediaQuery.of(context).size.width * 0.4 - 80.h),
                          imagePath: ImageConstant.imgSpectrum,
                        )
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ));
      case "FIG_TO_WORD":
        return Container(
          height: 192.v,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              Container(
                height: 130.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack9003.copyWith(
                    color: appTheme.deepOrangeA200,
                    border: Border.all(
                      width: provider.sel == 1 ? 2.3.h : 1.3.h,
                      color: provider.sel == 1
                          ? appTheme.green900
                          : appTheme.black900,
                    ),
                    image: DecorationImage(
                        image:
                           AssetImage("assets/images/radial_ray_orange.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[0]){
                            // success widget push
                          }else{
                            // failure widget push
                          }
                        },
                        child: Text(
                        screen_data_obj.getTextList[0],
                        style: theme.textTheme.labelMedium,
                      ),
                      ),
                      SizedBox(
                        height: 8.v,
                      ),
                      GestureDetector(
                        onTap: () {
                          if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[1]){
                            // success widget push
                          }else{
                            // failure widget push
                          }
                        },
                        child: Text(
                        screen_data_obj.getTextList[1],
                        style: theme.textTheme.labelMedium,
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 130.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack9003.copyWith(
                    color: appTheme.teal90001,
                    border: Border.all(
                      width: provider.sel == 1 ? 2.3.h : 1.3.h,
                      color: provider.sel == 1
                          ? appTheme.green900
                          : appTheme.black900,
                    ),
                    image: DecorationImage(
                        image: AssetImage("assets/images/radial_ray_green.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[2]){
                            // success widget push
                          }else{
                            // failure widget push
                          }
                        },
                        child: Text(
                        screen_data_obj.getTextList[2],
                        style: theme.textTheme.labelMedium,
                      ),
                      ),
                      SizedBox(
                        height: 8.v,
                      ),
                      GestureDetector(
                        onTap: () {
                          if(screen_data_obj.getCorrectOutput == screen_data_obj.getTextList[3]){
                            // success widget push
                          }else{
                            // failure widget push
                          }
                        },
                        child: Text(
                        screen_data_obj.getTextList[3],
                        style: theme.textTheme.labelMedium,
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case "WORD_TO_FIG":
        return Container(
          height: 192.v,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              Container(
                height: 130.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack9003.copyWith(
                    border: Border.all(
                      width: provider.sel == 1 ? 2.3.h : 1.3.h,
                      color: provider.sel == 1
                          ? appTheme.green900
                          : appTheme.black900,
                    ),
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/radial_ray_yellow.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if(screen_data_obj.getCorrectOutput == screen_data_obj.getImageUrlList[0]){
                        // success widget loader
                      }else {
                        // failure widget loader
                      }
                    },
                    child: Image.network(
                        screen_data_obj.getImageUrlList[0],
                        fit: BoxFit.contain,
                        height: 70.v,
                        width: 50.v,
                  ),
                  ),
                ),
              ),
              Container(
                height: 130.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack9003.copyWith(
                    border: Border.all(
                      width: provider.sel == 1 ? 2.3.h : 1.3.h,
                      color: provider.sel == 1
                          ? appTheme.green900
                          : appTheme.black900,
                    ),
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/radial_ray_yellow.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if(screen_data_obj.getCorrectOutput == screen_data_obj.getImageUrlList[1]){
                        // success widget loader
                      }else {
                        // failure widget loader
                      }
                    },
                    child: Image.network(
                        screen_data_obj.getImageUrlList[1],
                        fit: BoxFit.contain,
                        height: 70.v,
                        width: 50.v,
                  ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Row();
    }
  }
}
