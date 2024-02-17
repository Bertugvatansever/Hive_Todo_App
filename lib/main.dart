// Kullandığım dependenciesler flutter_datetime_picker_plus: Zaman seçme arayüzü için
// uuid: Otomatik id vermesi için
// intl: Zaman formatını düzenlemek için.
// build_runnerhive, hive_flutter, hive_generator,  build_runner : Hive veritabanı için
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:gunluk_yapilacaklar/data/local_storage.dart';
import 'package:gunluk_yapilacaklar/models/model_task.dart';
import 'package:gunluk_yapilacaklar/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

final locator = GetIt.instance;
void setup(){
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}
// Hive kurulumu için gerekli kod
Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  // Tablo açılıyor.
  var taskBox = await Hive.openBox<Task>('tasks');
  // 24 saat içinde bütün Tasklar silinecek
  for (var task in taskBox.values) {
    if(task.createdTime.day != DateTime.now().day){
      taskBox.delete(task.id);
    }
  }

}
Future<void> main() async {
  // Hive kurulumu için gerekli kod
  WidgetsFlutterBinding.ensureInitialized();
  // Appbarın yok olduğunda hafif siyah bir renk kalıyor yukarıda. Onun yok olması için gerekli kod
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
  );
  await setupHive();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white
        )
      ),
      home: const HomePage()
    );
  }
   
}

