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

  List categories = ["General"];
  int length =0;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    getCategories();
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

   setCategories()async {
    String? allCategories = await sharedPreferences.getFromSharedPref('all-categories');
    if (allCategories == null) {
      await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(categories));
      return categories;
    } else {
      List  setCategories = jsonDecode(allCategories);
      return setCategories;
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

  removeCategory(int index) async {
    if(index==0){
      fToast.init(context);
      showToast(fToast, "Cannot delete this category", NotificationStatus.failure);
    }
    else{
      String? allCategories = await sharedPreferences.getFromSharedPref('all-categories');
      if(allCategories!=null){
        List decodedList = jsonDecode(allCategories);
        decodedList.removeAt(index);
        await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(decodedList));
        fToast.init(context);
        showToast(fToast, "Category successfully deleted", NotificationStatus.success);
      } 
    }
  }

  confirmDelete(int index){
    return showDialog(
              context: context,
              builder: (BuildContext context){
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container( 
                    height: 150,
                      padding: EdgeInsets.all(10),
                      child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Text("Are you sure you want to delete this category : ${categories[index]}",textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
                        SizedBox(height: 30,),
                        GestureDetector(
                          onTap: () {
                            removeCategory(index);
                            Navigator.pop(context);
                            
                          },
                          child: Text("Confirm", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        )
                      ],
                  )));
              
              });
  }

  deleteWidget(){
    return showDialog(
              context: context,
              builder: (BuildContext context){
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      height: 400,
                      padding: EdgeInsets.all(10),
                      child:SingleChildScrollView(child: Column(
                      children: [
                        
                FutureBuilder(
            future: setCategories(),
            builder:(context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(child:Text('No categories to display'));
              } else if (!snapshot.hasData) {
                return const Center(
                    child: Text("No categories to display"));
              } else {
                return 
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      snapshot.data==null?
                        const Center(child:Text("No categories to display"))
                        :
                      ListView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      
                      itemBuilder: (context, index) {
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
                                      onTap: () async {
                                       confirmDelete(index);
                                       setState(() { });
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
                      },)

                      ],
                    );}})
                    ]))));
              }
            );
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text("Categories", style: TextStyle(color: Color.fromARGB(255, 93, 22, 22), fontWeight: FontWeight.bold)),
              GestureDetector(
              onTap: () {
                deleteWidget();
              },
              child:Icon(Icons.delete, color: Colors.black54,)
            )
            ],),
        backgroundColor: Colors.amber,
      ),
      // body:Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children:[
      //   Padding(padding: EdgeInsets.only(top: 20)),
      //   GestureDetector(
      //     onTap:(){ setState(() {});},
      //     child: Row(children: [
      //       SizedBox(width: 15),
      //       Text("Refresh", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 86, 127, 160)),),
      //       SizedBox(width: 3,),
      //       Icon(Icons.refresh, size: 17,color:Color.fromARGB(255, 86, 127, 160))
      //     ]),
      //   ),
        body:SingleChildScrollView(
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