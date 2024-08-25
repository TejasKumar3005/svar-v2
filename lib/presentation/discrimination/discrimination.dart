import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/custom_button.dart';

class Discrimination extends StatefulWidget {
  const Discrimination({super.key});

  @override
  State<Discrimination> createState() => _DiscriminationState();
  static Widget builder(BuildContext context) {
    return Discrimination();
  }
}

class _DiscriminationState extends State<Discrimination> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/discri_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.h,
          vertical: 10.v,
        ),
        child: Column(
          children: [
            DisciAppBar(context),
            SizedBox(
              height: 26.v,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.symmetric(
                vertical: 5.v,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  "Pick the odd One Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              children: [
                _buildOption("A", PrimaryColors().deepOrangeA200),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption("B", PrimaryColors().green900),
              ],
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOption("C", PrimaryColors().blueA200),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String text, Color color) {
    {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text + ")",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 10.h,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.symmetric(
              horizontal: 3.h,
              vertical: 5.v,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: color,
              border: Border.all(
                color: Colors.black,
                width: 5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  type: ButtonType.ImagePlay,
                  onPressed: () {},
                ),
                SizedBox(
                  width: 10.h,
                ),
                CustomImageView(
                  width: MediaQuery.of(context).size.width * 0.4 - 90,
                  height: 60,
                  fit: BoxFit.fill,
                  imagePath: "assets/images/spectrum.png",
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
