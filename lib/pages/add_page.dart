import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journaling_app/sharedPreferences.dart';
import 'package:journaling_app/utils/emoji_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController imageLinkController = TextEditingController();
  Map<String,dynamic> journal = {
    "title":"",
    "body":"",
    "tags":"General",
    "date":null,
    "image": ""
  };  
  bool isLoading = false;
  String icon = "128218";
  String currentCategory = "General";
  List categories = ["General", "Travel", "Study", "Todo", "Diary", "Notes"];
  List<dynamic> journals=[];

  @override
  void initState() {
    // TODO: implement initState
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

  handleSubmit()async{
    if (titleController.text.isEmpty) {
      setState(() {
        isLoading=false;
      });
      print("no");
    }else{
      setState(() {
        isLoading=false;
      });
      String? allJournals  = await sharedPreferences.getFromSharedPref('user-journals');
      journal["title"] = titleController.text;
      journal["body"] = bodyController.text;
      journal["tags"] = currentCategory;
      journal["date"] = DateTime.now().toIso8601String();
      journal["image"] = icon;
      if(allJournals==null){
        journals.add(journal);
        await sharedPreferences.saveToSharedPref('user-journals',jsonEncode(journals));
        print("object");
        print(await sharedPreferences.getFromSharedPref('user-journals'));
        Navigator.of(context).pop();
      }else{
        List decoded = jsonDecode(allJournals);
        decoded.add(journal);
        await sharedPreferences.saveToSharedPref('user-journals',jsonEncode(decoded));
        print(await sharedPreferences.getFromSharedPref('user-journals'));
        Navigator.of(context).pop();
      }
    }
  }

  linkSelection(){
    return showModalBottomSheet(
      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled:true,
        builder: (context) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:18),
          child:Container(
            margin: EdgeInsets.fromLTRB(15,25,15,15),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisSize:MainAxisSize.min,
              children: <Widget>[
                Container(
                  child:TextFormField(
                    controller: imageLinkController,
                    decoration:InputDecoration(
                      labelText:'Enter your URL',
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
                ),
                Container(
                child: Center(
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    'Button',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    icon = imageLinkController.text;
                  },
                ),
                )
              )
            ],
          ),
        )
      )
    );
  }

  emojiSelection(int emojiLength){
    return showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius:BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              isScrollControlled:true,
              builder: (context) =>
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: EdgeInsets.fromLTRB(5, 25, 5, 5),
                child:SingleChildScrollView(
                  child:Column(children:[
                  Container(
                    padding: EdgeInsets.only(bottom: 25),
                    child:Center(child: Text("Tap on the emoji to select"))
                  ),
                  Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(emojiLength, (index){
                  return Container(
                    padding: EdgeInsets.all(5),
                    child:GestureDetector(child:Text(String.fromCharCodes([int.parse(emojiList[index])]),style: const TextStyle(fontSize: 30)),
                    onTap: (){
                      icon = emojiList[index];
                      Navigator.pop(context);
                    },
                  )
                );
              }
            )
          )
        ])
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        title: const Text("Add page"),
        backgroundColor: Colors.amber
      ),
      floatingActionButton: 
      isLoading?
      FloatingActionButton(
        onPressed: (){
        },
        tooltip: 'wait',
        child: const Text("submitting.... please wait"),
      ):FloatingActionButton(
        onPressed: (){
          setState(() {
            true;
          });
          handleSubmit();
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        
        child:Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  FlatButton.icon(
                    icon: Icon(Icons.link),
                    onPressed: linkSelection,
                    label: Text("Link"),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton.icon(
                    icon: Icon(Icons.face),
                    // ignore: void_checks
                    onPressed: () async {
                      int emojiLength = emojiList.length;
                      emojiSelection(emojiLength);
                    },
                    label: Text("Emoji"),
                    ),
                    FlatButton.icon(
                    icon: Icon(Icons.image),
                    // ignore: void_checks
                    onPressed: () async {
                      int emojiLength = emojiList.length;
                      emojiSelection(emojiLength);
                    },
                    label: Text("image"),
                    )
                  ],
                ),
              ),
              Container(
              child: InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none
                  ),
                  child:Container(
                    child:  DropdownButton<String>(
                    style: TextStyle(fontSize:16,color: Color.fromARGB(255, 0, 0, 0)),
                    autofocus: true,
                    value: currentCategory,
                    items: categories.map<DropdownMenuItem<String>>((t) {
                      return DropdownMenuItem<String>(
                        child: Text(t),
                        value: t,
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      currentCategory = newVal!;
                      setState(() {
                        currentCategory = newVal;
                      });
                    },             
                  )
              )),
            ),
            Container(
              child:TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Title"
                ),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
             ),
             Expanded(
                child:TextFormField(
                  controller: bodyController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Start by typing your notes here",
                    border: InputBorder.none
                  ),
            )),
            // TODO: create a select field
            // TODO: Implemet an image picker
                          
              ],
            ),
            
      )
    );
  }
}