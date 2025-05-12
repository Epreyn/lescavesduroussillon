import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ControllerMixin on GetxController {
  //#region ALERT DIALOG

  void variablesToResetToAlertDialog() {}

  actionAlertDialog() async {}

  Widget alertDialogContent() {
    return const SizedBox();
  }

  void openAlertDialog(
    String title, {
    String? confirmText,
    Color? confirmColor,
  }) {
    variablesToResetToAlertDialog();

    // TODO: Implement the alert dialog

    // Get.dialog(
    //   CustomAnimation(
    //     duration: Duration(milliseconds: alertDialogAnimationDuration),
    //     curve: Curves.easeInOutBack,
    //     isOpacity: true,
    //     yStartPosition: alertDialogAnimationDuration / 10,
    //     child: AlertDialog(
    //       title: Text(title),
    //       content: alertDialogContent(),
    //       actions: [
    //         CustomTextButton(
    //           tag: 'alert-dialog-back-button',
    //           text: 'Annuler',
    //           onPressed: () {
    //             Get.back();
    //           },
    //         ),
    //         CustomTextButton(
    //           tag: 'alert-dialog-confirm-button',
    //           text: confirmText ?? 'Confirmer',
    //           color: confirmColor,
    //           onPressed: () async {
    //             Get.back();
    //             await actionAlertDialog();
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  //#endregion

  //#region BOTTOM SHEET

  void variablesToResetToBottomSheet() {}

  deleteBottomSheet() {}

  actionBottomSheet() async {}

  List<Widget> bottomSheetChildren() {
    return const [];
  }

  void openBottomSheet(
    String title, {
    bool? hasDeleteButton,
    String? deleteButtonRightName,
    bool? hasAction,
    String? actionName,
    IconData? actionIcon,
    double? maxWidth,
    bool doReset = true,
  }) {
    if (doReset) variablesToResetToBottomSheet();

    // TODO: Implement the bottom sheet

    // Get.bottomSheet(
    //   SingleChildScrollView(
    //     child: Container(
    //       transform: Matrix4.translationValues(
    //         0,
    //         -UniquesControllers().data.baseSpace * 2,
    //         0,
    //       ),
    //       constraints: BoxConstraints(
    //         maxWidth: maxWidth ?? double.infinity,
    //       ),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.all(
    //           Radius.circular(UniquesControllers().data.baseSpace * 2),
    //           //topRight: Radius.circular(UniquesControllers().data.baseSpace * 2),
    //         ),
    //       ),
    //       child: Stack(
    //         children: [
    //           Column(
    //             children: [
    //               const CustomSpace(heightMultiplier: 2.4),
    //               Center(
    //                 child: Text(
    //                   title.toUpperCase(),
    //                   style: UniquesControllers().data.titleTextStyle,
    //                 ),
    //               ),
    //               const CustomSpace(heightMultiplier: 2.4),
    //               Padding(
    //                 padding: EdgeInsets.symmetric(
    //                   horizontal: UniquesControllers().data.baseSpace * 4,
    //                 ),
    //                 child: ListView.separated(
    //                   shrinkWrap: true,
    //                   physics: const NeverScrollableScrollPhysics(),
    //                   itemCount: bottomSheetChildren().length,
    //                   itemBuilder: (context, index) {
    //                     return bottomSheetChildren()[index];
    //                   },
    //                   separatorBuilder: (context, index) {
    //                     return const CustomSpace(heightMultiplier: 2);
    //                   },
    //                 ),
    //               ),
    //               const CustomSpace(heightMultiplier: 2),
    //               Visibility(
    //                 visible: hasAction ?? true,
    //                 child: CustomFABButton(
    //                   tag: 'action-bottom-sheet-button',
    //                   text: actionName == null ? '' : actionName.toUpperCase(),
    //                   iconData: actionIcon,
    //                   onPressed: () async {
    //                     await actionBottomSheet();
    //                   },
    //                 ),
    //               ),
    //               Visibility(
    //                 visible: hasAction ?? true,
    //                 child: const CustomSpace(heightMultiplier: 4),
    //               ),
    //             ],
    //           ),
    //           Align(
    //             alignment: Alignment.topLeft,
    //             child: Padding(
    //               padding: EdgeInsets.only(
    //                 top: UniquesControllers().data.baseSpace,
    //                 left: UniquesControllers().data.baseSpace,
    //               ),
    //               child: CustomIconButton(
    //                 tag: 'bottom-sheet-back-button',
    //                 iconData: Icons.arrow_back_rounded,
    //                 //iconColor: CustomColors.caribbeanCurrent,
    //                 //backgroundColor: CustomColors.seasalt,
    //                 onPressed: () {
    //                   UniquesControllers().data.back();
    //                 },
    //               ),
    //             ),
    //           ),
    //           Align(
    //             alignment: Alignment.topRight,
    //             child: Visibility(
    //               visible: hasDeleteButton ?? false,
    //               child: Padding(
    //                 padding: EdgeInsets.only(
    //                   top: UniquesControllers().data.baseSpace,
    //                   right: UniquesControllers().data.baseSpace,
    //                 ),
    //                 child: CustomIconButton(
    //                   tag: 'bottom-sheet-delete-button',
    //                   iconData: Icons.delete_rounded,
    //                   //iconColor: CustomColors.caribbeanCurrent,
    //                   onPressed: deleteBottomSheet,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   isScrollControlled: true,
    // );
  }

  //#endregion
}
