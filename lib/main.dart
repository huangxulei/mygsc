import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mygsc/pages/main/loading_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'common/sql_helper.dart';
import 'common/utils.dart';
import 'pages/main/error_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1000, 700),
      center: true,
      // backgroundColor: Colors.white,
      skipTaskbar: false,
      // titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    windowManager.setMaximizable(false);
    windowManager.setResizable(false);
  }
  runApp(const InitPage());
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  late StackTrace _stackTrace;
  dynamic _error;
  InitFlag initFlag = InitFlag.wait;

  @override
  void initState() {
    () async {
      try {
        //初始化数据库
        await SQLHelper.initialDatabase();
        initFlag = InitFlag.ok;
      } catch (e, st) {
        _error = e;
        _stackTrace = st;
        initFlag = InitFlag.error;
      }
      setState(() {});
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (initFlag) {
      case InitFlag.ok:
        return Container();

      case InitFlag.error:
        return MaterialApp(
          darkTheme: ThemeData.dark(),
          home: ErrorApp(error: _error, stackTrace: _stackTrace),
        );
      default:
        return const MaterialApp(
          home: LoadingPage(),
        );
    }
  }
}
