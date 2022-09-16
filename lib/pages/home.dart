import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:journaling_app/pages/all_checklists.dart';
import 'package:journaling_app/sharedPreferences.dart';
import 'add_page.dart';
import 'edit_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();

  List<dynamic> journals = [];
  late Widget profileIcon;
  String emoticon = "129489";
  TextEditingController addChecklistController = TextEditingController();
  
  setNotes()async{
    String? allChecklists  = await sharedPreferences.getFromSharedPref('user-journals');
    if (allChecklists!=null) {
      List<dynamic> notesDecoded = jsonDecode(allChecklists);
      List reversedList = List.from(notesDecoded.reversed);
      return reversedList;
    }
  }

  setChecklists()async{
    String? allJournals  = await sharedPreferences.getFromSharedPref('all-checklist');
    if (allJournals!=null) {
      List<dynamic> notesDecoded = jsonDecode(allJournals);
      print(allJournals);
      List reversedList = List.from(notesDecoded.reversed);
      if(reversedList.length>3){
      var myRange = reversedList.getRange(0, 3).toList();
      return myRange;
      }else{
        return reversedList;
      }
    }
  }

  
  removeItem(int index) async {
    String? allJournals  = await sharedPreferences.getFromSharedPref('all-checklist');
    if(allJournals!=null){
      List decodedList = jsonDecode(allJournals);
      List reversedList = List.from(decodedList.reversed);
      reversedList.removeAt(index);
      List finalList = List.from(reversedList.reversed);
      await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(finalList));
      setState(() {
        
      });
    }
    
    
  }

  taskUpdation(int index) async{
    String? allJournals  = await sharedPreferences.getFromSharedPref('all-checklist');
    if(allJournals!=null){
      List<dynamic> notesDecoded = jsonDecode(allJournals);
      List reversedList = List.from(notesDecoded.reversed);
      reversedList.removeAt(index);
      await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(reversedList));
    }
  }

  submitCheckLists()async{
    if(addChecklistController.text.isEmpty){
      print("bruh");
    }else{
      String? allJournals  = await sharedPreferences.getFromSharedPref('all-checklist');
      if (allJournals!=null) {
        List decodedJournals = jsonDecode(allJournals);
        decodedJournals.add(addChecklistController.text);
        await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(decodedJournals));
        print(decodedJournals);
        setState(() {
          
        });
      }else{
        List checklist = [];
        checklist.add(addChecklistController.text);
        await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(checklist));
        print(checklist);
        setState(() {
          
        });
      }
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    try {
      double.parse(s);
      return true;
    } catch (e) {
      return false;
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
        title: const Text("JournalIt", style: TextStyle(color: Color.fromARGB(255, 93, 22, 22), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
      ),
      body:Container(
        
      child:ListView(children: [
      Container(
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
              padding: EdgeInsets.only(left:20,top: 15, bottom: 10, right: 20),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                
                Text("All Journals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 52, 63, 71)),
                ),
                Row(
                  children: [
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
            future: setNotes(),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(child:Text('No notes to display'));
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
                      padding: EdgeInsets.only(top: 10),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      
                      itemBuilder: (context, index) {
                        setProfileIcons(snapshot.data[index]);
                        print(snapshot.data[index]);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                          height: 79,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                              ),
                          child: Card(
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
                                                  fontWeight: FontWeight.bold),
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
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => 
                                          EditPage(
                                            title: snapshot.data[index]["title"],
                                            body: snapshot.data[index]["body"],
                                            tag: snapshot.data[index]["tags"],
                                            index: index,
                                          )),
                                        );
                                      },
                                      child: const Icon(
                                      Icons.arrow_forward_ios_outlined,
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
                   margin: EdgeInsets.only(left:10, right: 10),
                   
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 220, 215, 179)
                  ),
                  child:
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     
                      ListView.builder(
                      padding: EdgeInsets.only(top: 5),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,

                      itemBuilder: (context, index) {
                        // return Column(
                        //   children:[]
                        // );
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
                                  const SizedBox(width: 10),
                                    Expanded(
                                          child:Text(snapshot.data[index],
                                              maxLines:1,
                                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 55, 69),
                                          )),
                                      // const SizedBox(height: 5),
                                      // Row(
                                      //   children: [

                                      //     Text(
                                      //       snapshot.data[index]["tags"],
                                      //       style: const TextStyle(
                                      //       fontSize: 12, fontWeight: FontWeight.w500),
                                      //     ),
                                      //   ],
                                      // ),
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
    ]))])),                          
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 191, 153, 14),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
            setState(() {
    // Call setState to refresh the page.
          });
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}