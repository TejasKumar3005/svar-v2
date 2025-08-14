import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/widgets/image_option.dart';
import 'package:audioplayers/audioplayers.dart';

class DuolingoOptionWidget extends StatefulWidget {
  final String imageUrl;
  final String text;

  final bool isFullWidth;

  const DuolingoOptionWidget({
    Key? key,
    required this.imageUrl,
    required this.text,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  State<DuolingoOptionWidget> createState() => _DuolingoOptionWidgetState();
}

class _DuolingoOptionWidgetState extends State<DuolingoOptionWidget> {
  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    return ChicletAnimatedButton(
      key: Key(widget.imageUrl),
      width: widget.isFullWidth ? double.infinity : null,
      buttonType: ChicletButtonTypes.roundedRectangle,
      borderRadius: 20,
      backgroundColor: Color.fromARGB(255, 234, 243, 173),
      onPressed: () {
        if (click != null) {
          click();
        }
      },
      child: Column(
        children: [
          if (widget.imageUrl.isNotEmpty) ...[
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  child: CustomImageView(
                    height: 150,
                    imagePath: widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          if (widget.text.isNotEmpty) ...[
            Expanded(
              flex: widget.imageUrl.isNotEmpty ? 3 : 1,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: widget.imageUrl.isNotEmpty
                      ? BorderRadius.vertical(bottom: Radius.circular(14))
                      : BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212529),
                      height: 1.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StoryQuestionOptionWidget extends StatefulWidget {
  final String imageUrl;
  final String text;
  final String audioUrl;

  const StoryQuestionOptionWidget({
    Key? key,
    required this.imageUrl,
    required this.text,
    required this.audioUrl,
  }) : super(key: key);

  @override
  State<StoryQuestionOptionWidget> createState() =>
      _StoryQuestionOptionWidgetState();
}

class _StoryQuestionOptionWidgetState extends State<StoryQuestionOptionWidget> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    return ChicletAnimatedButton(
      key: Key(widget.imageUrl),
      buttonType: ChicletButtonTypes.roundedRectangle,
      borderRadius: 16,
      backgroundColor: Colors.white,
      onPressed: () {
        if (click != null) {
          click();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE0E0E0), width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            if (widget.imageUrl.isNotEmpty) ...[
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: CustomImageView(
                          height: 150,
                          imagePath: widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (widget.audioUrl.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            await _player.play(UrlSource(widget.audioUrl));
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (widget.text.isNotEmpty) ...[
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: widget.imageUrl.isNotEmpty
                        ? BorderRadius.vertical(bottom: Radius.circular(16))
                        : BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212529),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StoryOptionWidget extends StatefulWidget {
  final String imageUrl;
  final String text;
  final String audioUrl;

  const StoryOptionWidget({
    Key? key,
    required this.imageUrl,
    required this.text,
    required this.audioUrl,
  }) : super(key: key);

  @override
  State<StoryOptionWidget> createState() => _StoryOptionWidgetState();
}

class _StoryOptionWidgetState extends State<StoryOptionWidget> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    return ChicletAnimatedButton(
      key: Key(widget.imageUrl),
      buttonType: ChicletButtonTypes.roundedRectangle,
      borderRadius: 16,
      backgroundColor: Colors.white,
      onPressed: () {
        if (click != null) {
          click();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE0E0E0), width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            if (widget.imageUrl.isNotEmpty) ...[
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: CustomImageView(
                          height: 150,
                          imagePath: widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (widget.audioUrl.isNotEmpty)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            await _player.play(UrlSource(widget.audioUrl));
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (widget.text.isNotEmpty) ...[
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: widget.imageUrl.isNotEmpty
                        ? BorderRadius.vertical(bottom: Radius.circular(16))
                        : BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212529),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class YesNoButtonWidget extends StatefulWidget {
  final String text;
  final Color color;

  const YesNoButtonWidget({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  State<YesNoButtonWidget> createState() => _YesNoButtonWidgetState();
}

class _YesNoButtonWidgetState extends State<YesNoButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    return ChicletOutlinedAnimatedButton(
      height: 60,
      buttonType: ChicletButtonTypes.roundedRectangle,
      borderRadius: 20,
      borderColor: widget.color,
      borderWidth: 2,
      backgroundColor: Colors.transparent,
      onPressed: () {
        if (click != null) {
          click();
        }
      },
      child: Center(
        child: Text(
          widget.text,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
