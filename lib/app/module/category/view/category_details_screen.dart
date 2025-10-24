import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/category/controller/category_controller.dart';
import 'package:money_diary/app/module/category/view/edit_category_screen.dart';

import '../../../data/model/category_model.dart';


class CategoryDetailsScreen extends GetView<CategoryController> {
  final Category category = Get.arguments;

  CategoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merchant"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditCategoryScreen(), arguments: category);
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                title: category.isActive ? 'Deactivate Category?' : 'Activate Category?',
                titleStyle: Theme.of(context).textTheme.titleLarge,
                middleText: 'Are you sure you want to ${category.isActive ? 'deactivate' : 'activate'} ${category.name}?',
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
                            if (category.isActive) {
                              await controller.deactivateCategory(category.id!);
                            } else {
                              await controller.activateCategory(category.id!);
                            }
                            Get.until((route) => route.settings.name == '/CategoryListScreen');
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
            icon: category.isActive
                ? Icon(Icons.toggle_off)
                : Icon(Icons.toggle_on),
          ),
          IconButton(onPressed: () {
            Get.defaultDialog(
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              title: 'Delete Category?',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              middleText: 'Are you sure you want to delete ${category.name}?',
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
                          await controller.deleteCategory(category.id!);
                          Get.until((route) => route.settings.name == '/CategoryListScreen');
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
