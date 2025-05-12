import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/winegrower.dart';
import 'winegrower_screen.dart';

class WinegrowerScreenFromParam extends StatelessWidget {
  const WinegrowerScreenFromParam({super.key});

  @override
  Widget build(BuildContext context) {
    final rawName = Get.parameters['winegrowerName'] ?? '';
    String decodedName;
    try {
      decodedName = Uri.decodeComponent(rawName);
    } catch (e) {
      decodedName = rawName;
    }

    final Winegrower? argWinegrower = Get.arguments as Winegrower?;

    if (argWinegrower != null) {
      return WinegrowerScreen(winegrower: argWinegrower);
    } else {
      return FutureBuilder<Winegrower?>(
        future: _fetchWinegrowerByName(decodedName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Scaffold(
              body: Center(child: Text("Winegrower '$decodedName' not found.")),
            );
          }
          final winegrower = snapshot.data!;
          return WinegrowerScreen(winegrower: winegrower);
        },
      );
    }
  }

  Future<Winegrower?> _fetchWinegrowerByName(String name) async {
    final query =
        await FirebaseFirestore.instance
            .collection('winegrowers')
            .where('name', isEqualTo: name)
            .limit(1)
            .get();
    if (query.docs.isEmpty) return null;

    return Winegrower.fromDocument(query.docs.first);
  }
}
