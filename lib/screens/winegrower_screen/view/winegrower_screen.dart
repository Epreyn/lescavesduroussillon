import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/custom_data.dart';
import '../../../core/classes/unique_controllers.dart';
import '../../../core/models/winegrower.dart';
import '../../../features/custom_animated_text/view/custom_animated_text.dart';
import '../../../features/custom_animation/view/custom_animation.dart';
import '../controllers/winegrower_screen_controller.dart';

class WinegrowerScreen extends StatelessWidget {
  final Winegrower winegrower;

  const WinegrowerScreen({super.key, required this.winegrower});

  @override
  Widget build(BuildContext context) {
    WinegrowerScreenController cc = Get.put(WinegrowerScreenController());
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: winegrower.id,
            child: Image.network(
              winegrower.imageURL,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (ctx, _, __) => const Icon(Icons.error),
            ),
          ),
          Positioned(
            top: UniquesControllers().data.baseSpace * 2,
            left: UniquesControllers().data.baseSpace * 2,
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: UniquesControllers().data.baseSpace * 4),
              onPressed: () => Get.back(),
            ),
          ),
          Positioned(
            bottom: UniquesControllers().data.baseSpace * 4,
            right: UniquesControllers().data.baseSpace * 4,
            child: CustomAnimation(
              duration: Duration(milliseconds: 400),
              isOpacity: true,
              xStartPosition: UniquesControllers().data.baseSpace * 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(UniquesControllers().data.baseSpace * 2),
                ),
                padding: EdgeInsets.all(UniquesControllers().data.baseSpace * 2),
                child: CustomAnimatedText(
                  key: UniqueKey(),
                  text: winegrower.name,
                  direction: Direction.left,
                  baseDelay: (UniquesControllers().data.baseSpace * 3).toInt(),
                  duration: (UniquesControllers().data.baseSpace * 75).toInt(),
                  style: TextStyle(fontSize: UniquesControllers().data.baseSpace * 8, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
