import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/winegrower.dart';
import '../controllers/admin_winegrowers_screen_controller.dart';
import '../../../core/routes/app_routes.dart';

class AdminWinegrowersScreen extends StatelessWidget {
  AdminWinegrowersScreen({super.key});

  final AdminWinegrowersScreenController c = Get.put(
    AdminWinegrowersScreenController(),
  );

  /*─────────────────────────────
  |  Boîte de dialogue CRUD
  ─────────────────────────────*/
  void _openForm({Winegrower? wg}) {
    // pré-remplissage ou reset
    c.setFormData(wg);

    Get.defaultDialog(
      title: wg == null ? 'Ajouter un vigneron' : 'Modifier ${wg.domainName}',
      content: SingleChildScrollView(
        child: Column(
          children: [
            _field(c.domainCtrl, 'Domaine'),
            _field(c.winegrowerCtrl, 'Nom du vigneron'),
            _field(c.terroirCtrl, 'Terroir'),
            _field(c.descCtrl, 'Description', maxLines: 3),
            const SizedBox(height: 10),
            // aperçu de l’image courante
            if (wg != null)
              Image.network(
                wg.imageURL,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            Obx(
              () => Text(
                c.pickedImageName.value.isEmpty
                    ? '(aucune nouvelle image)'
                    : 'Image : ${c.pickedImageName}',
              ),
            ),
            TextButton(
              onPressed: c.pickImage,
              child: const Text('Choisir une image'),
            ),
          ],
        ),
      ),
      textCancel: 'Annuler',
      textConfirm: 'Enregistrer',
      confirmTextColor: Colors.white,
      onConfirm: () {
        wg == null ? c.addWinegrower() : c.updateWinegrower(wg.id, wg.imageURL);
        Get.back();
      },
    );
  }

  /*─────────────────────────────
  |  Widget build
  ─────────────────────────────*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Winegrowers (admin)'),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(RoutePaths.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final list = c.winegrowers;
          if (list.isEmpty) {
            return const Center(child: Text('Aucun vigneron trouvé.'));
          }
          /*  double-scroll : vertical & horizontal  */
          return LayoutBuilder(
            builder: (_, constraints) {
              return Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('Domaine')),
                          DataColumn(label: Text('Vigneron')),
                          DataColumn(label: Text('Terroir')),
                          DataColumn(label: Text('Image')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: list.map(_row).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        tooltip: 'Ajouter',
        child: const Icon(Icons.add),
      ),
    );
  }

  /*─────────────────────────────
  |  Helpers privés
  ─────────────────────────────*/
  DataRow _row(Winegrower wg) => DataRow(
    cells: [
      DataCell(Text(wg.domainName)),
      DataCell(Text(wg.winegrowerName)),
      DataCell(Text(wg.terroirName)),
      DataCell(
        Image.network(wg.imageURL, width: 50, height: 50, fit: BoxFit.cover),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _openForm(wg: wg),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(wg),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _field(TextEditingController ctl, String label, {int maxLines = 1}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextField(
          controller: ctl,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );

  void _confirmDelete(Winegrower wg) {
    Get.defaultDialog(
      title: 'Supprimer',
      middleText: 'Supprimer ${wg.domainName} ?',
      textCancel: 'Annuler',
      textConfirm: 'Supprimer',
      confirmTextColor: Colors.white,
      onConfirm: () {
        c.deleteWinegrower(wg.id, wg.imageURL);
        Get.back();
      },
    );
  }
}
