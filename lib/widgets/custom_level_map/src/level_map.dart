import 'package:flutter/material.dart';
import '../model/images_to_paint.dart';
import '../model/level_map_params.dart';
import '../paint/level_map_painter.dart';
import '../utils/load_ui_image_to_draw.dart';
import '../utils/scroll_behaviour.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui' as ui show PictureRecorder;

class LevelMap extends StatelessWidget {
  final LevelMapParams levelMapParams;
  final Color backgroundColor;

  List<Widget> generateStackChildren(
      LevelMapPainter levelMapPainter, BoxConstraints constraints) {
    List<Widget> children = [];

    print("offsetPoints: ${levelMapPainter.getOffsetPoints()}");
    for (var offsetPoints in levelMapPainter.getOffsetPoints()) {
      print("here");
      children.add(
        Positioned(
            bottom:
                -offsetPoints.offset.dy - offsetPoints.imageDetails.size.height,
            left: offsetPoints.offset.dx,
            child: InkWell(
              child: Image(
                image: AssetImage(offsetPoints
                    .imageDetails.path!), //offsetPoints.imageDetails.path!
                width: offsetPoints.imageDetails.size.width,
                height: offsetPoints.imageDetails.size.height,
              ),
              onTap: offsetPoints.imageDetails.onTap != null
                  ? () {
                      offsetPoints.imageDetails.onTap!(offsetPoints.level);
                    }
                  : null,
            )),
      );
    }
    print("children: $children");
    return children;
  }

  /// If set to false, scroll starts from the bottom end (level 1).
  final bool scrollToCurrentLevel;
  const LevelMap({
    Key? key,
    required this.levelMapParams,
    this.backgroundColor = Colors.transparent,
    this.scrollToCurrentLevel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ScrollConfiguration(
        behavior: const MyBehavior(),
        child: SingleChildScrollView(
          controller: ScrollController(
              initialScrollOffset: (((scrollToCurrentLevel
                          ? (levelMapParams.levelCount -
                              levelMapParams.currentLevel +
                              2)
                          : levelMapParams.levelCount)) *
                      levelMapParams.levelHeight) -
                  constraints.maxHeight),
          // physics: FixedExtentScrollPhysics(),
          child: ColoredBox(
            color: backgroundColor,
            child: FutureBuilder<ImagesToPaint?>(
              future: loadImagesToPaint(
                levelMapParams,
                levelMapParams.levelCount,
                levelMapParams.levelHeight,
                constraints.maxWidth,
              ),
              builder: (context, snapshot) {
                final level_painter = LevelMapPainter(
                    params: levelMapParams,
                    imagesToPaint: snapshot.data,
                    size: Size(
                        constraints.maxWidth,
                        levelMapParams.levelCount *
                            levelMapParams.levelHeight));
                return Stack(children: [
                  Container(
                      // set dimention of the container to the size of the stack
                      width: constraints.maxWidth,
                      height: levelMapParams.levelCount *
                          levelMapParams.levelHeight,
                      child: CustomPaint(
                        size: Size(
                            constraints.maxWidth,
                            levelMapParams.levelCount *
                                levelMapParams.levelHeight),
                        painter: level_painter,
                      )),
                  ...generateStackChildren(level_painter, constraints)
                ]);
                // return CustomPaint(
                //   size: Size(constraints.maxWidth,
                //       levelMapParams.levelCount * levelMapParams.levelHeight),
                //   painter: LevelMapPainter(
                //       params: levelMapParams, imagesToPaint: snapshot.data),
                // );
              },
            ),
          ),
        ),
      ),
    );
  }
}
