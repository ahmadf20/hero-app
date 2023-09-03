import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/core/themes/app.theme.dart';
import 'app/data/models/record.model.dart';
import 'app/modules/user/controllers/user.controller.dart';
import 'app/routes/app_pages.dart';
import 'base.dart';

void main() async {
  await initializeDateFormatting('id_ID');
  WidgetsFlutterBinding.ensureInitialized();

  final path = Directory.current.path;
  Hive.init(path);

  await Hive.initFlutter();
  Hive.registerAdapter(HealthRecordAdapter());
  await Hive.openBox<HealthRecord>('records');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hero',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      locale: const Locale('id', 'ID'),
      theme: AppTheme.appThemeData,
      home: const BaseWidget(),
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
      }),
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
    );
  }
}
