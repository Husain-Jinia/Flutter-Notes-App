import 'dart:convert';

import 'package:flutter/material.dart';

import '../sharedPreferences.dart';

class AllChecklist extends StatefulWidget {
  const AllChecklist({Key? key}) : super(key: key);

  @override
  State<AllChecklist> createState() => _AllChecklistState();
}


class _AllChecklistState extends State<AllChecklist> {

   SharedPreferencesService sharedPreferences = SharedPreferencesService();
   List checklist = [];
   TextEditingController addChecklistController = TextEditingController();

    setChecklists()async{
    String? allJournals  = await sharedPreferences.getFromSharedPref('all-checklist');
    if (allJournals!=null) {
      List<dynamic> notesDecoded = jsonDecode(allJournals);
      List reversedList = List.from(notesDecoded.reversed);
      return reversedList;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        title: const Text("All Task Lists", style: TextStyle(color: Color.fromARGB(255, 93, 22, 22), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
      ),
      body: 
      Container(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        child:SingleChildScrollView(child:Container(child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
            padding: EdgeInsets.all(15),
            child: Text("All checklists",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 60, 80))),
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
                return Center(child:Text('No notes to display'));
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text("No notes to display"));
              } else {
                return 
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      snapshot.data==null?
                        Container(
                          child:Center(child:Text("No journals to display"))
                        ):
                      ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      
                      itemBuilder: (context, index) {
                        print(snapshot.data[index]);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                              ),
                          child: Card(
                            elevation: 1,
                            margin: EdgeInsets.zero,
                            color:  Colors.grey[100],
                            child: ListTile(
                              // contentPadding: const EdgeInsets.only(left: 8, bottom: 4, top: 2, right: 4),
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
                    })
                  ]
                
              );
            }
          }
        )
        ]
        )))
      )
    );
  }
}