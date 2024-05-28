import 'package:flutter/material.dart';

///Used to paint in the canvas
class ImageDetails {
  final ImageInfo imageInfo;
  final String? path; 
  final Size size;
  final void Function(int level) onTap;

  static void _defaultFunc(int level) {}

  ImageDetails({required this.imageInfo, required this.size, this.path, this.onTap = _defaultFunc});
}
