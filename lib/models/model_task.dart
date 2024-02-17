// Hive veritabanı kullanıyorum. Nasıl kullandım
// Gerekli şeyler import edildi
// Gereken importlar : build_runnerhive, hive_flutter, hive_generator,  build_runner, get_it
// Hive veritabanı nasıl kullanılır : Öncelikle kütüphaneler import edilir. Ardından Local veritabanı için bir abstract class ve Hive veritabanı override oluşturulur
// Hangi veriler veritabanında tutulacaksa oraya önce @HiveType tanımlanır daha sonrasında her verinin üstüne @Hivefield ile değer girilir
// Main.dart a giderek önce bir locator oluşturulur ardından gerekli kodlar program çalışmaya başlamadan önce sırasıyla yazılır.

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'model_task.g.dart';

@HiveType(typeId: 0)

class Task extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String taskName;
  @HiveField(2)
  final DateTime createdTime;
  @HiveField(3)
  bool isCompleted;
  // Constructor oluşturduk ve bütün alanların dolması gerektiğini belirttik
  Task({required this.id, required this.taskName, required this.createdTime,required this.isCompleted});

  factory Task.create({required String taskName,required DateTime createdTime}){
    // Uuid bize otomatik id oluşturan bir Yöntemdir. Buradaki v1 mevcut zamanı stringe döndürerek bize bir id döndürecek.
    return Task(id: const Uuid().v1(), taskName: taskName, createdTime: createdTime, isCompleted: false);
  }

}