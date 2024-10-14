import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/widgets/Options.dart';
class TextContainer extends StatefulWidget {
  final String text;

  const TextContainer({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _TextContainerState createState() => _TextContainerState();
}

class _TextContainerState extends State<TextContainer> {
   
  @override
  Widget build(BuildContext context) {
     final click = ClickProvider.of(context)?.click;
    return  AnimatedContainer(
        duration: Duration(seconds: 1),
        height: MediaQuery.of(context).size.height * 0.35,
        child: Stack(
          alignment:
              Alignment.center, // Center align everything inside the Stack
          children: [
            Container(
              width: 150,
              height: 150,
              child: SvgPicture.asset(
                "assets/images/svg/Opt-2.svg",
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                 if (click != null) {
                  click();
                }
                },
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black, // Text color
                  ),
                  textAlign: TextAlign.center, // Align text to the center
                ),
              ),
            ),
          ],
        ),
      );
  }
}
