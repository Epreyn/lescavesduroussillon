import 'package:flutter/material.dart';

import '../../../core/classes/custom_data.dart';
import '../../../core/classes/unique_controllers.dart';
import '../../custom_animation/view/custom_animation.dart';

class CustomAnimatedText extends StatelessWidget {
  final String? tag;
  final String text;
  final TextStyle? style;
  final Direction? direction;
  final int baseDelay;
  final int duration;
  final Curve curve;
  final bool isOpacity;
  final double? xStartOffset;
  final double? yStartOffset;

  const CustomAnimatedText({
    super.key,
    this.tag,
    required this.text,
    this.style,
    this.direction,
    this.baseDelay = 100,
    this.duration = 600,
    this.curve = Curves.easeInOutBack,
    this.isOpacity = true,
    this.xStartOffset,
    this.yStartOffset,
  });

  @override
  Widget build(BuildContext context) {
    double xOffset = 0;
    double yOffset = 0;
    if (direction != null) {
      switch (direction) {
        case Direction.left:
          xOffset = (xStartOffset ?? UniquesControllers().data.baseSpace * 4);
          break;
        case Direction.right:
          xOffset = -(xStartOffset ?? UniquesControllers().data.baseSpace * 4);
          break;
        case Direction.top:
          yOffset = (yStartOffset ?? UniquesControllers().data.baseSpace * 4);
          break;
        case Direction.bottom:
          yOffset = -(yStartOffset ?? UniquesControllers().data.baseSpace * 4);
          break;
        case null:
          throw UnimplementedError();
      }
    } else {
      xOffset = xStartOffset ?? 0;
      yOffset = yStartOffset ?? 0;
    }

    final words = text.split(' ');
    int globalLetterIndex = 0;

    return Center(
      child: Wrap(
        runSpacing: UniquesControllers().data.baseSpace / 4,
        children: [
          for (int w = 0; w < words.length; w++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int j = 0; j < words[w].length; j++)
                  _buildAnimatedLetter(
                    letter: words[w][j],
                    letterIndex: globalLetterIndex++,
                    xOffset: xOffset,
                    yOffset: yOffset,
                  ),
                if (w < words.length - 1)
                  _buildAnimatedLetter(
                    letter: ' ',
                    letterIndex: globalLetterIndex++,
                    xOffset: xOffset,
                    yOffset: yOffset,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLetter({
    required String letter,
    required int letterIndex,
    required double xOffset,
    required double yOffset,
  }) {
    return CustomAnimation(
      fixedTag: tag == null ? null : tag! + letterIndex.toString(),
      delay: Duration(milliseconds: baseDelay * letterIndex),
      duration: Duration(milliseconds: duration),
      isOpacity: isOpacity,
      xStartPosition: xOffset,
      yStartPosition: yOffset,
      curve: curve,
      child: Text(letter, style: style),
    );
  }
}
