import 'package:flutter/material.dart';

import '../../../data/model/label_model.dart';
import '../../../data/repository/label_repository.dart';
import '../../../utils/app_logger.dart';

class LabelService {
  final LabelRepository repo;

  LabelService({LabelRepository? repository}) : repo = repository ?? LabelRepository();

  final List<Color> colorOptions = const [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  String colorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  Future<List<Label>> getAllLabels() async {
    try {
      return await repo.getAllLabels();
    } catch (e, stack) {
      appLogger.e('Error fetching labels', error: e, stackTrace: stack);
      return [];
    }
  }

  Future<Label?> createLabel(String name, String selectedColor) async {
    final label = Label(name: name, color: selectedColor);
    try {
      return await repo.createLabel(label);
    } catch (e, stack) {
      appLogger.e('Error creating label', error: e, stackTrace: stack);
      return null;
    }
  }

  Future<void> updateLabel(Label label, List<String>? fieldsToUpdate) async {
    try {
      await repo.updateLabel(label, fieldsToUpdate: fieldsToUpdate);
    } catch (e, stack) {
      appLogger.e('Error updating label', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> deactivateLabel(int id) => repo.deactivateLabel(id);
  Future<void> activateLabel(int id) => repo.activateLabel(id);
  Future<void> deleteLabel(int id) => repo.deleteLabel(id);

  Future<bool> isNameExists(String labelName) async {
    return (await repo.getLabelByName(labelName)) != null;
  }

  Future<Label?> getLabel(int id) async {
    return await repo.getLabel(id);
  }

  Future<Label?> getLabelByName(String name) async {
    return await repo.getLabelByName(name);
  }
}
