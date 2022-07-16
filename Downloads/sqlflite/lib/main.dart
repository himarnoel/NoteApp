import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:sqlflite/ui/inner.dart';
import 'package:sqlflite/ui/ui.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS || kIsWeb) {
    databaseFactory = databaseFactoryFfi;
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.amber),
      initialRoute: NoteUi.id,
      routes: {
        NoteUi.id: (context) => const NoteUi(),
        Inner.id: (context) => const Inner()
      },
    );
  }
}
