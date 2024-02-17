import 'package:gunluk_yapilacaklar/models/model_task.dart';
import 'package:hive/hive.dart';
// daha sonra başka bir veritabanı türüne geçme durumuna karşı abstract class içinde tanımladık
abstract class LocalStorage{
  Future<void> addTask ({required Task task});
  Future<Task> getTask ({required String id});
  Future<List<Task>> getAllTask ();
  Future<bool> deleteTask ({required Task task});
  Future<Task> updateTask ({required Task task});
}
// Abstract class fonksiyonlarını override ettik.
class HiveLocalStorage extends LocalStorage{
  // Hive Tablo tipinde verimizi oluşturduk
  late Box<Task> _taskBox;
  // Kurucu Metodu güncelliyorum
  HiveLocalStorage(){
    // Tabloyu burada oluşturuyoruz.
    _taskBox = Hive.box<Task>('tasks');
  }
  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    // Hive veritabanında id belirtmeye gerek yok o yüzden direkt delete yazıyoruz.
   await task.delete();
   return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTasks = [];
    // Hivedeki bütün verileri okuma kodu
    _allTasks = _taskBox.values.toList();
    if(_allTasks.isNotEmpty ){
      // Her birini birbiri ile zamana göre kıyaslıyor.
      _allTasks.sort(((a, b) => a.createdTime.compareTo(b.createdTime)));
    }
    return _allTasks;
  }

  @override
  Future<Task> getTask({required String id}) {
    // TODO: implement getTask
    throw UnimplementedError();
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    task.save();
    return task;
  }

}