import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journaling_app/pages/Journals/edit_page.dart';

import '../../sharedPreferences.dart';


class AllJournals extends StatefulWidget {

  final String tag;

  const AllJournals({Key? key, required this.tag}) : super(key: key);

  @override
  State<AllJournals> createState() => _AllJournalsState();
}

class _AllJournalsState extends State<AllJournals> {

   SharedPreferencesService sharedPreferences = SharedPreferencesService();

  List<dynamic> journals = [];
  late Widget profileIcon;
  String emoticon = "129489";
  String currentTag="";

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentTag = widget.tag;
    
  }


  setNotes()async{
    String? allChecklists  = await sharedPreferences.getFromSharedPref('user-journals');
    if (allChecklists!=null) {
      List<dynamic> notesDecoded = jsonDecode(allChecklists);
      List reversedList = List.from(notesDecoded.reversed);
      List finalList =[];
      for (var i = 0; i < reversedList.length; i++) {
        if(reversedList[i]["tags"]==currentTag){
          finalList.add(reversedList[i]);
        }
      }
      return finalList;
    }else{
    return null;
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
      body: 
      Container(
        padding: EdgeInsets.only(top: 15, bottom: 10),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
            padding: const EdgeInsets.all(15),
            child: Text("CATEGORY : ${currentTag.toUpperCase()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 60, 80))),
          ),
          FutureBuilder(
            future: setNotes(),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(child:Text('No notes to display'));
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
                        const Center(child:Text("No journals to display"))
                        :
                      ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      
                      itemBuilder: (context, index) {
                        setProfileIcons(snapshot.data[index]);
                        print(snapshot.data[index]);
                        
                        return
                        
                        Container(
                          margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
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
                                            style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 55, 69),
                                        )),
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
                
              );
            }
          }
        )
        ]
      )
      )
    );
  }
}