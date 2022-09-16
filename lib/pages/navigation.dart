import 'package:flutter/material.dart';
import 'package:journaling_app/pages/folder.dart';
import 'package:journaling_app/pages/settings.dart';

import 'all_checklists.dart';
import 'home.dart';


class Navigation extends StatefulWidget {

  Navigation({Key? key}) : super(key: key);
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[HomePage(), FolderPage(),AllChecklist()];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 219, 210, 127),
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        
        bottomNavigationBar: 
        Container(                                             
      decoration: BoxDecoration(                                                  
        borderRadius: BorderRadius.only(                                           
          topRight: Radius.circular(30), topLeft: Radius.circular(30)),            
        boxShadow: [                                                               
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),       
        ],                                                                         
      ),                                                                           
      child: ClipRRect(                                                            
        borderRadius: BorderRadius.only(                                           
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
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.settings),
            //   label: 'Settings',
            // )
          ],
        
          selectedItemColor: Colors.grey[200],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ))));
  }
}
