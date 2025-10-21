import 'package:flutter/material.dart';
import 'package:money_diary/app/data/model/label_model.dart';
import 'package:money_diary/app/data/repository/label_repository.dart';

import '../../../utils/app_logger.dart';

class LabelService {

  var repo = LabelRepository();

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
    try{
      return await repo.getAllLabels();
    } catch(e, stack) {
      appLogger.e('Error creating label:', error: e, stackTrace: stack);
      return [];
    }

  }

  Future<void> createLabel(String name, String selectedColor) async {
    var label = Label(name: name.trim(), color: selectedColor);
    try{
      await repo.createLabel(label);
    } catch (e, stack) {
      appLogger.e('Error creating label:', error: e, stackTrace: stack);
    }
  }

  Future<bool> isNameExists(String labelName) async {
    final label = await repo.getLabelByName(labelName.trim());
    return label != null;
  }
}