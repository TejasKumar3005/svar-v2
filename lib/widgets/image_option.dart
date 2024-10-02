import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For SVG support
import 'package:svar_new/widgets/Options.dart';
class ImageWidget extends StatefulWidget {
  final String imagePath;

  ImageWidget({
    required this.imagePath,
  });

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool _isSvgImage(String path) {
    return path.endsWith('.svg'); // Check if the image is an SVG
  }

  bool _isNetworkImage(String path) {
    return path.startsWith('http'); // Check if the image is a network image
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;

    return Expanded(
      child: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Border color (can use theme)
              width: 2, // Adjusted size, no adaptSize required
            ),
            borderRadius: BorderRadius.circular(10), // Rounded border
            color: Colors.cyan, // Background color
          ),
          child: GestureDetector(
            onTap: () {
              if (click != null) {
                click();
              }
            },
            child: FittedBox(
              fit: BoxFit.fill,
              child: _buildImageWidget(widget.imagePath), // Helper function to select image type
            ),
          ),
        ),
      ),
    );
  }

  /// Helper function to build the appropriate image widget
  Widget _buildImageWidget(String imagePath) {
    if (_isNetworkImage(imagePath)) {
      // For Network Images
      if (_isSvgImage(imagePath)) {
        return SvgPicture.network(
          imagePath,
          placeholderBuilder: (context) =>
              CircularProgressIndicator(), // Show a loader while loading
        );
      } else {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            return progress == null
                ? child
                : Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.error), // Error icon if image fails to load
        );
      }
    } else {
      // For Local Assets
      if (_isSvgImage(imagePath)) {
        return SvgPicture.asset(
          imagePath,
          fit: BoxFit.contain,
        );
      } else {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
        );
      }
    }
  }
}
