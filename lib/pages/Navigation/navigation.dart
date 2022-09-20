import 'package:flutter/material.dart';
import 'package:journaling_app/pages/Journals/folder.dart';
import 'package:journaling_app/pages/Settings/settings.dart';

import '../Journals/all_checklists.dart';
import '../Journals/home.dart';


class Navigation extends StatefulWidget {

  Navigation({Key? key}) : super(key: key);
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[const HomePage(), const FolderPage(),const AllChecklist()];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 210, 127),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
        bottomNavigationBar: 
          Container(                                             
          decoration: const BoxDecoration(                                                  
            borderRadius: BorderRadius.only(                                           
            // ignore: unnecessary_const
            topRight: const Radius.circular(30), topLeft: Radius.circular(30)),            
            boxShadow: [                                                               
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),       
            ],                                                                         
          ),                                                                           
          child: ClipRRect(                                                            
            borderRadius: const BorderRadius.only(                                           
            topLeft: Radius.circular(30.0),                                            
            topRight: Radius.circular(30.0),                                           
            ),  child:BottomNavigationBar(
            
            backgroundColor: Colors.amber,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist),
                label: 'Task list',
              ),
            ],
            selectedItemColor: Colors.grey[200],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          )
        )
      )
    );
  }
}
