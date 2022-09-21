import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journaling_app/pages/Journals/all_journals.dart';

import '../../sharedPreferences.dart';
import '../../utils/enums.dart';
import '../Notifications/fToast_style.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}



class _FolderPageState extends State<FolderPage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController addCategoryController = TextEditingController();

  List categories = ["General", "Travel", "Study", "Todo", "Diary", "Notes"];
  int length =0;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
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

  submitCategory()async{
    String? allCategories = await sharedPreferences.getFromSharedPref('all-categories');
    if (allCategories == null) {
      await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(categories));
      fToast.init(context);
      showToast(fToast, "Category created successfully ", NotificationStatus.success);
      setState(() {
      });
    }
    else if(addCategoryController.text.isEmpty){
    }else{
      categories.add(addCategoryController.text);
      await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(categories));
      fToast.init(context);
      showToast(fToast, "Category created successfully ", NotificationStatus.success);
      setState(() {
        
      });
    }
  }

  addCategoryWidget(){
    return showModalBottomSheet(
      shape:const RoundedRectangleBorder(
        borderRadius:BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled:true,
        builder: (context) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:18),
          child:Container(
            margin: const EdgeInsets.fromLTRB(15,15,15,15),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisSize:MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: addCategoryController,
                  decoration:InputDecoration(
                    labelText:'Enter category name',
                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 115, 115, 115),
                      ),
                    ),
                    enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 115, 115, 115),
                      ),
                    ),
                  ),
                  autofocus:true,
                ),
                Center(
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: () {
                    submitCategory();
                    Navigator.pop(context);
                  },
                ),
                )
            ],
          ),
        )
      )
    );
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
            width: 119,
            padding: EdgeInsets.all(5),
            child:GestureDetector(
              child:
              Column(
                children: [
                  const Icon(Icons.folder, size: 110,color: Color.fromARGB(255, 64, 86, 104),),
                  Text(categories[index],maxLines: 3,style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[800]),)
                  ],
                ),
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
   ),
   floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 191, 153, 14),
        onPressed: (){
            addCategoryWidget();
            setState(() {
    // Call setState to refresh the page.
          });
        },
        tooltip: 'Add',
        label: Row(children:const [ Icon(Icons.add),SizedBox(width: 5,), Text("Add a new Category")]),
      ),
   );
  }
}