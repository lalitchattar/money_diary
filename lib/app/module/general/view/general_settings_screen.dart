import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/general_settings_controller.dart';

class GeneralSettingsScreen extends GetView<GeneralSettingsController> {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text("General"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // Currency row
          _buildListCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Obx(
                  () => Text(
                    controller.currencySymbol.value,
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Currency',
                style: textTheme.titleMedium,
              ),
              subtitle: Obx(() => Text(
                '${controller.currency.value} — tap to change',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),),
              trailing: IconButton(
                tooltip: 'Change',
                onPressed: () => _openCurrencyPicker(context, textTheme, colorScheme),
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              onTap: () => _openCurrencyPicker(context, textTheme, colorScheme),
            ),
          ),

          // Date format row (like currency)
          _buildListCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: Icon(Icons.date_range, color: colorScheme.primary),
              title:
              Text('Date Format', style: textTheme.titleMedium),
              subtitle: Obx(() => Text('${controller.dateFormat.value} — tap to change',
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              trailing: IconButton(
                  tooltip: 'Change',
                  onPressed: () => _openDateFormatPicker(context, textTheme, colorScheme),
                  icon: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: colorScheme.onSurfaceVariant)),
              onTap: () => _openDateFormatPicker(context, textTheme, colorScheme),
            ),
          ),

          // Language row (new bottom sheet like currency)
          _buildListCard(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: Icon(Icons.language, color: colorScheme.primary),
              title: Text('Language', style: textTheme.titleMedium),
              subtitle: Obx(() => Text('${controller.languageDisplay.value} — tap to change',
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              trailing: IconButton(
                  tooltip: 'Change',
                  onPressed: () => _openLanguagePicker(context, textTheme, colorScheme),
                  icon: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: colorScheme.onSurfaceVariant)),
              onTap: () => _openLanguagePicker(context, textTheme, colorScheme),
            ),
          ),

          // First day of week (horizontally scrollable)
          _buildListCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(Icons.calendar_view_week, color: colorScheme.primary),
                  title: Text('First Day of Week'),
                  subtitle: Text('Choose start day for calendars',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                    children: controller.firstDays.map((d) {
                      final sel = d == controller.firstDay.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(d),
                          selected: sel,
                          onSelected: (_) => controller.firstDay.value = d,
                          selectedColor: colorScheme.primaryContainer,
                          showCheckmark: false,
                          labelStyle: TextStyle(
                            color: sel ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),)
                ),
              ],
            ),
          ),

          // Decimal places slider
          _buildListCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(Icons.calculate, color: colorScheme.primary),
                  title: Text('Decimal Places'),
                  subtitle: Text('Precision for money amounts',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 6),
                Obx(() =>  Row(
                  children: [
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Slider(
                            min: 0,
                            max: 4,
                            divisions: 4,
                            value: controller.decimalPlaces.toDouble(),
                            label: '${controller.decimalPlaces}',
                            onChanged: (v) => controller.decimalPlaces.value = v.round()
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${controller.decimalPlaces.value}',
                        style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )),
                const SizedBox(height: 6),
                // sample amount row
                Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Text('Sample: ',
                          style: textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Text(controller.formattedAmount,
                          style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface)),
                    ],
                  ),
                )),
              ],
            ),
          ),


          // Theme segmented
          _buildListCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(Icons.palette, color: colorScheme.primary),
                  title: Text('Theme'),
                  subtitle: Text('App appearance',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Obx(() => SegmentedButton<ThemeMode>(
                    showSelectedIcon: true,
                    segments: const [
                      ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                      ButtonSegment(value: ThemeMode.system, label: Text('System')),
                    ],
                    selected: {controller.themeMode.value},
                    onSelectionChanged: (sel) => {controller.themeMode.value = sel.first},
                  ),)
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildListCard({required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(padding: const EdgeInsets.all(8.0), child: child),
    );
  }

  void _openCurrencyPicker(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      'Select Currency',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CLOSE'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.currencies.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final c = controller.currencies[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          c['symbol']!,
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text('${c['code']}'),
                      trailing: c['code'] == controller.currency.value
                    ? Icon(Icons.check,
                        color: colorScheme.primary)
                        : null,
                      subtitle: Text(
                        'Example: ${c['symbol']} 12,345.00',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        controller.currency.value = c['code']!;
                        controller.currencySymbol.value = c['symbol']!;
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openDateFormatPicker(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  children: [
                    Text('Select Date Format',
                        style: textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CLOSE'))
                  ],
                ),
              ),
              const Divider(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.dateFormats.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final fmt = controller.dateFormats[i];
                    final sample = controller.formattedDate;
                    return ListTile(
                      title: Text(fmt),
                      subtitle: Text('Example: $sample'),
                      trailing: fmt == controller.dateFormat.value
                          ? Icon(Icons.check,
                          color: colorScheme.primary)
                          : null,
                      onTap: () {
                        controller.dateFormat.value = fmt;
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openLanguagePicker(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                child: Row(
                  children: [
                    Text('Select Language',
                        style: textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CLOSE'))
                  ],
                ),
              ),
              const Divider(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.languages.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final lang = controller.languages[i];
                    return ListTile(
                      title: Text(lang['english']!),
                      subtitle: Text(lang['native']!),
                      trailing: lang['english'] == controller.language.value
                          ? Icon(Icons.check,
                          color: colorScheme.primary)
                          : null,
                      onTap: () {
                        controller.languageDisplay.value = lang['native']!;
                        controller.language.value = lang['english']!;
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
