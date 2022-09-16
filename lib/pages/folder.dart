import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journaling_app/pages/all_journals.dart';

import '../sharedPreferences.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}



class _FolderPageState extends State<FolderPage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  List categories = ["General", "Travel", "Study", "Todo", "Diary", "Notes"];
  int length =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(categories.length);
    getCategories();
  }

    getCategories()async {
    String? allCategories = await sharedPreferences.getFromSharedPref('all-categories');
    if (allCategories == null) {
      await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(categories));
    } else {
      List  setCategories = jsonDecode(allCategories);
      setState(() {
        categories = setCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        title: const Text("Categories", style: TextStyle(color: Color.fromARGB(255, 93, 22, 22), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
      ),
      body:
        SingleChildScrollView(
        child:Wrap(
                  direction: Axis.horizontal,
                  
                  children: List.generate(categories.length, (index){
                  return Container(
                    padding: EdgeInsets.all(5),
                    child:GestureDetector(

                          child:
                          Column(

                            children: [
                        
                          Icon(Icons.folder, size: 110,color: Color.fromARGB(255, 64, 86, 104),),
                          Text(categories[index],style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[800]),)
                          ],),

                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  AllJournals(tag: categories[index],)),
                      );
                    },
                  )
                );
              }
            )
          )
   ));
  }
}