import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/module/general/controller/general_settings_controller.dart';
import 'app/module/more/view/more_screen.dart';
import 'app/theme/theme.dart';


Future<void> main() async {

  Get.put(GeneralSettingsController());
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.primaryOf(context);
    final materialTheme = MaterialTheme(textTheme);

    return GetMaterialApp(
      title: 'Money Diary',
      theme: materialTheme.light(),
      home: const MoreScreen(),
    );
  }
}