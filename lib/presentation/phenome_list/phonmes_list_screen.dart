import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_provider.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:svar_new/widgets/grid_item_model.dart';
import 'package:svar_new/widgets/grid_item_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final padding = isLandscape
        ? EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.05)
        : EdgeInsets.symmetric(horizontal: 29.h, vertical: 20.v);

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
                SizedBox(height: 5.v),
                Expanded(
                  child: Column(
                    children: [
                      _buildAppBar(context),
                      SizedBox(height: 2.v),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 33.h, vertical: 8.v),
                        decoration: AppDecoration.fillAmber.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder27,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 20.h),
                            AutoSizeText(
                              "msg_let_s_learn_phonemes".tr.toUpperCase(),
                              style: theme.textTheme.headlineMedium,
                              maxLines: 1,
                              minFontSize: 8,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 70.v),
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
        CustomImageView(
          height: 37.5.adaptSize,
          width: 37.5.adaptSize,
          fit: BoxFit.contain,
          imagePath: ImageConstant.imgBackBtn,
        ),
        CustomImageView(
          height: 37.5.adaptSize,
          width: 37.5.adaptSize,
          fit: BoxFit.contain,
          imagePath: ImageConstant.imgMenuBtn,
        ),
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
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0, // Ensuring square grid items
              ),
              itemCount: provider.phonmesListModelObj.gridItemList.length,
              itemBuilder: (context, index) {
                GridItemModel model = provider.phonmesListModelObj.gridItemList[index];
                return Align(
                  child: GestureDetector(
                    onTap: () {
                      PhonmesListModel().onTapCharacter(context, model.widget!);
                      Navigator.pushNamed(context, AppRoutes.lingLearningScreen);
                    },
                    child: GridItemWidget(
                      model: model,
                      child: AutoSizeText(
                        model.text,
                        style: theme.textTheme.bodyLarge,
                        maxLines: 1,
                        minFontSize: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
