import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/module/account/controller/account_controller.dart';
import 'app/module/general/controller/general_settings_controller.dart';
import 'app/module/more/view/more_screen.dart';
import 'app/theme/theme.dart';
import 'app/utils/icon_preloader.dart'; // ⬅️ Import your preloader

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(GeneralSettingsController());
  Get.put(AccountController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _preloaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadAssets();
    });
  }

  Future<void> _preloadAssets() async {
    await IconPreloader.preloadAll(context); // ✅ Preload icons + app directory images
    setState(() => _preloaded = true);
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

    if (!_preloaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return GetMaterialApp(
      title: 'Money Diary',
      theme: materialTheme.light(),
      home: const MoreScreen(),
    );
  }
}
