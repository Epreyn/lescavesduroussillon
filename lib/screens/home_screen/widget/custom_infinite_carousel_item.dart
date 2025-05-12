import 'package:flutter/material.dart';

import '../../../core/models/winegrower.dart';
import '../../../features/custom_animation/view/custom_animation.dart';

class CustomInfiniteCarouselItem extends StatelessWidget {
  final Winegrower winegrower;
  final bool isCenterItem;

  const CustomInfiniteCarouselItem({super.key, required this.winegrower, this.isCenterItem = false});

  @override
  Widget build(BuildContext context) {
    return CustomAnimation(
      fixedTag: winegrower.id,
      isOpacity: !isCenterItem,
      child: Transform.scale(
        scale: 1.05,
        child: Image.network(
          winegrower.imageURL,
          fit: BoxFit.cover,
          errorBuilder: (ctx, _, __) => const Icon(Icons.error),
          frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
            return child;
          },
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
