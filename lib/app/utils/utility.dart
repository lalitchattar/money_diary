import 'package:flutter/material.dart';

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // add alpha if missing
  }
  return Color(int.parse(hexColor, radix: 16));
}


String maskString(String input, {int maskLength = 4}) {
  if (input.isEmpty) return '';

  // Ensure maskLength is 4 or 5
  maskLength = maskLength.clamp(4, 5);

  // Get last 4 characters
  final visiblePart = input.length <= 4 ? input : input.substring(input.length - 4);

  // Return masked string
  return '${'*' * maskLength}$visiblePart';
}

String getDateWithSuffix(int day) {
  if (day >= 11 && day <= 13) return '${day}th';
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }

}

String formatToDecimal(String value, int decimals) {
  try {
    double number = double.parse(value);
    return number.toStringAsFixed(decimals);
  } catch (e) {
    return value; // Return original if parsing fails
  }
}

