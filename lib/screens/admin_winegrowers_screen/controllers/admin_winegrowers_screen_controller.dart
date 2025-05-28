import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/winegrower.dart';

class AdminWinegrowersScreenController extends GetxController {
  /*───────────────────────────────────
  │ Firebase
  ───────────────────────────────────*/
  final _f = FirebaseFirestore.instance;
  final _s = FirebaseStorage.instance;

  /*───────────────────────────────────
  │ Liste observable
  ───────────────────────────────────*/
  final RxList<Winegrower> winegrowers = <Winegrower>[].obs;

  /*───────────────────────────────────
  │ Champs formulaire
  ───────────────────────────────────*/
  final domainCtrl = TextEditingController();
  final winegrowerCtrl = TextEditingController();
  final terroirCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  /*───────────────────────────────────
  │ Image sélectionnée
  ───────────────────────────────────*/
  Uint8List? pickedBytes; // les octets
  final pickedImageName = ''.obs; // nom du fichier

  /*───────────────────────────────────
  │ Life-cycle
  ───────────────────────────────────*/
  @override
  void onInit() {
    super.onInit();
    winegrowers.bindStream(
      _f
          .collection('winegrowers')
          .snapshots()
          .map((q) => q.docs.map(Winegrower.fromDocument).toList()),
    );
  }

  @override
  void onClose() {
    domainCtrl.dispose();
    winegrowerCtrl.dispose();
    terroirCtrl.dispose();
    descCtrl.dispose();
    super.onClose();
  }

  /*───────────────────────────────────
  │ Sélection image (web / desktop)
  ───────────────────────────────────*/
  Future<void> pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // on veut les bytes
    );
    if (res != null && res.files.single.bytes != null) {
      pickedBytes = res.files.single.bytes!;
      pickedImageName.value = res.files.single.name;
    }
  }

  void _resetImage() {
    pickedBytes = null;
    pickedImageName.value = '';
  }

  /*───────────────────────────────────
  │ Pré-remplit ou réinitialise le formulaire
  ───────────────────────────────────*/
  void setFormData(Winegrower? wg) {
    if (wg == null) {
      domainCtrl.clear();
      winegrowerCtrl.clear();
      terroirCtrl.clear();
      descCtrl.clear();
    } else {
      domainCtrl.text = wg.domainName;
      winegrowerCtrl.text = wg.winegrowerName;
      terroirCtrl.text = wg.terroirName;
      descCtrl.text = wg.description;
    }
    _resetImage();
  }

  /*───────────────────────────────────
  │ Ajout
  ───────────────────────────────────*/
  Future<void> addWinegrower() async {
    try {
      final doc = _f.collection('winegrowers').doc();
      final imageURL = await _uploadImageIfPicked(doc.id);
      await doc.set({
        'domainName': domainCtrl.text.trim(),
        'winegrowerName': winegrowerCtrl.text.trim(),
        'terroirName': terroirCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'imageURL': imageURL,
      });
    } catch (e) {
      Get.snackbar('Erreur', 'Ajout échoué : $e');
      print(e);
    }
  }

  /*───────────────────────────────────
  │ Mise à jour
  ───────────────────────────────────*/
  Future<void> updateWinegrower(String id, String oldURL) async {
    try {
      final imageURL = await _uploadImageIfPicked(id, replaceOld: oldURL);
      final data = {
        'domainName': domainCtrl.text.trim(),
        'winegrowerName': winegrowerCtrl.text.trim(),
        'terroirName': terroirCtrl.text.trim(),
        'description': descCtrl.text.trim(),
      };
      if (imageURL != oldURL) data['imageURL'] = imageURL;
      await _f.collection('winegrowers').doc(id).update(data);
    } catch (e) {
      Get.snackbar('Erreur', 'Mise à jour échouée : $e');
      print(e);
    }
  }

  /*───────────────────────────────────
  │ Suppression
  ───────────────────────────────────*/
  Future<void> deleteWinegrower(String id, String imageURL) async {
    try {
      await _f.collection('winegrowers').doc(id).delete();
      if (imageURL.isNotEmpty) await _s.refFromURL(imageURL).delete();
    } catch (e) {
      Get.snackbar('Erreur', 'Suppression échouée : $e');
      print(e);
    }
  }

  /*───────────────────────────────────
  │ Upload image helper
  ───────────────────────────────────*/
  Future<String> _uploadImageIfPicked(String id, {String? replaceOld}) async {
    if (pickedBytes == null) return replaceOld ?? '';

    final ext = pickedImageName.value.split('.').last.toLowerCase();
    final ref = _s.ref().child('winegrowers/$id.$ext');

    await ref.putData(
      pickedBytes!,
      SettableMetadata(contentType: 'image/$ext'),
    );

    if (replaceOld != null && replaceOld.isNotEmpty) {
      await _s.refFromURL(replaceOld).delete();
    }

    _resetImage();
    return await ref.getDownloadURL();
  }
}
