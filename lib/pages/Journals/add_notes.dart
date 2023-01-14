import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journaling_app/pages/Journals/home.dart';
import 'package:journaling_app/sharedPreferences.dart';
import 'package:journaling_app/utils/emoji_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/enums.dart';
import '../../utils/numeric_check.dart';
import '../Notifications/fToast_style.dart';

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
  TextEditingController addCategoryController = TextEditingController();
  Map<String,dynamic> journal = {
    "title":"",
    "body":"",
    "tags":"General",
    "date":null,
    "image": ""
  }; 
  late FToast fToast; 
  bool isLoading = false;
  String icon = "128218";
  String emoticon = "129489";
  late Widget profileIcon = Center(
        child:Text(
        String.fromCharCodes([int.parse(emoticon)]),
        style: const TextStyle(fontSize: 45),
      ));
  String currentCategory = "General";
  List categories = ["General"];
  List<dynamic> journals=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
    setProfileIcons(emoticon);
    fToast = FToast();
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
      setState(() {
      });
    }
    else if(addCategoryController.text.isEmpty){
      fToast.init(context);
      showToast(fToast, "Category cannot be empty", NotificationStatus.failure);
    }else{
      categories.add(addCategoryController.text);
      await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(categories));
      setState(() {
        
      });
    }
  }

  handleSubmit()async{
    if (titleController.text.isEmpty) {
      fToast.init(context);
      showToast(fToast, "Title cannot be left empty", NotificationStatus.failure);
      setState(() {
        isLoading=false;
      });
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
        fToast.init(context);
        showToast(fToast, "Note created successfully. Please refresh to view your newly created note", NotificationStatus.success);
        setState(() {
          isLoading=false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const HomePage(),
                    ),
                  );
      }else{
        List decoded = jsonDecode(allJournals);
        decoded.add(journal);
        await sharedPreferences.saveToSharedPref('user-journals',jsonEncode(decoded));
        fToast.init(context);
        showToast(fToast, "Note created successfully. Please refresh to view your newly created note", NotificationStatus.success);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const HomePage(),
                    ),
                  );
      }
    }
  }

  void setProfileIcons(emoji) async {
    emoticon =
      emoji["image"] != ""
      ? emoji["image"]
    : "128218";
    if (isNumeric(emoticon)) {
      profileIcon = Center(
        child:Text(
        String.fromCharCodes([int.parse(emoticon)]),
        style: const TextStyle(fontSize: 45),
      ));
    } else {
      profileIcon = SizedBox(
          child: Center(
        child: Image(height: 150, width: 150, image: NetworkImage(emoticon)),
      ));
    }
  }

  setInitialProfileIcons(int emojiLength) async {
    emoticon = emojiList[emojiLength];
    if (isNumeric(emoticon)) {
      profileIcon = Center(
        child:Text(
        String.fromCharCodes([int.parse(emoticon)]),
        style: const TextStyle(fontSize: 45),
      ));
      setState(() {
      });
    } else {
      profileIcon = SizedBox(
          child: Center(
        child: Image(height: 150, width: 150, image: NetworkImage(emoticon)),
      ));
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

  linkSelection(){
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius:BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled:true,
        builder: (context) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:18),
          child:Container(
            margin: const EdgeInsets.fromLTRB(15,25,15,15),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisSize:MainAxisSize.min,
              children: <Widget>[
                TextFormField(
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
                Center(
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
            ],
          ),
        )
      )
    );
  }

  emojiSelection(int emojiLength){
    return showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius:BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              isScrollControlled:true,
              builder: (context) =>
              Container(
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.fromLTRB(5, 25, 5, 5),
                child:SingleChildScrollView(
                  child:Column(children:[
                  Container(
                    padding: const EdgeInsets.only(bottom: 25),
                    child:const Center(child: Text("Tap on the emoji to select"))
                  ),
                  Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(emojiLength, (index){
                  return Container(
                    padding: const EdgeInsets.all(5),
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
      backgroundColor: const Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        title: const Text("Add Notes", style: TextStyle(color: Colors.black38),),
        backgroundColor: Colors.amber
      ),
      floatingActionButton: 
      isLoading?
      FloatingActionButton.extended(
        onPressed: (){
        },
        tooltip: 'wait',
        label: const Text("submitting.... please wait"),
      ):FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 191, 153, 14),
        onPressed: (){
          setState(() {
            true;
          });
          handleSubmit();
        },
        tooltip: 'Add',
        label: Row(children: const [Icon(Icons.add),SizedBox(width: 5),Text("Save note")]),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(15,15,15,15),
        child:Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child:Container(
              padding: EdgeInsets.fromLTRB(2, 10, 3, 10),  
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Color.fromARGB(255, 220, 215, 179)
              ),
              child:Row(
              children:[ 
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0, top: 2.0, left: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      color: Colors.white,
                      child: profileIcon,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    padding: EdgeInsets.only(left: 15,),
                    child:Text("Select your cover image here"),
                  ),                
                  Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlatButton.icon(
                        icon: const Icon(Icons.link),
                        onPressed: linkSelection,
                        label: const Text("Link"),
                      ),
                      // ignore: deprecated_member_use
                      FlatButton.icon(
                        icon: const Icon(Icons.face),
                        // ignore: void_checks
                        onPressed: () async {
                          int emojiLength = emojiList.length;
                          emojiSelection(emojiLength);
                          setInitialProfileIcons(emojiLength);
                        },
                        label: const Text("Emoji"),
                        ),
                        // FlatButton.icon(
                        // icon: const Icon(Icons.image),
                        // // ignore: void_checks
                        // onPressed: () async {
                        //   int emojiLength = emojiList.length;
                        //   emojiSelection(emojiLength);
                        // },
                        // label: const Text("image"),
                        // )
                      ],
                    ),
                    ],)
              ]))),
              Row(
                children: [         
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    width:MediaQuery.of(context).size.width * 0.75 ,
                    child:InputDecorator(
                  decoration: InputDecoration(
                    border: InputBorder.none
                  ),
                  child:DropdownButton<String>(
                  style: const TextStyle(fontSize:16,color: Color.fromARGB(255, 0, 0, 0)),
                  autofocus: true,
                  value: currentCategory,
                  items: categories.map<DropdownMenuItem<String>>((t) {
                    return DropdownMenuItem<String>(
                      value: t,
                      child: Text(t),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    currentCategory = newVal!;
                    setState(() { currentCategory = newVal; });
                  },             
                )
              ),
              ),
              const SizedBox(width: 25,
              height: 0,),
              GestureDetector(
                onTap: () {
                  addCategoryWidget();
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 220, 215, 179),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child:Icon(Icons.add)),
              ),],
              ),
            Container(
              margin: EdgeInsets.only(right: 13),
            child:TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your title here"
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ),
             Expanded(
              child:TextFormField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Start by typing your notes here",
                  border: InputBorder.none
                ),
              )
            ),  
        ],  
        ),      
      )
    );
  }
}