import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datetTimePicker;
import 'package:gunluk_yapilacaklar/data/local_storage.dart';
import 'package:gunluk_yapilacaklar/models/model_task.dart';
import 'package:gunluk_yapilacaklar/pages/search_page.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // görevlerimi tutmak için Task tipinde bir liste oluşturdum
  late List<Task> _allTasks;
  late LocalStorage _localStorage;
  @override
  // Uygulama her açıldığında Listemiz oluşturuluyor.
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    getAllTaskFromDb();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // tıklayınca işlem gerçekleştirmek için Gesturedetector kullanıldı.
        title: GestureDetector(
          onTap: () {
            showAddTaskBottomSheet(context);
          },
          // const daha optimize kod için
          child: const Text(
            "Bugün Neler Yapacaksın ? ",
            style:TextStyle(color: Colors.black),         
            ),
        ),
      // iosda yazılar direkt ortaya geldiği için bunu engelliyoruz.
      centerTitle: false,
      //Appbarra buton ekleme
      actions: [
        IconButton(onPressed:(){
          showSearchPage();
        }, icon: const Icon(Icons.search)),
        IconButton(onPressed:(){
          // Görev ekleme fonksiyonu
          showAddTaskBottomSheet(context);
        },
        icon: const Icon(Icons.add))
      ],
      ),
      // Eğer Liste boş değil ise listeyi ekrana yazdır Boş ise Mevcut yazıyı yazdır ? (true) : (false)
      body: _allTasks.isNotEmpty ? ListView.builder(itemBuilder: (context, index) {
        var oankiEleman = _allTasks[index];
        // Dismissible Kaydırarak Yok etmede kullandığımız bir widget
        return Dismissible(
          background: Container(
            color: Color.fromARGB(255, 226, 72, 51),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 8,),
                Icon(Icons.delete),
                SizedBox(width: 8,),
                Text("Bu Aktivite Silindi.")
              ],
            ),
          ),
          // Yok edeceği elemanın Keyini istiyor.
          key: Key(oankiEleman.id),
          // Kaydırma Şekli Belirleniyor.
          onDismissed: (direction) {
            _allTasks.removeAt(index);
            _localStorage.deleteTask(task: oankiEleman);
            setState(() {
              
            });
          },
          child: Container(
            margin:const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              // Köşeyi Ovalleştirir
              borderRadius: BorderRadius.circular(8),
              // Köşe görüntü ayarlamaları
              boxShadow: [
                // Siyahın farklı tonunu yakalamak için opacity ile kullandık
                // Blur radius ise şiddeti
                BoxShadow(color: Colors.black.withOpacity(0.2),blurRadius: 10)
                ]
            ),
            // Aktivitenin yapılıp yapılmadığının işlemleri burada
            child: ListTile(
              leading: GestureDetector(onTap: () {  
                oankiEleman.isCompleted = !oankiEleman.isCompleted;
                _localStorage.updateTask(task: oankiEleman);
                setState(() {
                  
                });            
              },
              child: Container(
                child: const Icon(
                  Icons.check,color: Colors.white,
                  ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 0.8),
                  shape: BoxShape.circle,
                  color: oankiEleman.isCompleted ? Colors.green : Colors.white 

                ),
                ),

              ),
              title: oankiEleman.isCompleted ? Text(oankiEleman.taskName,style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey))
              : Text(oankiEleman.taskName),
              trailing: Text(DateFormat('hh:mm a').format(oankiEleman.createdTime),style: TextStyle(fontSize: 16,color: Colors.grey),),
                  
            ),
          ),
        );
      },itemCount: _allTasks.length)
      : const Center(child: Text("Hadi görev ekleyelim"),)
    );
  }

  void showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        // ekranın genişliğini aldı
        width: MediaQuery.of(context).size.width,
        // Klavye açıldığında gereken boşluğu verdi
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListTile(
          title: TextField(
            decoration: const InputDecoration(hintText: "Ne eklemek istersiniz ?",border: InputBorder.none),
            style: const TextStyle(fontSize: 20),
            onSubmitted: (value) {
              // Navigator sayfa yönlendirme işlemleri için kullanıldı.
              // Popun içi boş bırakılarak mevcut sayfaya dönmesi gerçekleştirildi.
              Navigator.of(context).pop();
              // işlemin yapılacağı saati seçtireceğiz
              if (value.length > 3) {
                datetTimePicker.DatePicker.showTimePicker(context,onConfirm: (time) async {
                var newTask = Task.create(taskName: value, createdTime: time);
                _allTasks.add(newTask);
                await _localStorage.addTask(task: newTask);     
                setState(() {
            
                });
              },showSecondsColumn: false);
              }     
            
            },
          ),
        )
  
      );
    });
  }
  void getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {
      
    });
  }
  
  void showSearchPage() async {
   await showSearch(context: context, delegate: Search_page(allTasks: _allTasks));
    getAllTaskFromDb();
  } 
}