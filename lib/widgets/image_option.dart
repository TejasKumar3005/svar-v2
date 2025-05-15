import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart'; // For SVG support
import 'package:svar_new/widgets/Options.dart';
import 'dart:io'; // For File
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:svar_new/core/app_export.dart';

class ImageWidget extends StatefulWidget {
  final String imagePath;

  ImageWidget({
    required this.imagePath,
  });

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool _isNetworkImage(String path) {
    return path.startsWith('http'); // Check if the image is a network image
  }

  File? _cachedImage ;

  @override
  void initState() {
    super.initState();
    _loadCachedImage(widget.imagePath);
  }
    

  Future<void> _loadCachedImage(String imagePath) async {
    
    if (_isNetworkImage(imagePath)) {
      final cachedFile = await CachingManager().getCachedFile(imagePath);
      setState(() {
        _cachedImage = cachedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;

    return ChicletOutlinedAnimatedButton(
       width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.45,
      buttonType: ChicletButtonTypes.roundedRectangle,
      borderColor: Color.fromARGB(255, 132, 140, 74),
      child: GestureDetector(
        onTap: () {
          if (click != null) {
            click();
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FittedBox(
            fit: BoxFit.fill,
            child: CustomImageView(
                imagePath: widget.imagePath,
              ),
          ),
        ),
      ),
    );
  }
}
