
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/model/label_model.dart';
import '../service/label_service.dart';

class LabelController extends GetxController {
  final labels = <Label>[].obs;
  final filteredLabels = <Label>[].obs;
  final searchQuery = ''.obs;

  final name = ''.obs;
  final selectedColor = '#3F51B5'.obs;
  final isLoading = false.obs;

  late TextEditingController labelNameController;

  final LabelService labelService;

  LabelController({LabelService? service}) : labelService = service ?? LabelService();

  List<Color> get colorOptions => labelService.colorOptions;
  String colorToHex(Color color) => labelService.colorToHex(color);

  @override
  void onInit() {
    super.onInit();

    labelNameController = TextEditingController();

    // Fetch once
    _fetchLabels();

    // Debounced filter
    ever(searchQuery, (_) => _applyFilter());
    ever(labels, (_) => _applyFilter());
  }

  Future<void> _fetchLabels() async {
    isLoading.value = true;
    labels.assignAll(await labelService.getAllLabels());
    isLoading.value = false;
  }

  Future<void> createLabel() async {
    final newLabel = await labelService.createLabel(name.value.trim(), selectedColor.value);
    if (newLabel != null) {
      labels.add(newLabel); // local update
      reset();
    }
  }

  Future<void> updateLabel({required int id, List<String>? fieldsToUpdate}) async {
    Label? label = await labelService.getLabel(id);
    if(label != null) {
      label.name = name.value.trim();
      label.color = selectedColor.value;
      await labelService.updateLabel(label, fieldsToUpdate);

      // Update locally
      final index = labels.indexWhere((e) => e.id == id);
      if (index != -1) labels[index] = label;
      reset();
    }
  }

  Future<void> deleteLabel(int id) async {
    await labelService.deleteLabel(id);
    labels.removeWhere((e) => e.id == id);
    reset();
  }

  Future<void> deactivateLabel(int id) async {
    await labelService.deactivateLabel(id);
    final index = labels.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedLabel = labels[index].copyWith(isActive: false);
      labels[index] = updatedLabel; // triggers update
    }
    reset();
  }

  Future<void> activateLabel(int id) async {
    await labelService.activateLabel(id);
    final index = labels.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updatedLabel = labels[index].copyWith(isActive: true);
      labels[index] = updatedLabel; // triggers update
    }
    reset();
  }



  Future<bool> isNameExists(String labelName) async {
    return await labelService.isNameExists(labelName.trim());
  }



  void _applyFilter() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredLabels.assignAll(labels);
    } else {
      filteredLabels.assignAll(
        labels.where((l) => l.name.toLowerCase().contains(query)),
      );
    }
  }

  void reset() {
    name.value = '';
    selectedColor.value = '#3F51B5';
    labelNameController.clear();
  }

  @override
  void onClose() {
    labelNameController.dispose(); // dispose when controller is removed
    super.onClose();
  }
}

