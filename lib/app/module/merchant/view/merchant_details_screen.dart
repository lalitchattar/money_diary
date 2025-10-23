import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/module/merchant/controller/merchant_controller.dart';
import 'package:money_diary/app/module/merchant/view/edit_merchant_screen.dart';

import '../../../data/model/merchant_model.dart';

class MerchantDetailsScreen extends GetView<MerchantController> {
  final Merchant merchant = Get.arguments;

  MerchantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Merchant"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditMerchantScreen(), arguments: merchant);
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                title: merchant.isActive ? 'Deactivate Merchant?' : 'Activate Merchant?',
                titleStyle: Theme.of(context).textTheme.titleLarge,
                middleText: 'Are you sure you want to ${merchant.isActive ? 'deactivate' : 'activate'} ${merchant.name}?',
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
                            if (merchant.isActive) {
                              await controller.deactivateMerchant(merchant.id!);
                            } else {
                              await controller.activateMerchant(merchant.id!);
                            }
                            Get.until((route) => route.settings.name == '/MerchantListScreen');
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
            icon: merchant.isActive
                ? Icon(Icons.toggle_off)
                : Icon(Icons.toggle_on),
          ),
          IconButton(onPressed: () {
            Get.defaultDialog(
              titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              title: 'Delete Label?',
              titleStyle: Theme.of(context).textTheme.titleLarge,
              middleText: 'Are you sure you want to delete ${merchant.name}?',
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
                          await controller.deleteMerchant(merchant.id!);
                          Get.until((route) => route.settings.name == '/MerchantListScreen');
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
