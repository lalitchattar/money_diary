import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_diary/app/data/repository/label_repository.dart';
import 'package:money_diary/app/module/label/service/label_service.dart';

import '../../../data/model/label_model.dart';

class LabelController extends GetxController {
  var labels = <Label>[].obs;
  var name = ''.obs;
  var selectedColor = '#3F51B5'.obs;
  var isLoading = false.obs;

  var labelService = LabelService();

  List<Color> get colorOptions => labelService.colorOptions;

  String colorToHex(Color color) {
    return labelService.colorToHex(color);
  }

  @override
  void onInit() async {
    if(labels.isEmpty) {
      await getAllLabels();
    }
    super.onInit();
  }

  Future<void> getAllLabels() async {
    isLoading.value = true;
    final result = await labelService.getAllLabels();
    labels.assignAll(result);
    isLoading.value = false;
  }

  Future<Label> createLabel() async {
    return await labelService.createLabel(name.value.trim(), selectedColor.value);
  }

  /*Future<void> updateLabel({int? id, List<String>? fieldsToUpdate}) async {
    try{
      final label = Label(
          id: id,
          name: name.value,
          color: color.value
      );
      await repository.updateLabel(label, fieldsToUpdate: fieldsToUpdate);
      await getAllLabels();
    } catch (e, stack) {
      appLogger.e('Error updating label id: $id', error: e, stackTrace: stack);
    }
  }*/

  Future<bool> isNameExists(String labelName) async {
    return await labelService.isNameExists(labelName.trim());
  }

  void reset() {
    name.value = '';
    selectedColor.value = '#3F51B5';
  }
}
