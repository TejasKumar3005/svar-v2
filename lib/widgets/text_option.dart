import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Expanded(
      flex: 1,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: MediaQuery.of(context).size.height * 0.35,
        child: Stack(
          children: [
            Container(
              width: 250,
              height: 250,
              child: SvgPicture.asset( 
                     "assets/images/svg/Opt-2.svg",
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
