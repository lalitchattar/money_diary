import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/merchant_model.dart';
import 'package:money_diary/app/module/label/view/edit_label_screen.dart';
import 'package:money_diary/app/module/merchant/controller/merchant_controller.dart';
import 'package:money_diary/app/module/merchant/view/edit_merchant_screen.dart';


class MerchantDetailsScreen extends GetView<MerchantController> {

  final Merchant merchant = Get.arguments;

  MerchantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Merchant Details"), centerTitle: true, actions: [
        IconButton(onPressed: (){
          Get.to(() => EditMerchantScreen(), arguments: merchant);
        }, icon: Icon(Icons.edit)),
        IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
      ]),
      body: Container(),
    );
  }
}
