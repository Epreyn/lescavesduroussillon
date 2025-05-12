import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

import '../../../core/classes/unique_controllers.dart';
import '../../../features/custom_animation/view/custom_animation.dart';
import '../controllers/home_screen_controller.dart';
import 'custom_infinite_carousel_item.dart';
import 'hover_shrink_card.dart';

class CustomInfiniteCarousel extends StatelessWidget {
  final HomeScreenController homeScreenController;

  const CustomInfiniteCarousel({super.key, required this.homeScreenController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = homeScreenController.winegrowers;
      if (list.isEmpty) {
        return const SizedBox.shrink();
      }

      final pinned = homeScreenController.pinned.value;
      final currentIdx = homeScreenController.currentIndex.value;

      return InfiniteCarousel.builder(
        controller: homeScreenController.carouselController,
        itemCount: list.length,
        physics: const NeverScrollableScrollPhysics(),
        itemExtent: UniquesControllers().data.carouselItemWidth * 1.5,
        onIndexChanged: (idx) => homeScreenController.onCarouselIndexChanged(idx),
        itemBuilder: (context, itemIndex, realIndex) {
          final winegrower = list[itemIndex];

          if (pinned && itemIndex == currentIdx) {
            return Container();
          }

          final isCenterClickable = (!pinned && itemIndex == currentIdx);

          return CustomAnimation(
            fixedTag: winegrower.id + itemIndex.toString(),
            isOpacity: !isCenterClickable,
            delay: isCenterClickable ? null : Duration(milliseconds: 400),
            duration: isCenterClickable ? null : Duration(milliseconds: 800),
            child: SizedBox(
              width: UniquesControllers().data.carouselItemWidth.value,
              height: UniquesControllers().data.carouselItemHeight.value,

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: UniquesControllers().data.carouselItemWidth / 4),
                child: Hero(
                  tag: winegrower.id,
                  child: Material(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: HoverShrinkCard(
                        onTap: () {
                          final paramName = Uri.encodeComponent(winegrower.name);
                          Get.toNamed('/winegrower/$paramName', arguments: winegrower);
                        },
                        child: CustomInfiniteCarouselItem(winegrower: winegrower, isCenterItem: isCenterClickable),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
