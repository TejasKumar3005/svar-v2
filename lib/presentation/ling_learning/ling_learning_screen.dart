import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';

class LingLearningScreen extends StatefulWidget {
  const LingLearningScreen({Key? key}) : super(key: key);

  @override
  LingLearningScreenState createState() => LingLearningScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LingLearningProvider(),
      child: LingLearningScreen(),
    );
  }
}

class LingLearningScreenState extends State<LingLearningScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LingLearningProvider lingLearningProvider =
        context.watch<LingLearningProvider>();
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.imgGroup7),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(context),
                ],
              ),
              Positioned(
                  left: 120,
                  bottom: 60,
                  child: Container(
                    height: 50,
                    width: 100,
                    child: CustomButton(
                      type: ButtonType.Next,
                      onPressed: () {
                        NavigatorService.pushNamed(
                          AppRoutes.lingLearningQuickTipScreen,
                        );
                      },
                    ),
                  )),
              Positioned(
                right: 80,
                bottom: 0,
                child: Container(
                  height: 360,
                  width: 270,
                  child: Image.asset(
                    ImageConstant.imgProtaganist1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 50,

                child:Container(
                  height: 70,
                  width: 100,
                  child: CustomButton(
                    type: ButtonType.Tip,
                    onPressed: () {},
                  ),
                ),
                
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            type: ButtonType.Back,
            onPressed: () {},
          ),
          Spacer(),
          CustomButton(
            type: ButtonType.Replay,
            onPressed: () {
              NavigatorService.pushNamed(
                AppRoutes.welcomeScreenPotraitScreen,
              );
            },
          ),
           SizedBox(width: 5,),
          CustomButton(
            type: ButtonType.FullVolume,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
