import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_diary/app/data/model/label_model.dart';
import 'package:money_diary/app/module/label/view/edit_label_screen.dart';
import 'package:money_diary/app/module/merchant/controller/merchant_controller.dart';


class LabelDetailsScreen extends GetView<MerchantController> {

  final Label label = Get.arguments;

  LabelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(label.name);
    return Scaffold(
      appBar: AppBar(title: const Text("Labels"), centerTitle: true, actions: [
        IconButton(onPressed: (){
          Get.to(() => EditLabelScreen(), arguments: label);
        }, icon: Icon(Icons.edit)),
        IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
      ]),
      body: Container(),
    );
  }
}
