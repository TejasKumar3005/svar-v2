import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_provider.dart';
import 'package:svar_new/widgets/grid_item_model.dart';
import 'package:svar_new/widgets/grid_item_widget.dart';
import 'package:svar_new/widgets/custom_button.dart';

class PhonmesListScreen extends StatefulWidget {
  const PhonmesListScreen({Key? key}) : super(key: key);

  @override
  PhonmesListScreenState createState() => PhonmesListScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhonmesListProvider(),
      child: const PhonmesListScreen(),
    );
  }
}

class PhonmesListScreenState extends State<PhonmesListScreen> {
  @override
  void initState() {
  
    super.initState();
  }

  void dispose() {
  
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final padding = isLandscape
        ? EdgeInsets.symmetric(
            horizontal: size.width * 0.1, vertical: size.height * 0.05)
        : EdgeInsets.symmetric(
            horizontal: size.width * 0.07, vertical: size.height * 0.03);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: appTheme.whiteA70001,
            image: DecorationImage(
              image: AssetImage(ImageConstant.imgGroup358),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.01),
                Expanded(
                  child: Column(
                    children: [
                    DisciAppBar(context),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.08,
                            vertical: size.height * 0.01),
                        decoration: AppDecoration.fillAmber.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder27,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: size.width * 0.05),
                            Expanded(
                              child: Text(
                                "msg_let_s_learn_phonemes".tr.toUpperCase(),
                                style: theme.textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buildGrid(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          type: ButtonType.Back,
          onPressed: () {
              PlayBgm().playMusic('Back_Btn.mp3',"mp3",false);
            Navigator.pop(context);
          },
        ),
        // CustomButton(
        //   type: ButtonType.Menu,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final crossAxisCount = isLandscape ? 8 : 5;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Consumer<PhonmesListProvider>(
          builder: (context, provider, child) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: size.width * 0.02,
                mainAxisSpacing: size.height * 0.02,
              ),
              itemCount: provider.phonmesListModelObj.gridItemList.length,
              itemBuilder: (context, index) {
                GridItemModel model =
                    provider.phonmesListModelObj.gridItemList[index];
                return Align(
                  child: GestureDetector(
                    onTap: () {
                      PhonmesListModel()
                          .onTapCharacter(context, model.character!);
                          
                      Navigator.pushNamed(context,(index>7 && index<16)? AppRoutes.videoCamScreen:AppRoutes.lingLearningScreen,
                          arguments: model.character);
                    },
                    child: GridItemWidget(model),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
