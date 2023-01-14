import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journaling_app/pages/Journals/all_checklists.dart';
import 'package:journaling_app/pages/Settings/settings.dart';
import 'package:journaling_app/sharedPreferences.dart';
import '../../utils/enums.dart';
import '../../utils/numeric_check.dart';
import '../Notifications/fToast_style.dart';
import 'add_notes.dart';
import 'edit_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController addChecklistController = TextEditingController();

  List<dynamic> journals = [];
  late Widget profileIcon;
  late String? name = "";
  late FToast fToast;
  String emoticon = "129489";
  Map<String, dynamic> checklist_map = {
    "task":"",
    "status":false
  };
 

  @override
  void initState() {
    super.initState();
    setName();
    fToast = FToast();
  }
  
  setName() async {
    String? userName = await sharedPreferences.getFromSharedPref("user-name");
    setState(() {
      name = userName;
    });
  }

  setJournals()async{
    String? allJournals  = await sharedPreferences.getFromSharedPref('user-journals');
    if (allJournals!=null) {
      List<dynamic> notesDecoded = jsonDecode(allJournals);
      List reversedList = List.from(notesDecoded.reversed);
      return reversedList;
    }
  }

  setChecklists()async{
    String? allChecklists  = await sharedPreferences.getFromSharedPref('all-checklist');
    if (allChecklists!=null) {
      List<dynamic> taskDecoded = jsonDecode(allChecklists);
      List reversedList = List.from(taskDecoded.reversed);
      if(reversedList.length>3){
      var myRange = reversedList.getRange(0, 3).toList();
      return myRange;
      }else{
        return reversedList;
      }
    }
  }

  removeNote(int index)async{
    String? allNotes = await sharedPreferences.getFromSharedPref('user-journals');
    if (allNotes!=null) {
      List notesDecoded = jsonDecode(allNotes);
      List notesReversed = List.from(notesDecoded.reversed);
      notesReversed.removeAt(index);
      List finalList = List.from(notesReversed.reversed);
      await sharedPreferences.saveToSharedPref('user-journals', jsonEncode(finalList));
      setState(() {
        
      });
    }
  }

  
  removeItem(int index) async {
    String? allChecklists  = await sharedPreferences.getFromSharedPref('all-checklist');
    if(allChecklists!=null){
      List decodedList = jsonDecode(allChecklists);
      List reversedList = List.from(decodedList.reversed);
      reversedList.removeAt(index);
      List finalList = List.from(reversedList.reversed);
      await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(finalList));
      setState(() {
      });
    }
  }

  taskUpdation(int index) async{
    String? allChecklists  = await sharedPreferences.getFromSharedPref('all-checklist');
    if(allChecklists!=null){
      List<dynamic> taskDecoded = jsonDecode(allChecklists);
      List reversedList = List.from(taskDecoded.reversed);
      reversedList.removeAt(index);
      await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(reversedList));
      fToast.init(context);
      showToast(fToast, "Task added to the task list successfully ", NotificationStatus.success);
    }
  }

  submitCheckLists()async{
    checklist_map["task"] = addChecklistController.text;
    if(addChecklistController.text.isEmpty){
      fToast.init(context);
      showToast(fToast, "Task cannot be empty", NotificationStatus.failure);
    }else{
      String? allChecklists  = await sharedPreferences.getFromSharedPref('all-checklist');
      if (allChecklists!=null) {
        List decodedChecklists = jsonDecode(allChecklists);
        decodedChecklists.add(checklist_map);
        await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(decodedChecklists));
        fToast.init(context);
        showToast(fToast, "Task added to the task list successfully ", NotificationStatus.success);
        setState(() {
          
        });
      }else{
        List checklist = [];
        checklist.add(checklist_map);
        await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(checklist));
        fToast.init(context);
        showToast(fToast, "Task added to the task list successfully ", NotificationStatus.success);
        setState(() {
          
        });
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              color: Colors.amber),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
        Row(
          children: [
          Image.asset('assets/images/logo-journalit-2.png', width: 55,height: 55,),
          const SizedBox(width: 10,),
          Text("Welcome, $name",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Color.fromARGB(255, 52, 63, 71)))]),
        GestureDetector(child: const Icon(Icons.settings,size: 30,color:Color.fromARGB(131, 0, 0, 0),),
        onTap:(){
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => 
                SettingsPage()),
              );
        },)]),
        backgroundColor: Color.fromARGB(255, 219, 210, 127),
        elevation: 0,
        
      ),
      body:Container(
        
      child:ListView(children: [
      SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child:SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[ 
            GestureDetector(
              onTap: () {
                setState(() { 
                });
              },
              child: Container(
              padding: const EdgeInsets.only(left:20,top: 15, bottom: 10, right: 20),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                
                const Text("All Journals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 52, 63, 71)),
                ),
                Row(
                children: const [
                  Text("Refresh",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 86, 127, 160)),
                  ),
                  Icon(Icons.refresh, size: 17,color:Color.fromARGB(255, 86, 127, 160))
                  ],
                )
                
              ],) 
            ),
            ),
            FutureBuilder(
            future: setJournals(),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(child:Text('No notes to display'));
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text("No notes to display"));
              } else {
                return Container(
                  margin: EdgeInsets.only(left:8, right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 220, 215, 179)
                  ),
                  child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        setProfileIcons(snapshot.data[index]);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                          height: 79,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                              ),
                          child: GestureDetector(
                            onTap: (){
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => 
                                  EditPage(
                                    title: snapshot.data[index]["title"],
                                    body: snapshot.data[index]["body"],
                                    tag: snapshot.data[index]["tags"],
                                    index: index,
                                  )
                                )
                              );
                            },
                            child:Card(
                              elevation: 1,
                              margin: EdgeInsets.zero,
                              color:  Colors.grey[100],
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(left: 8, bottom: 4, top: 2, right: 4),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6.0, top: 2.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Container(
                                          height: 60.0,
                                          width: 60.0,
                                          color: Colors.grey[300],
                                          child: profileIcon,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child:Text(snapshot.data[index]["title"],
                                          maxLines:1,
                                          style: const TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                      Row(children: [Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 5),
                                        child: GestureDetector( 
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => 
                                              EditPage(
                                                title: snapshot.data[index]["title"],
                                                body: snapshot.data[index]["body"],
                                                tag: snapshot.data[index]["tags"],
                                                index: index,
                                              )
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Color.fromARGB(137, 105, 105, 105),
                                          size: 22,
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: GestureDetector( 
                                        onTap: (){
                                          removeNote(index);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(137, 105, 105, 105),
                                          size: 22,
                                          )
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ),
                            )
                          )
                        );
                      }
                    )
                  ]
                )
              );
            }
          }
        )
      ]
    ))),
    Container(
        child:Column(children: [
        Container(
          padding: const EdgeInsets.only(left:20,top: 10, bottom: 5, right: 20),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Text("Task List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 52, 63, 71)),
              ),
              Row(
                children: [
                GestureDetector(child:Text("Show All",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 86, 127, 160)),
              ),
              onTap: (){
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => 
                AllChecklist()),
              );
              },),
                ],
              )
          ],)
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10,0,10,0),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
              shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.vertical(top: Radius.circular(25.0))),
                context: context,
                isScrollControlled:true,
                builder: (context) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:18),
                  child:Container(
                    margin: EdgeInsets.fromLTRB(15,15,15,15),
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      mainAxisSize:MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child:TextFormField(
                            controller: addChecklistController,
                            decoration:InputDecoration(
                              labelText:'Enter your task',
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
                            'Submit',
                            style: TextStyle(fontSize: 17),
                          ),
                          onPressed: () {
                            submitCheckLists();
                            Navigator.pop(context);
                          },
                        ),
                        )
                      )
                    ],
                  ),
                )
              )
            );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius:  BorderRadius.circular(10)                        
                ),
              margin: EdgeInsets.fromLTRB(5,8,5,10),
              padding: EdgeInsets.all(7),
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Task", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 52, 63, 71))),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),
        ),
        FutureBuilder(
            future: setChecklists(),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(child:Text('error'));
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text("No tasks created"));
              } else {
                return Container(
                  margin: const EdgeInsets.only(left:10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 220, 215, 179)
                  ),
                  child:
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      ListView.builder(
                      padding: const EdgeInsets.only(top: 5),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        print(snapshot.data);
                        return Container(
                          margin: const EdgeInsets.only( left: 10, right: 10, bottom: 8),
                          height: 43,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                              ),
                          child: Card(
                            elevation: 1,
                            margin: EdgeInsets.zero,
                            color:  Colors.grey[100],
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 0, right: 4,bottom: 10),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: snapshot.data[index]["status"], 
                                    onChanged: (val) async {
                                        val = val==false?true:false;
                                        snapshot.data[index]["status"] = val==false?true:false;
                                        List reversedTaskList = List.from(snapshot.data.reversed);
                                        await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(reversedTaskList));
                                        setState(() {
                                        });
                                    }),
                                  // const SizedBox(width: 5),
                                    Expanded(
                                      child:Text(snapshot.data[index]["task"],
                                        maxLines:1,
                                        style: snapshot.data[index]["status"]==true? TextStyle(decoration: TextDecoration.lineThrough,fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 55, 69),
                                      ):TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 55, 69),
                                    ),
                                    ),
                                  )
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: GestureDetector( 
                                      onTap: ()  {
                                       removeItem(index);
                                      },
                                      child: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(137, 105, 105, 105),
                                      size: 20,
                                    )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        );
                      }
                    )
                  ]
                )
                );
              }})
            ]
          )
        )
      ]
      )),                          
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 191, 153, 14),
        onPressed: (){
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AddPage(),
            ),
          );
          setState(() {});
        },
          label:Row(children: const [Icon(Icons.add),SizedBox(width: 5,),Text("Create Note",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),)],)
      ),
    );
  }
}