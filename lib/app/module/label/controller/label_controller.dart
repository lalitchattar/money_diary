import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_diary/app/module/label/service/label_service.dart';

import '../../../data/model/label_model.dart';

class LabelController extends GetxController {
  var labels = <Label>[].obs;
  var name = ''.obs;
  var selectedColor = '#3F51B5'.obs;
  final filteredLabels = <Label>[].obs;
  final searchQuery = ''.obs;
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
    applyFilter();
  }

  Future<void> getAllLabels() async {
    isLoading.value = true;
    final result = await labelService.getAllLabels();
    labels.assignAll(result);
    everAll([labels, searchQuery], (_) => applyFilter());
    isLoading.value = false;
  }

  Future<void> createLabel() async {
    Label label = await labelService.createLabel(name.value.trim(), selectedColor.value);
    labels.add(label);
  }

  Future<void> updateLabel({int? id, List<String>? fieldsToUpdate}) async {

    final label = Label( id: id, name: name.value, color: selectedColor.value );
    // Update in database
    await labelService.updateLabel(label, fieldsToUpdate);

    // Find index of the existing label in the list
    final index = labels.indexWhere((lbl) => lbl.id == label.id);
    if (index != -1) {
      // Update the label in memory (this auto-refreshes UI because it's an RxList)
      labels[index] = label;
    } else {
      // (optional) if not found, just add it
      labels.add(label);
    }
  }


  Future<bool> isNameExists(String labelName) async {
    return await labelService.isNameExists(labelName.trim());
  }

  void applyFilter() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredLabels.assignAll(labels);
    } else {
      final list = labels.where((label) {
        return label.name.toLowerCase().contains(query);
      }).toList();

      filteredLabels.assignAll(list);
    }
  }


  void reset() {
    name.value = '';
    selectedColor.value = '#3F51B5';
  }
}
