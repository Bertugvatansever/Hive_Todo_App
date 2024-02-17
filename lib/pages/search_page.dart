import 'package:flutter/material.dart';
import 'package:gunluk_yapilacaklar/data/local_storage.dart';
import 'package:gunluk_yapilacaklar/main.dart';
import 'package:intl/intl.dart';

import '../models/model_task.dart';
// Bu sayfa hazır bir sayfadır sadece içinin doldurulması gerekiyor (Arama sayfaları için)
// ignore: camel_case_types
class Search_page extends SearchDelegate {
  final List<Task> allTasks ;


  Search_page({required this.allTasks}){}
  @override
  // Arama kısmının sağ tarafındaki ikonları gösterir
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed:(){
        // query burada tanımlanan global bir değişken. Arama yerine yazdığımız yazıyı temsil ediyor.
        query.isEmpty ? null : query = '';

      }, icon: const Icon(Icons.clear))
    ];
  }

  @override
  // Soldaki ikonları gösterir
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(Icons.arrow_back_ios,color: Colors.black)
      );
  }

  @override
  // Arama yaptıktan sonra sonuçların nasıl gösterileceği
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTasks.where((element) => element.taskName.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.isNotEmpty
    // Searchpage içinde set state kullanılmadığı için StatefulBuilder çağırdım.
      ? StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var oankiEleman = filteredList[index];
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
                  key: Key(oankiEleman.id),
                  onDismissed: (direction) {
                    setState(() {
                      filteredList.removeAt(index);
                      locator<LocalStorage>().deleteTask(task: oankiEleman);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10)
                      ],
                    ),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          setState(() {
                            oankiEleman.isCompleted =
                                !oankiEleman.isCompleted;
                            locator<LocalStorage>()
                                .updateTask(task: oankiEleman);
                          });
                        },
                        child: Container(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey, width: 0.8),
                            shape: BoxShape.circle,
                            color: oankiEleman.isCompleted
                                ? Colors.green
                                : Colors.white,
                          ),
                        ),
                      ),
                      title: oankiEleman.isCompleted
                          ? Text(oankiEleman.taskName,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey))
                          : Text(oankiEleman.taskName),
                      trailing: Text(
                        DateFormat('hh:mm a')
                            .format(oankiEleman.createdTime),
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
              itemCount: filteredList.length,
            );
          },
        )
      : const Center(child: Text("Aradığınızı Bulamadık"));
}

  @override
  // Kullanıcı bir iki harf yazdığında veya hiçbir şey yazmadığında görünmesini isteyeceğimiz şeyler.
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}