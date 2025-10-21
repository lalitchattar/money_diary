import 'package:flutter/material.dart';

class DatePickerPopup {
  static Future<String?> pickDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) {
        DateTime tempSelected = now;
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
              return SizedBox(
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "${now.month}/${now.year}",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: daysInMonth,
                        itemBuilder: (_, index) {
                          final day = index + 1;
                          final isSelected = tempSelected.day == day;
                          return GestureDetector(
                            onTap: () {
                              tempSelected =
                                  DateTime(now.year, now.month, day);
                              Navigator.of(context).pop(tempSelected);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "$day",
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      : Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (selectedDate != null) {
      return "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    }
    return null;
  }
}
