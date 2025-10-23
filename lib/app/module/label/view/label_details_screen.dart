import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/label_model.dart';
import 'package:money_diary/app/module/label/view/edit_label_screen.dart';

import '../controller/label_controller.dart';

class LabelDetailsScreen extends GetView<LabelController> {
  final Label label = Get.arguments;

  LabelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Labels"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditLabelScreen(), arguments: label);
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                title: label.isActive ? 'Deactivate Label?' : 'Activate Label?',
                titleStyle: Theme.of(context).textTheme.titleLarge,
                middleText: 'Are you sure you want to ${label.isActive ? 'deactivate' : 'activate'} ${label.name}?',
                middleTextStyle: Theme.of(context).textTheme.bodyMedium,
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                //actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.min, // important!
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('No'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: FilledButton.tonal(
                          onPressed: () async {
                            if (label.isActive) {
                              await controller.deactivateLabel(label.id!);
                            } else {
                              await controller.activateLabel(label.id!);
                            }
                            Get.until((route) => route.settings.name == '/LabelListScreen');
                          },
                          child: const Text('Yes'),
                        ),
                      ),
                    ],
                  ),
                ],

                // actionsAlignment: MainAxisAlignment.end,
                barrierDismissible: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                radius: 16,
              );
            },
            icon: label.isActive
                ? Icon(Icons.toggle_off)
                : Icon(Icons.toggle_on),
          ),
          IconButton(onPressed: () {
            Get.defaultDialog(
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              title: 'Delete Label?',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              middleText: 'Are you sure you want to delete ${label.name}?',
              middleTextStyle: Theme.of(context).textTheme.bodyMedium,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              //actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.min, // important!
                  children: [
                    Flexible(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('No'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: FilledButton.tonal(
                        onPressed: () async {
                          await controller.deleteLabel(label.id!);
                          Get.until((route) => route.settings.name == '/LabelListScreen');
                        },
                        child: const Text('Yes'),
                      ),
                    ),
                  ],
                ),
              ],
              // actionsAlignment: MainAxisAlignment.end,
              barrierDismissible: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              radius: 16,
            );
          }, icon: Icon(Icons.delete)),
        ],
      ),
      body: Container(),
    );
  }
}
